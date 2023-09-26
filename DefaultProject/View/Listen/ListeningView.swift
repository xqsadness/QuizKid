//
//  ListeningView.swift
//  DefaultProject
//
//  Created by darktech4 on 12/08/2023.
//

import SwiftUI
import AVFAudio
import Speech

struct ListeningView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var audioPlayer: AVAudioPlayer?
    @State var synthesizer = AVSpeechSynthesizer()
    @State var countCorrect = 0
    @State var countWrong = 0
    @State private var selectedTab = 0
    @State private var progress = 0.5
    @State var offset: CGFloat = -10
    @State private var selectedAnswer = ""
    @State private var answerCorrect: [String] = []
    @State private var isCorrect = false
    @State private var isSubmit = false
    @State private var isShowPopup = false
    @State private var isCheckFailBtn: Bool = false
    @State private var isCheckFailSpeech: Bool = false
    @State private var checkPermission: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    synthesizer.stopSpeaking(at: .immediate)
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.background)
                    Text("Listen".cw_localized)
                        .font(.bold(size: 24))
                        .foregroundColor(Color.background)
                }
                .hAlign(.leading)
            }
            
            ListeningInfoView(countCorrect: $countCorrect, countWrong: $countWrong, selectedTab: $selectedTab, progress: $progress)
            
            VStack{
                TabView(selection: $selectedTab) {
                    ForEach(CONSTANT.SHARED.DATA_LISTEN.indices, id: \.self) { index in
                        ListenContentView(synthesizer: synthesizer,speechRecognizer: speechRecognizer ,index: index, isSubmit: $isSubmit, selectedAnswer: $selectedAnswer, offset: $offset,isCheckFailSpeech: $isCheckFailSpeech){
                            handleTapToSpeak(answer: CONSTANT.SHARED.DATA_LISTEN[index].answer)
                        }
                        .tag(index)
                        .contentShape(Rectangle()).gesture(DragGesture())
                        .onAppear{
                            answerCorrect = CONSTANT.SHARED.DATA_LISTEN[index].answer
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 ,execute: {
                                if !speechRecognizer.isSpeaking{
                                    if !synthesizer.isSpeaking{
                                        if let answer = CONSTANT.SHARED.DATA_LISTEN[index].answer.first{
                                            speakText(textToSpeak: answer.cw_localized)
                                        }
                                    }else{
                                        synthesizer.stopSpeaking(at: .immediate)
                                    }
                                }
                            })
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                ListeningSubmitNextButtonsView(audioPlayer: audioPlayer, speechRecognizer: speechRecognizer, synthesizer: $synthesizer, selectedAnswer: $selectedAnswer, answerCorrect: $answerCorrect, isSubmit: $isSubmit, isCorrect: $isCorrect, selectedTab: $selectedTab, progress: $progress, isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, offset: $offset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.text)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 2)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.text)
        .navigationBarBackButtonHidden(true)
        .popup(isPresented: $isShowPopup) {
            PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, title: "Listening", totalQuestion: CONSTANT.SHARED.DATA_LISTEN.count)
        }
        .overlay{
            if checkPermission{
                PermissionsNoticeView(message: "Please allow access speech and voice")
                    .environmentObject(coordinator)
            }
        }
        .onAppear {
            Task(priority: .background) {
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    checkPermission = true
                    return
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    checkPermission = true
                    return
                }
            }
        }
        .onAppear{
            QuizTimer.shared.start()
        }
        .onDisappear{
            QuizTimer.shared.reset()
            synthesizer.stopSpeaking(at: .immediate)
        }
        .onChange(of: speechRecognizer.isTimeout) { newValue in
            if newValue && !isCheckFailBtn{
                offset = -10
                
                var isAnswerCorrect = false
                
                for i in answerCorrect {
                    if speechRecognizer.transcript.cw_localized.lowercased() == i.cw_localized.lowercased(){
                        loadAudio(nameSound: "correct")
                        isCorrect = true
                        countCorrect += 1
                        isAnswerCorrect = true
                        break
                    }
                }
                
                if isAnswerCorrect {
                    if selectedTab < CONSTANT.SHARED.DATA_LISTEN.count - 1{
                        submitCorrect()
                    }else{
                        isSubmit = true
                        selectedAnswer = "temp"
                        completeAllQuestion()
                    }
                }else{
                    if selectedTab < CONSTANT.SHARED.DATA_LISTEN.count - 1{
                        selectedAnswer = "temp"
                        isCheckFailSpeech = true
                        isSubmit = true
                        loadAudio(nameSound: "wrong")
                        isCorrect = false
                        countWrong += 1
                    }else{
                        isSubmit = true
                        selectedAnswer = "temp"
                        completeAllQuestion()
                    }
                }
                speechRecognizer.transcript = ""
            }
        }
    }
    
    func speakText(textToSpeak: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.35
        synthesizer.speak(utterance)
    }
    
    func loadAudio(nameSound: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch let err{
            print(err.localizedDescription)
        }
        if let audioURL = Bundle.main.url(forResource: nameSound, withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            DispatchQueue.main.async {
                audioPlayer?.play()
            }
        }
    }
    
    func submitCorrect(){
        // processed after answering 1 question correctly
        progress += 1
        selectedAnswer = ""
        isSubmit = false
        isCorrect = false
        withAnimation {
            selectedTab += 1
        }
    }
    
    func completeAllQuestion(){
        // processed upon completion of All Questions
        withAnimation {
            isShowPopup = true
        }
        audioPlayer?.pause()
        if countCorrect == 0{
            loadAudio(nameSound: "wrong")
        }else{
            loadAudio(nameSound: "congralutions")
        }
        QuizTimer.shared.stop()
    }
    
    func handleTapToSpeak(answer: [String]){
        synthesizer.stopSpeaking(at: .immediate)
        if !speechRecognizer.isSpeaking {
            speechRecognizer.isSpeaking = true
            
            speechRecognizer.transcribe()
            isCheckFailBtn = false
        } else {
            isCheckFailBtn = true
            speechRecognizer.isSpeaking = false
            speechRecognizer.stopTranscribing()
            
            offset = -10
            
            var isAnswerCorrect = false
            
            for i in answerCorrect {
                if speechRecognizer.transcript.cw_localized.lowercased() == i.cw_localized.lowercased(){
                    loadAudio(nameSound: "correct")
                    isCorrect = true
                    countCorrect += 1
                    isAnswerCorrect = true
                    break
                }
            }
            
            if isAnswerCorrect {
                if selectedTab < CONSTANT.SHARED.DATA_LISTEN.count - 1{
                    submitCorrect()
                }else{
                    isSubmit = true
                    selectedAnswer = "temp"
                    completeAllQuestion()
                }
            }else{
                if selectedTab < CONSTANT.SHARED.DATA_LISTEN.count - 1{
                    selectedAnswer = "temp"
                    isCheckFailSpeech = true
                    isSubmit = true
                    loadAudio(nameSound: "wrong")
                    isCorrect = false
                    countWrong += 1
                }else{
                    completeAllQuestion()
                }
            }
        }
        speechRecognizer.transcript = ""
    }
}

