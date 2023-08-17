//
//  ListeningView.swift
//  DefaultProject
//
//  Created by darktech4 on 12/08/2023.
//

import SwiftUI
import AVFAudio

struct ListeningView: View {
    @State var countCorrect = 0
    @State var countWrong = 0
    @State private var textToSpeak: String = ""
    @State private var selectedAnswer = ""
    @State private var answerCorrect = ""
    @State private var selectedTab = 0
    @State private var isCorrect = false
    @State private var isSubmit = false
    @State private var isShowPopup = false
    @State var audioPlayer: AVAudioPlayer?
    
    let synthesizer = AVSpeechSynthesizer()
    @State private var progress = 0.5
    @EnvironmentObject var coordinator: Coordinator
    @State var offset: CGFloat = -10

    var body: some View {
        VStack{
            HStack{
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.background)
                    Text("Listen")
                        .font(.bold(size: 24))
                        .foregroundColor(Color.background)
                }
                .hAlign(.leading)
            }
            
            HStack{
                VStack{
                    Text("\(selectedTab + 1) of \(QUIZDEFAULT.SHARED.listQuestionsListen.count)")
                        .font(.bold(size: 16))
                        .foregroundColor(Color.background)
                    ProgressView(value: min(max(progress, 0), Double(QUIZDEFAULT.SHARED.listQuestionsListen.count - 1)), total: Double(QUIZDEFAULT.SHARED.listQuestionsListen.count - 1))
                }
                
                HStack{
                    Text("\(countCorrect)")
                        .font(.bold(size: 18))
                        .foregroundColor(.text)
                    
                    Image(systemName: "checkmark")
                        .imageScale(.medium)
                        .foregroundColor(.text)
                }
                .padding(8)
                .frame(width: 85, height: 40)
                .background(Color(hex: "9ae3ab"))
                .cornerRadius(15)
                
                HStack{
                    Text("\(countWrong)")
                        .font(.bold(size: 18))
                        .foregroundColor(.text)
                    
                    Image(systemName: "x.circle")
                        .imageScale(.medium)
                        .foregroundColor(.text)
                }
                .padding(8)
                .frame(width: 85, height: 40)
                .background(Color(hex: "ff9d97"))
                .cornerRadius(15)
            }
            .padding(.bottom)
            
            VStack{
                TabView(selection: $selectedTab) {
                    ForEach(QUIZDEFAULT.SHARED.listQuestionsListen.indices, id: \.self) { index in
                        let quiz = QUIZDEFAULT.SHARED.listQuestionsListen[index]
                        VStack {
                            VStack{
                                Text("Listen and choose the correct answer")
                                    .font(.regular(size: 19))
                                    .foregroundColor(.background)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Image(systemName: "speaker.wave.2.fill")
                                    .imageScale(.large)
                                    .foregroundColor(Color.blue)
                                    .padding(.top)
                                    .onTapGesture {
                                        speakText(textToSpeak: quiz.question)
                                    }
                            }
                            .simultaneousGesture(DragGesture())
                            .hAlign(.leading)
                            .padding()
                            
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
                        .tag(index)
                        .contentShape(Rectangle()).gesture(DragGesture())
                        .onAppear{
                            answerCorrect = quiz.answer
                        }
                    }
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 10){
                    Button{
                        isSubmit = true
                        
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
                        Text("Submit")
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
                        if selectedTab < QUIZDEFAULT.SHARED.listQuestionsListen.count - 1 {
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
                        
                        Point.updatePointListen(point: countCorrect)
                    }label: {
                        Text(selectedTab < QUIZDEFAULT.SHARED.listQuestionsListen.count - 1 ? "Next" : "Done")
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
            PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, totalQuestion: QUIZDEFAULT.SHARED.listQuestionsListen.count)
        }
    }
    
    func speakText(textToSpeak: String) {
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: "en")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
    @ViewBuilder
    func answerView(question: String, isCorrect: Bool) -> some View {
        HStack{
            Text(question)
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
    
    func loadAudio(nameSound: String) {
        if let audioURL = Bundle.main.url(forResource: nameSound, withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
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

