//
//  WritingView.swift
//  DefaultProject
//
//  Created by daktech on 16/08/2023.
//

import SwiftUI
import AVFAudio
import Speech

enum FocusedField {
    case textWriting
}
struct WritingView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @FocusState private var focusedField: FocusedField?
    @State var audioPlayer: AVAudioPlayer?
    @State var synthesizer = AVSpeechSynthesizer()
    @State var countCorrect = 0
    @State var countWrong = 0
    @State private var selectedTab = 0
    @State private var progress = 0.5
    @State private var isCorrect = false
    @State private var isShowPopup = false
    @State var isShowPopupCheck: Bool = false
    @State private var checkPermission: Bool = false
    @State var textWriting: String = ""
    @State var answer: String = ""
    
    var body: some View {
        ZStack (alignment: .top){
            VStack{
                HStack{
                    Button {
                        coordinator.pop()
                    } label: {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .foregroundColor(Color.background)
                        Text("Writing".localizedLanguage(language: language))
                            .font(.bold(size: 24))
                            .foregroundColor(Color.background)
                    }
                    .hAlign(.leading)
                }
                
                QuizWritingInfoView(progress: $progress, selectedTab: $selectedTab, countCorrect: $countCorrect, countWrong: $countWrong, isShowPopupCheck: $isShowPopupCheck)
                
                VStack{
                    TabView(selection: $selectedTab) {
                        ForEach(QUIZDEFAULT.SHARED.listWriting.indices, id: \.self) { index in
                            QuizWritingContentView(audioPlayer: audioPlayer ,synthesizer: synthesizer, textWriting: $textWriting, answer: $answer, countCorrect: $countCorrect, countWrong: $countWrong, index: index, selectedTab: $selectedTab, isCorrect: $isCorrect, isShowPopup: $isShowPopup, isShowPopupCheck: $isShowPopupCheck)
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
                PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, totalQuestion: QUIZDEFAULT.SHARED.listWriting.count)
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
            if isShowPopupCheck{
                QuestionResultWritingView(isCorrect: $isCorrect, isShowPopupCheck: $isShowPopupCheck, answer: $answer) {
                    handleContinue()
                }
            }
        }
    }
    
    func handleContinue(){
        synthesizer.stopSpeaking(at: .immediate)
        if selectedTab != QUIZDEFAULT.SHARED.listWriting.count - 1 && (countWrong + countCorrect != QUIZDEFAULT.SHARED.listWriting.count){
            textWriting = ""
        }
        focusedField = nil
        
        if selectedTab < QUIZDEFAULT.SHARED.listWriting.count - 1 {
            isShowPopupCheck = false
            progress += 1
            isCorrect = false
            withAnimation {
                selectedTab += 1
            }
        }else{
            withAnimation {
                isShowPopup = true
            }
            audioPlayer?.pause()
            if countCorrect == 0{
                loadAudio(nameSound: "wrong")
            }else{
                loadAudio(nameSound: "congralutions")
            }
        }
    }
    
    func loadAudio(nameSound: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        if let audioURL = Bundle.main.url(forResource: nameSound, withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            DispatchQueue.main.async {
                audioPlayer?.play()
            }
        }
    }
}

