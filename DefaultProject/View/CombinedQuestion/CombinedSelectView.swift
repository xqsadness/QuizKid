//
//  RandomSelectView.swift
//  DefaultProject
//
//  Created by darktech4 on 27/09/2023.
//

import SwiftUI
import AVFAudio

struct CombinedSelectView: View {
    @AppStorage("Language") var language: String = "en"
    @State var selectedAnswer: String = ""
    @State var isSubmit: Bool = false
    @State var isCheckFailSpeech: Bool = false

    @State var synthesizer: AVSpeechSynthesizer
    @State var speechRecognizer: SpeechRecognizer
    @State var index: Int
    @State var audioPlayer: AVAudioPlayer?
    @Binding var data: [QUIZ_ARRAY]
    @Binding var selectedTab: Int
    @Binding var progress: Double
    @Binding var isShowPopup: Bool
    @Binding var countCorrect: Int
    @Binding var countWrong: Int
    @Binding var offset: CGFloat
    
    var speakText: ((String) -> Void)
    var loadAudio: ((String) -> Void)
    
    var body: some View {
        VStack {
            let quiz = data[index]
            
            VStack{
                Text(quiz.question.cw_localized)
                    .font(.regular(size: 19))
                    .foregroundColor(.background)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
//                Image(systemName: "speaker.wave.2.fill")
//                    .imageScale(.large)
//                    .foregroundColor(Color.blue)
//                    .padding(.top)
//                    .onTapGesture {
//                        if !synthesizer.isSpeaking{
//                            speakText(quiz.question.cw_localized)
//                        }else{
//                            synthesizer.stopSpeaking(at: .immediate)
//                        }
//                    }
            }
            .simultaneousGesture(DragGesture())
            .hAlign(.leading)
            .padding()
            
            Spacer()
            
            VStack(spacing: 10){
                answerView(question: quiz.a, isCorrect: quiz.answer.contains(where: { $0 == quiz.a}))
                answerView(question: quiz.b, isCorrect: quiz.answer.contains(where: { $0 == quiz.b}))
                answerView(question: quiz.c, isCorrect: quiz.answer.contains(where: { $0 == quiz.c}))
                answerView(question: quiz.d, isCorrect: quiz.answer.contains(where: { $0 == quiz.d}))
            }
            .padding()
            .simultaneousGesture(DragGesture())
            
            HStack(spacing: 10){
                Button{
                    var isAnswerCorrect = false
                    
                    for i in data[index].answer {
                        if selectedAnswer.lowercased() == i.lowercased(){
                            loadAudio("correct")
                            countCorrect += 1
                            isAnswerCorrect = true
                            break
                        }
                    }
                    
                    if isAnswerCorrect {
                        if selectedTab < data.count - 1{
                            submitCorrect()
                        }else{
                            isSubmit = true
                            completeAllQuestion()
                        }
                    }else{
                        if selectedTab < data.count - 1{
                            isSubmit = true
                            loadAudio("wrong")
                            countWrong += 1
                        }else{
                            isSubmit = true
                            completeAllQuestion()
                        }
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
                    if selectedTab < data.count - 1 {
                        submitCorrect()
                    }else{
                        completeAllQuestion()
                    }
                    
                    Point.updatePointListen(point: countCorrect)
                }label: {
                    Text(selectedTab < data.count - 1 ? "Next".cw_localized : "Done".cw_localized)
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
    
    func submitCorrect(){
        // processed after answering 1 question correctly
        progress += 1
        selectedAnswer = ""
        isSubmit = false
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
