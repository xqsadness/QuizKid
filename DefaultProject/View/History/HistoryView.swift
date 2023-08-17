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
    @State private var answerCorrect = ""
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
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.background)
                    Text("History".localizedLanguage(language: language))
                        .font(.bold(size: 24))
                        .foregroundColor(Color.background)
                }
                .hAlign(.leading)
            }
            
            HistoryInfoView(countCorrect: $countCorrect, countWrong: $countWrong, selectedTab: $selectedTab, progress: $progress)
            
            VStack{
                TabView(selection: $selectedTab) {
                    ForEach(QUIZDEFAULT.SHARED.listQuestionsHistory.indices, id: \.self) { index in
                        HistoryContentView(synthesizer: synthesizer, index: index, isSubmit: $isSubmit, selectedAnswer: $selectedAnswer, offset: $offset)
                            .tag(index)
                            .contentShape(Rectangle()).gesture(DragGesture())
                            .onAppear{
                                answerCorrect = QUIZDEFAULT.SHARED.listQuestionsHistory[index].answer
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
            PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, totalQuestion: QUIZDEFAULT.SHARED.listQuestionsHistory.count)
        }
    }
}

