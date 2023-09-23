//
//  ColorContentvIEW.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI
import AVFAudio

struct ColorContentView: View {
    @AppStorage("Language") var language: String = "en"
    @State var synthesizer: AVSpeechSynthesizer
    @State var index: Int
    @Binding var isSubmit: Bool
    @Binding var selectedAnswer: String
    @Binding var offset: CGFloat
    
    var body: some View {
        VStack {
            let quiz = CONSTANT.SHARED.DATA_COLOR[index]
            
            VStack{
                Text("\(quiz.question.cw_localized)")
                    .font(.regular(size: 20))
                    .foregroundColor(.background)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                FirebaseImageView(imageName: quiz.img)
                    .scaledToFit()
            }
            .simultaneousGesture(DragGesture())
            .hAlign(.leading)
            .padding()
            
            Spacer()
            
            VStack(spacing: 10){
                answerView(question: quiz.a, isCorrect: quiz.answer.contains { $0 == quiz.a })
                answerView(question: quiz.b, isCorrect: quiz.answer.contains { $0 == quiz.b })
                answerView(question: quiz.c, isCorrect: quiz.answer.contains { $0 == quiz.c })
                answerView(question: quiz.d, isCorrect: quiz.answer.contains { $0 == quiz.d })
            }
            .padding()
            .simultaneousGesture(DragGesture())
        }
    }
    
    func speakText(textToSpeak: String) {
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
    @ViewBuilder
    func answerView(question: String, isCorrect: Bool) -> some View {
        HStack{
            Text(question.cw_localized)
                .font(.regular(size: 18))
                .foregroundColor(.background)
                .frame(height: 55)
                .hAlign(.center)
                .contentShape(Rectangle())
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
