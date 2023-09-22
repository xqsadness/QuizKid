//
//  MathView.swift
//  DefaultProject
//
//  Created by darktech4 on 11/08/2023.
//

import SwiftUI
import AVFoundation

struct MathView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
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
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.background)
                    Text("Math".cw_localized)
                        .font(.bold(size: 24))
                        .foregroundColor(Color.background)
                }
                .hAlign(.leading)
            }
            
            MathInfoView(countCorrect: $countCorrect, countWrong: $countWrong, selectedTab: $selectedTab, progress: $progress)
                .onTapGesture {
                    isShowPopup.toggle()
                }
            
            VStack{
                TabView(selection: $selectedTab) {
                    ForEach(CONSTANT.SHARED.DATA_MATH.indices, id: \.self) { index in
                        MathContentView(synthesizer: synthesizer, index: index, isSubmit: $isSubmit, selectedAnswer: $selectedAnswer, offset: $offset)
                            .tag(index)
                            .contentShape(Rectangle()).gesture(DragGesture())
                            .onAppear{
                                answerCorrect = CONSTANT.SHARED.DATA_MATH[index].answer
                            }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                MathSubmitNextButtonsView(audioPlayer: audioPlayer, synthesizer: $synthesizer, selectedAnswer: $selectedAnswer, answerCorrect: $answerCorrect, isSubmit: $isSubmit, isCorrect: $isCorrect, selectedTab: $selectedTab, progress: $progress, isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, offset: $offset)
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
            PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, title: "Math", totalQuestion: CONSTANT.SHARED.DATA_MATH.count)
        }
        .onAppear{
            QuizTimer.shared.start()
        }
        .onDisappear{
            QuizTimer.shared.reset()
        }
    }
}

