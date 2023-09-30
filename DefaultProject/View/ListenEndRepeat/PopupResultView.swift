//
//  PopupResultView.swift
//  DefaultProject
//
//  Created by darktech4 on 27/09/2023.
//

import SwiftUI
import AVFAudio

struct PopupResultView: View {
    @State var synthesizer: AVSpeechSynthesizer
    @State var speechRecognizer: SpeechRecognizer
    @Binding var isCorrect: Bool
    @Binding var isFail: Bool
    @Binding var isShowPopup: Bool
    @Binding var progress: Double
    @Binding var selectedTab: Int
    @Binding var countWrong: Int
    @Binding var countFail: Int
    @Binding var answerCorrectSpeaking: String
    @Binding var titleButon: String
    @Binding var data: [QUIZ_ARRAY]
    
    var loadAudio: ((String) -> Void)
    
    var body: some View {
        if isCorrect{
            VStack{}
                .vAlign(.center)
                .hAlign(.center)
                .background(.background).opacity(0.15)
                .onTapGesture {
                    withAnimation {
                        isCorrect = false
                    }
                }
            
            SheetShowAnswerCorrectView(answer: $answerCorrectSpeaking){
                withAnimation {
                    isCorrect = false
                }
            }
            .vAlign(.bottom)
            .animation(.easeInOut, value: isCorrect)
            .onDisappear{
                synthesizer.stopSpeaking(at: .immediate)
                if selectedTab < data.count - 1 {
                    progress += 1
                    resetSpeak()
                    withAnimation {
                        selectedTab += 1
                        isCorrect = false
                    }
                    countFail = 0
                }else{
                    loadAudio("congralutions")
                    withAnimation {
                        isCorrect = false
                    }
                    withAnimation {
                        isShowPopup = true
                        QuizTimer.shared.stop()
                    }
                }
            }
        }
        
        if isFail{
            VStack{}
                .vAlign(.center)
                .hAlign(.center)
                .background(.background).opacity(0.15)
                .onTapGesture {
                    withAnimation {
                        isFail = false
                    }
                }
            
            SheetShowAnswerFailedView(answer: $answerCorrectSpeaking, titleButon: $titleButon){
                withAnimation {
                    isFail = false
                }
            }
            .vAlign(.bottom)
            .animation(.easeInOut, value: isFail)
            .onDisappear{
                if countFail < 2{
                    withAnimation {
                        isFail = false
                        countFail += 1
                    }
                }else{
                    countWrong += 1
                    if selectedTab < data.count - 1 {
                        progress += 1
                        resetSpeak()
                        withAnimation {
                            selectedTab += 1
                            isFail = false
                        }
                        countFail = 0
                    }else{
                        loadAudio("congralutions")
                        withAnimation {
                            isShowPopup = true
                            QuizTimer.shared.stop()
                        }
                    }
                }
            }
        }
    }
    
    func resetSpeak(){
        speechRecognizer.transcript = ""
        speechRecognizer.reset()
        speechRecognizer.isSpeaking = false
    }
}

