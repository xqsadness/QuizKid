//
//  MathSubmitNextButtonsView.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI
import AVFAudio

struct MathSubmitNextButtonsView: View {
    @AppStorage("Language") var language: String = "en"
    @State var audioPlayer: AVAudioPlayer?
    
    @State var speechRecognizer: SpeechRecognizer
    @Binding var synthesizer: AVSpeechSynthesizer
    @Binding var selectedAnswer: String
    @Binding var answerCorrect: [String]
    @Binding var isSubmit: Bool
    @Binding var isCorrect: Bool
    @Binding var selectedTab: Int
    @Binding var progress: Double
    @Binding var isShowPopup: Bool
    @Binding var countCorrect: Int
    @Binding var countWrong: Int
    @Binding var offset: CGFloat
    @Binding var isCheckFailSpeech: Bool

    var loadAudio: ((String) -> Void)
    var body: some View {
        HStack(spacing: 10){
            Button{
                offset = -10
                speechRecognizer.reset()
                
                var isAnswerCorrect = false
                
                for i in answerCorrect {
                    if selectedAnswer.lowercased() == i.lowercased(){
                        loadAudio("correct")
                        isCorrect = true
                        countCorrect += 1
                        isAnswerCorrect = true
                        break
                    }
                }
                
                if isAnswerCorrect {
                    if selectedTab < CONSTANT.SHARED.DATA_MATH.count - 1{
                        submitCorrect()
                    }else{
                        isSubmit = true
                        completeAllQuestion()
                    }
                }else{
                    isSubmit = true
                    loadAudio("wrong")
                    isCorrect = false
                    countWrong += 1
                }

            }label: {
                Text("Submit".cw_localized)
                    .foregroundColor(.text)
                    .padding()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(13)
            }
            .disabled(selectedAnswer == "" || isSubmit || speechRecognizer.isSpeaking ? true : false)
            .opacity(selectedAnswer == "" || isSubmit || speechRecognizer.isSpeaking ? 0.6 : 1)
            
            Button{
                synthesizer.stopSpeaking(at: .immediate)
                if selectedTab < CONSTANT.SHARED.DATA_MATH.count - 1 {
                    submitCorrect()
                }else{
                    // Check if all questions have been answered
                    completeAllQuestion()
                }
                
                Point.updatePointMath(point: countCorrect)
            }label: {
                Text(selectedTab < CONSTANT.SHARED.DATA_MATH.count - 1 ? "Next".cw_localized : "Done".cw_localized)
                    .foregroundColor(.text)
                    .padding()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(13)
            }
            .disabled(selectedAnswer == "" || !isSubmit ? true : false )
            .opacity(selectedAnswer == "" || !isSubmit ? 0.6 : 1 )
        }
        .padding()
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
            loadAudio("wrong")
        }else{
            loadAudio("congralutions")
        }
        QuizTimer.shared.stop()
    }
    
}
