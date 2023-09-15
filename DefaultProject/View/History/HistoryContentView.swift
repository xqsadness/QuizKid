//
//  HistoryContentView.swift
//  DefaultProject
//
//  Created by darktech4 on 17/08/2023.
//

import SwiftUI
import AVFAudio

struct HistoryContentView: View {
    @AppStorage("Language") var language: String = "en"
    @State var synthesizer: AVSpeechSynthesizer
    @State var index: Int
    @Binding var isSubmit: Bool
    @Binding var selectedAnswer: String
    @Binding var offset: CGFloat
    
    var body: some View {
        VStack (spacing: 0) {
            let quiz = CONSTANT.SHARED.DATA_HISTORY[index]
            
            Text("Select an answer".localizedLanguage(language: language))
                .font(.bold(size: 14))
                .foregroundColor(Color.text2)
                .hAlign(.leading)
                .padding(.top)
                .padding(.horizontal)
            
            VStack{
                Text(quiz.question.localizedLanguage(language: language))
                    .font(.regular(size: 20))
                    .foregroundColor(.background)
                    .hAlign(.leading)
                    .multilineTextAlignment(.leading)
                
                Image(systemName: "speaker.wave.2.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.blue)
                    .hAlign(.center)
                    .padding(.top)
            }
            .simultaneousGesture(DragGesture())
            .padding()
            .onTapGesture {
                if !synthesizer.isSpeaking{
                    speakText(textToSpeak: quiz.question.localizedLanguage(language: language))
                }else{
                    synthesizer.stopSpeaking(at: .immediate)
                }
            }
            
            Spacer()
            
            VStack(spacing: 10){
                answerView(question: quiz.a, isCorrect: quiz.answer == quiz.a)
                answerView(question: quiz.b, isCorrect: quiz.answer == quiz.b)
                answerView(question: quiz.c, isCorrect: quiz.answer == quiz.c)
                answerView(question: quiz.d, isCorrect: quiz.answer == quiz.d)
            }
            .padding()
            .simultaneousGesture(DragGesture())
        }
    }
    
    @ViewBuilder
    func answerView(question: String, isCorrect: Bool) -> some View {
        HStack{
            Text(question.localizedLanguage(language: language))
                .font(.regular(size: 15))
                .foregroundColor(.background)
                .frame(height: 55)
                .hAlign(.center)
                .multilineTextAlignment(.center)
            //                .contentShape(Rectangle())
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 13)
                .stroke(lineWidth: 2)
                .foregroundColor(getAnswerColor(isCorrect: isCorrect, question: question))
        )
        .overlay(alignment: .trailing){
            VStack{
                if isSubmit && isCorrect{
                    Image(systemName: "checkmark")
                        .imageScale(.medium)
                        .foregroundColor(.green)
                }else if isSubmit && !isCorrect && selectedAnswer == question{
                    Image(systemName: "x.circle")
                        .imageScale(.medium)
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
            .contentShape(Rectangle())
        }
        .onTapGesture {
            if !isSubmit{
                selectedAnswer = question
            }
        }
        .offset(x: isSubmit && !isCorrect && selectedAnswer == question ? offset : 0)
        .animation(
            Animation.easeInOut(duration: 0.15)
                .repeatCount(3), // Repeats 3 times
            value: isSubmit && !isCorrect && selectedAnswer == question
        )
        .onChange(of: isSubmit) { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15 * 3) {
                withAnimation {
                    offset = 0
                }
            }
        }
    }
    
    func speakText(textToSpeak: String) {
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
    func getAnswerColor(isCorrect: Bool, question: String) -> Color {
        if isSubmit && isCorrect{
            return .green
        } else if isSubmit && !isCorrect && selectedAnswer == question{
            return .red
        } else if selectedAnswer == question{
            return .blue
        }else{
            return .text2
        }
    }
}
