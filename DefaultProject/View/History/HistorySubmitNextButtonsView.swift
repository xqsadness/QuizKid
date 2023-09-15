//
//  HistorySubmitNextButtonsView.swift
//  DefaultProject
//
//  Created by darktech4 on 17/08/2023.
//

import SwiftUI
import AVFAudio

struct HistorySubmitNextButtonsView: View {
    @AppStorage("Language") var language: String = "en"
    @State var audioPlayer: AVAudioPlayer?
    
    @Binding var synthesizer: AVSpeechSynthesizer
    @Binding var selectedAnswer: String
    @Binding var answerCorrect: String
    @Binding var isSubmit: Bool
    @Binding var isCorrect: Bool
    @Binding var selectedTab: Int
    @Binding var progress: Double
    @Binding var isShowPopup: Bool
    @Binding var countCorrect: Int
    @Binding var countWrong: Int
    @Binding var offset: CGFloat
    
    var body: some View {
        HStack(spacing: 10){
            Button{
                offset = -10
                isSubmit = true
                synthesizer.stopSpeaking(at: .immediate)
                if selectedAnswer == answerCorrect{
                    loadAudio(nameSound: "correct")
                    isCorrect = true
                    countCorrect += 1
                }else{
                    loadAudio(nameSound: "wrong")
                    isCorrect = false
                    countWrong += 1
                }
            }label: {
                Text("Submit".localizedLanguage(language: language))
                    .foregroundColor(.text)
                    .padding()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(13)
            }
            .disabled(selectedAnswer == "" || isSubmit ? true : false)
            .opacity(selectedAnswer == "" || isSubmit ? 0.6 : 1)
            
            Button{
                synthesizer.stopSpeaking(at: .immediate)
                if selectedTab < CONSTANT.SHARED.DATA_HISTORY.count - 1 {
                    progress += 1
                    selectedAnswer = ""
                    isSubmit = false
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
                
                //                        if selectedTab >= QUIZDEFAULT.SHARED.listQuestionsHistory.count - 1{
                Point.updatePointHistory(newPointHistory: countCorrect)
                //                        }
            }label: {
                Text(selectedTab < CONSTANT.SHARED.DATA_HISTORY.count - 1 ? "Next".localizedLanguage(language: language) : "Done".localizedLanguage(language: language))
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
        .padding()
    }
    
    func loadAudio(nameSound: String) {
        if let audioURL = Bundle.main.url(forResource: nameSound, withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        }
    }
}

