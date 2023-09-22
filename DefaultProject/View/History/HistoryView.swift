//
//  HistoryView.swift
//  DefaultProject
//
//  Created by daktech on 14/08/2023.
//

import SwiftUI
import AVFoundation

struct HistoryView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @State var synthesizer = AVSpeechSynthesizer()
    @State private var textToSpeak: String = ""
    @State private var selectedAnswer = ""
    @State private var answerCorrect: [String] = []
    @State private var selectedTab = 0
    @State private var progress = 0.5
    @State var countCorrect = 0
    @State var countWrong = 0
    @State var offset: CGFloat = -10
    @State private var isCorrect = false
    @State private var isSubmit = false
    @State private var isShowPopup = false
    
    
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
                    Text("History".cw_localized)
                        .font(.bold(size: 24))
                        .foregroundColor(Color.background)
                }
                .hAlign(.leading)
            }
            
            HistoryInfoView(countCorrect: $countCorrect, countWrong: $countWrong, selectedTab: $selectedTab, progress: $progress)
            
            VStack{
                TabView(selection: $selectedTab) {
                    ForEach(CONSTANT.SHARED.DATA_HISTORY.indices, id: \.self) { index in
                        HistoryContentView(synthesizer: synthesizer, index: index, isSubmit: $isSubmit, selectedAnswer: $selectedAnswer, offset: $offset)
                            .tag(index)
                            .contentShape(Rectangle()).gesture(DragGesture())
                            .onAppear{
                                answerCorrect = CONSTANT.SHARED.DATA_HISTORY[index].answer
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8 ,execute: {
                                    if !synthesizer.isSpeaking{
                                        speakText(textToSpeak: CONSTANT.SHARED.DATA_HISTORY[index].question.cw_localized)
                                    }else{
                                        synthesizer.stopSpeaking(at: .immediate)
                                    }
                                })
                            }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HistorySubmitNextButtonsView(synthesizer: $synthesizer, selectedAnswer: $selectedAnswer, answerCorrect: $answerCorrect, isSubmit: $isSubmit, isCorrect: $isCorrect, selectedTab: $selectedTab, progress: $progress, isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, offset: $offset)
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
            PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, title: "History ", totalQuestion: CONSTANT.SHARED.DATA_HISTORY.count)
        }
        .onAppear{
            QuizTimer.shared.start()
        }
        .onDisappear{
            QuizTimer.shared.reset()
            synthesizer.stopSpeaking(at: .immediate)
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
}

