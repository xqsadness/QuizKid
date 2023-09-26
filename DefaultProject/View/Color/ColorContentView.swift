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
    @State var speechRecognizer: SpeechRecognizer
    @State var index: Int
    @Binding var isSubmit: Bool
    @Binding var selectedAnswer: String
    @Binding var offset: CGFloat
    @Binding var isCheckFailSpeech: Bool
    
    var handleTapToSpeak: (() -> Void)
    
    var body: some View {
        VStack {
            let quiz = CONSTANT.SHARED.DATA_COLOR[index]
            
            VStack{
                Text("\(quiz.question.cw_localized)")
                    .font(.regular(size: 18))
                    .foregroundColor(.background)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .simultaneousGesture(DragGesture())
            .hAlign(.leading)
            .padding()
            
            Spacer()
            
            ScrollView{
                VStack{
                    FirebaseImageView(imageName: quiz.img)
                        .scaledToFit()
                        .padding(.horizontal)
                }
                .frame(height: 200)
                
                VStack{
                    if speechRecognizer.isSpeaking{
                        VStack{
                            LottieView(name: "micro",loopMode: .loop)
                                .frame(width: 66,height: 67)
                        }
                        .frame(width: 60,height: 60)
                    }else{
                        VStack{
                            Image("micro")
                                .resizable()
                                .frame(width: 40,height: 40)
                        }
                        .frame(width: 60,height: 60)
                    }
                }
                .animation(.easeInOut, value: speechRecognizer.isSpeaking)
                .contentShape(Rectangle())
                .onTapGesture {
                    handleTapToSpeak()
                }
                .disabled(isSubmit ? true : false )
                .opacity(isSubmit ? 0.6 : 1 )
                
                VStack{
                    if speechRecognizer.transcript.isEmpty{
                        HStack(spacing: 10){
                            ForEach(0..<3){ _ in
                                Image("line")
                                    .resizable()
                                    .frame(width: 35,height: 30)
                            }
                        }
                    }else{
                        Text("\(speechRecognizer.transcript.cw_localized)")
                            .font(.bold(size: 17))
                            .foregroundColor(Color.blue)
                    }
                }
                .frame(height: 26)
                
                VStack(spacing: 10){
                    answerView(question: quiz.a, isCorrect: quiz.answer.contains { $0 == quiz.a })
                    answerView(question: quiz.b, isCorrect: quiz.answer.contains { $0 == quiz.b })
                    answerView(question: quiz.c, isCorrect: quiz.answer.contains { $0 == quiz.c })
                    answerView(question: quiz.d, isCorrect: quiz.answer.contains { $0 == quiz.d })
                }
                .padding(.top,3)
                .padding(.horizontal)
                .simultaneousGesture(DragGesture())
            }
        }
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
                if isSubmit && isCorrect && !isCheckFailSpeech{
                    Image(systemName: "checkmark")
                        .imageScale(.medium)
                        .foregroundColor(.green)
                }else if isSubmit && !isCorrect && selectedAnswer == question{
                    Image(systemName: "x.circle")
                        .imageScale(.medium)
                        .foregroundColor(.red)
                }else if isSubmit && isCorrect && isCheckFailSpeech{
                    Image(systemName: "info.circle")
                        .imageScale(.medium)
                        .foregroundColor(.blue)
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
        if isSubmit && isCorrect && !isCheckFailSpeech{
            return .green
        } else if isSubmit && isCorrect && isCheckFailSpeech{
            return .blue
        }else if isSubmit && !isCorrect && selectedAnswer == question{
            return .red
        } else if selectedAnswer == question{
            return .blue
        }else{
            return .text2
        }
    }
}
