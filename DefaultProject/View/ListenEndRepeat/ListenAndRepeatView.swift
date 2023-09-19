//
//  ListenAndRepeatView.swift
//  DefaultProject
//
//  Created by daktech on 15/08/2023.
//

import SwiftUI
import AVFoundation
import Speech

struct ListenAndRepeatView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var synthesizer = AVSpeechSynthesizer()
    @State private var audioPlayer: AVAudioPlayer?
    @State private var countCorrect = 0
    @State private var countWrong = 0
    @State private var selectedTab = 0
    @State private var progress = 0.5
    @State private var countFail = 0
    @State private var answerCorrect = ""
    @State private var titleButon = "CONTINUE"
    @State private var isCorrect = false
    @State private var isFail = false
    @State private var isShowPopup = false
    @State private var isHide: Bool = true
    @State private var isSpeaking: Bool = false
    @State private var checkPermission: Bool = false
    
    var body: some View {
        ZStack(alignment: .top){
            VStack{ 
                HStack{
                    Button {
                        coordinator.pop()
                    } label: {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .foregroundColor(Color.background)
                        Text("Listen and repeat".cw_localized)
                            .font(.bold(size: 24))
                            .foregroundColor(Color.background)
                    }
                    .hAlign(.leading)
                }
                
                ListenAndRPInfoView(countCorrect: $countCorrect, countWrong: $countWrong, selectedTab: $selectedTab, progress: $progress)
                
                VStack{
                    TabView(selection: $selectedTab) {
                        ForEach(CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.indices, id: \.self) { index in
                            ListenAndRPContentView(speechRecognizer: speechRecognizer,synthesizer: synthesizer,index: index ,isSpeaking: $isSpeaking, isHide: $isHide, countCorrect: $countCorrect, countWrong: $countWrong, selectedTab: $selectedTab){
                                handleTapToSpeak(answer: CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT[index].answer.cw_localized)
                            }
                            .tag(index)
                            .contentShape(Rectangle()).gesture(DragGesture())
                            .onAppear{
                                answerCorrect = CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT[index].answer
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8 ,execute: {
                                    if !synthesizer.isSpeaking{
                                        speakText(textToSpeak: CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT[index].answer.cw_localized)
                                    }else{
                                        synthesizer.stopSpeaking(at: .immediate)
                                    }
                                })
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
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
                PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, title: "Listen and repeat", totalQuestion: CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.count)
            }
            .onTapGesture {
                withAnimation {
                    isCorrect = false
                    isFail = false
                }
            }
            
            if isCorrect{
                SheetShowAnswerCorrectView(answer: $answerCorrect){
                    withAnimation {
                        isCorrect = false
                    }
                }
                .animation(.easeInOut, value: isCorrect)
                .onDisappear{
                    synthesizer.stopSpeaking(at: .immediate)
                    if selectedTab < CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.count - 1 {
                        progress += 1
                        resetSpeak()
                        withAnimation {
                            selectedTab += 1
                            isCorrect = false
                        }
                        countFail = 0
                    }else{
                        loadAudio(nameSound: "congralutions")
                        withAnimation {
                            isCorrect = false
                        }
                        withAnimation {
                            isShowPopup = true
                            QuizTimer.shared.reset()
                        }
                    }
                }
            }
            
            if isFail{
                SheetShowAnswerFailedView(answer: $answerCorrect, titleButon: $titleButon){
                    withAnimation {
                        isFail = false
                    }
                }
                .animation(.easeInOut, value: isFail)
                .onDisappear{
                    if countFail < 2{
                        withAnimation {
                            isFail = false
                            countFail += 1
                        }
                    }else{
                        countWrong += 1
                        if selectedTab < CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.count - 1 {
                            progress += 1
                            resetSpeak()
                            withAnimation {
                                selectedTab += 1
                                isFail = false
                            }
                            countFail = 0
                        }else{
                            loadAudio(nameSound: "congralutions")
                            withAnimation {
                                isShowPopup = true
                                QuizTimer.shared.reset()
                            }
                        }
                    }
                }
            }
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
    }

    func handleTapToSpeak(answer: String){
        if selectedTab < CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.count - 1 || !(countWrong + countCorrect == CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.count){
            audioPlayer?.pause()
            if !isSpeaking {
                isSpeaking = true
                synthesizer.stopSpeaking(at: .immediate)
                speechRecognizer.transcribe()
            } else {
                isSpeaking = false
                speechRecognizer.stopTranscribing()
                if speechRecognizer.transcript.lowercased().cw_localized == answer.lowercased(){
                    loadAudio(nameSound: "correct")
                    DispatchQueue.main.async {
                        isCorrect = true
                    }
                    countCorrect += 1
                }else{
                    loadAudio(nameSound: "wrong")
                    if countFail < 2{
                        titleButon = "Again"
                    }else{
                        titleButon = "Understand"
                    }
                    DispatchQueue.main.async {
                        isFail = true
                    }
                }
            }
        }else if selectedTab == CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.count - 1 && (countWrong + countCorrect == CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.count){
            loadAudio(nameSound: "congralutions")
            withAnimation {
                isShowPopup = true
            }
            audioPlayer?.pause()
        }
        speechRecognizer.transcript = ""
    }
    
    func speakText(textToSpeak: String) {
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
    func resetSpeak(){
        speechRecognizer.transcript = ""
        speechRecognizer.reset()
        isSpeaking = false
    }
    
    func loadAudio(nameSound: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch let err{
            print(err.localizedDescription)
            speechRecognizer.transcript = "Something went wrong, please try again !"
        }
        if let audioURL = Bundle.main.url(forResource: nameSound, withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            DispatchQueue.main.async {
                audioPlayer?.play()
            }
        }
    }
}

