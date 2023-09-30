//
//  ColorSubmitNextButtonsView.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI
import AVFAudio

struct ColorSubmitNextButtonsView: View {
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
    
    var body: some View {
        HStack(spacing: 10){
            Button{
                var isAnswerCorrect = false
                speechRecognizer.reset()
                isCheckFailSpeech = false
                for i in answerCorrect {
                    if selectedAnswer.lowercased() == i.lowercased() {
                        // Xử lý khi câu trả lời chính xác
                        loadAudio(nameSound: "correct")
                        isCorrect = true
                        countCorrect += 1
                        isAnswerCorrect = true
                        break
                    }
                }
                
                if isAnswerCorrect {
                    if selectedTab < CONSTANT.SHARED.DATA_COLOR.count - 1 {
                        submitCorrect()
                    } else {
                        isSubmit = true
                        completeAllQuestion()
                    }
                } else {
                    // Xử lý khi câu trả lời sai
                    if selectedTab < CONSTANT.SHARED.DATA_COLOR.count - 1 {
                        isSubmit = true
                        loadAudio(nameSound: "wrong")
                        isCorrect = false
                        countWrong += 1
                    } else {
                        isSubmit = true
                        completeAllQuestion()
                    }
                }
            } label: {
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
                if selectedTab < CONSTANT.SHARED.DATA_COLOR.count - 1 {
                    submitCorrect()
                }else{
                    completeAllQuestion()
                }
                
                Point.updatePointColor(point: countCorrect)
            }label: {
                Text(selectedTab < CONSTANT.SHARED.DATA_COLOR.count - 1 ? "Next".cw_localized : "Done".cw_localized)
                    .foregroundColor(.text)
                    .padding()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(13)
            }
            .disabled(selectedAnswer == "" || !isSubmit ? true : false)
            .opacity(selectedAnswer == "" || !isSubmit ? 0.6 : 1)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    func submitCorrect(){
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
    
    func loadAudio(nameSound: String) {
        if let audioURL = Bundle.main.url(forResource: nameSound, withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        }
    }
}
