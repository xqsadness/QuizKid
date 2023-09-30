//
//  ColorView.swift
//  DefaultProject
//
//  Created by daktech on 15/08/2023.
//

import SwiftUI
import AVFAudio
import Speech

struct ColorView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var textToSpeak: String = ""
    @State private var selectedAnswer = ""
    @State private var answerCorrect: [String] = []
    @State private var isCorrect = false
    @State private var isSubmit = false
    @State private var isShowPopup = false
    @State private var isCheckFailSpeech: Bool = false
    @State private var isCheckFailBtn: Bool = false
    @State private var progress = 0.5
    @State private var selectedTab = 0
    @State var countCorrect = 0
    @State var countWrong = 0
    @State var offset: CGFloat = -10
    @State var audioPlayer: AVAudioPlayer?
    @State var synthesizer = AVSpeechSynthesizer()
    @State private var checkPermission: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.background)
                    Text("Color".cw_localized)
                        .font(.bold(size: 24))
                        .foregroundColor(Color.background)
                }
                .hAlign(.leading)
            }
            
            ColorInfoView(countCorrect: $countCorrect, countWrong: $countWrong, selectedTab: $selectedTab, progress: $progress)
            
            VStack{
                TabView(selection: $selectedTab) {
                    ForEach(CONSTANT.SHARED.DATA_COLOR.indices, id: \.self) { index in
                        ColorContentView(speechRecognizer: speechRecognizer ,index: index, isSubmit: $isSubmit, selectedAnswer: $selectedAnswer, offset: $offset,isCheckFailSpeech: $isCheckFailSpeech){
                            handleTapToSpeak(answer: CONSTANT.SHARED.DATA_COLOR[index].answer)
                        }
                        .tag(index)
                        .contentShape(Rectangle()).gesture(DragGesture())
                        .onAppear{
                            answerCorrect = CONSTANT.SHARED.DATA_COLOR[index].answer
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                ColorSubmitNextButtonsView(audioPlayer: audioPlayer,speechRecognizer: speechRecognizer ,synthesizer: $synthesizer, selectedAnswer: $selectedAnswer, answerCorrect: $answerCorrect, isSubmit: $isSubmit, isCorrect: $isCorrect, selectedTab: $selectedTab, progress: $progress, isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, offset: $offset,isCheckFailSpeech: $isCheckFailSpeech)
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
            PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, title: "Color", totalQuestion: CONSTANT.SHARED.DATA_COLOR.count)
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
                    if selectedTab < CONSTANT.SHARED.DATA_COLOR.count - 1{
                        submitCorrect()
                    }else{
                        isSubmit = true
                        selectedAnswer = "temp"
                        completeAllQuestion()
                    }
                }else{
                    if selectedTab < CONSTANT.SHARED.DATA_COLOR.count - 1{
                        selectedAnswer = "temp"
                        isCheckFailSpeech = true
                        isSubmit = true
                        loadAudio(nameSound: "wrong")
                        isCorrect = false
                        countWrong += 1
                    }else{
                        isSubmit = true
                        isCheckFailSpeech = true
                        selectedAnswer = "temp"
                        completeAllQuestion()
                    }
                }
                speechRecognizer.transcript = ""
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
        if !speechRecognizer.isSpeaking {
            speechRecognizer.isSpeaking = true
            
            speechRecognizer.transcribe()
            isCheckFailBtn = false
        } else {
            isCheckFailBtn = true
            speechRecognizer.isSpeaking = false
            speechRecognizer.stopTranscribing()
            
            offset = -10
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
                if selectedTab < CONSTANT.SHARED.DATA_COLOR.count - 1{
                    submitCorrect()
                }else{
                    isSubmit = true
                    selectedAnswer = "temp"
                    completeAllQuestion()
                }
            }else{
                if selectedTab < CONSTANT.SHARED.DATA_COLOR.count - 1{
                    selectedAnswer = "temp"
                    isCheckFailSpeech = true
                    isSubmit = true
                    loadAudio(nameSound: "wrong")
                    isCorrect = false
                    countWrong += 1
                }else{
                    isSubmit = true
                    selectedAnswer = "temp"
                    isCheckFailSpeech = true
                    completeAllQuestion()
                }
            }
        }
        speechRecognizer.transcript = ""
    }
}

