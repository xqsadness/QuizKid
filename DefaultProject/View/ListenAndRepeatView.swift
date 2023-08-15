//
//  ListenAndRepeatView.swift
//  DefaultProject
//
//  Created by daktech on 15/08/2023.
//

import SwiftUI
import AVFoundation

struct ListenAndRepeatView: View {
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
    @State var isHide: Bool = true
    @State var isSpeaking: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.background)
                    Text("Listen and repeat")
                        .font(.bold(size: 24))
                        .foregroundColor(Color.background)
                }
                .hAlign(.leading)
            }
            
            HStack{
                VStack{
                    Text("\(selectedTab + 1) of \(QUIZDEFAULT.SHARED.listListenAndRepeat.count)")
                        .font(.bold(size: 16))
                        .foregroundColor(Color.background)
                    ProgressView(value: min(max(progress, 0), Double(QUIZDEFAULT.SHARED.listListenAndRepeat.count - 1)), total: Double(QUIZDEFAULT.SHARED.listListenAndRepeat.count - 1))
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
                    ForEach(QUIZDEFAULT.SHARED.listListenAndRepeat.indices, id: \.self) { index in
                        let quiz = QUIZDEFAULT.SHARED.listListenAndRepeat[index]
                        VStack (spacing: 0) {
                            Text("Repeat what you hear")
                                .font(.bold(size: 16))
                                .foregroundColor(Color.background)
                                .hAlign(.leading)
                                .padding(.top)
                                .padding(.horizontal)
                            
                            HStack{
                                LottieView(name: "animation_human", loopMode: .playOnce)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(width: 120, height: 190)
                                
                                ZStack{
                                    HStack{
                                        Image(systemName: "speaker.wave.2.fill")
                                            .imageScale(.large)
                                            .foregroundColor(Color.blue)
                                        
                                        Text(isHide ? "" : "\(quiz.question)")
                                            .font(.bold(size: 14))
                                            .foregroundColor(Color.background)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                }
                                .padding(10)
                                .frame(height: 100)
                                .frame(maxWidth: .infinity)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.text2, lineWidth: 2)
                                }
                            }
                            .simultaneousGesture(DragGesture())
                            .hAlign(.leading)
                            .padding(.horizontal)
                            .onTapGesture {
                                speakText(textToSpeak: quiz.question)
                            }
                            
                            Text(isHide ? "Show" : "")
                                .font(.bold(size: 14))
                                .foregroundColor(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                .padding(.horizontal, 15)
                                .padding(.top, -30)
                                .onTapGesture {
                                    isHide.toggle()
                                }
                            
                            Button {
                                isSpeaking.toggle()
                            } label: {
                                if isSpeaking {
                                    LottieView(name: "animation_soundwave", loopMode: .loop)
                                        .frame(height: 57)
                                } else {
                                    Image(systemName: "mic.fill")
                                        .imageScale(.large)
                                        .foregroundColor(Color.blue)
                                    Text("Tap to speak")
                                        .font(.bold(size: 17))
                                        .foregroundColor(Color.blue)
                                }
                            }
                            .padding(isSpeaking ? 0 : 15)
                            .frame(maxWidth: .infinity)
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            }
                            .padding(.horizontal, 15)
                            .padding(.top)
                            .contentShape(Rectangle())
                            .animation(.easeInOut(duration: 0.3), value: isSpeaking)
                            
                            Spacer()
                            
                            VStack(spacing: 10){
                                
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
                
                HStack{
                    Button{
                        
                    }label: {
                        Text("CHECK")
                            .font(.bold(size: 16))
                            .foregroundColor(Color(hex: "b5b5b5"))
                    }
                    .padding()
                    .hAlign(.center)
                    .background(Color(hex: "e5e5e5"))
                    .cornerRadius(10)
                    .disabled(true)
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
            PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, totalQuestion: QUIZDEFAULT.SHARED.listListenAndRepeat.count)
        }
        .sheet(isPresented: $isSpeaking) {
            VStack {
                HStack{
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color(hex: "58a700"))
                    Text("Perfect!")
                        .font(.bold(size: 20))
                        .foregroundColor(Color(hex: "58a700"))
                }
                .hAlign(.topLeading)
                
                Text("Mean: ")
                    .font(.bold(size: 16))
                    .foregroundColor(Color(hex: "58a700"))
                    .hAlign(.leading)
                Text("dap an")
                    .font(.bold(size: 18))
                    .foregroundColor(Color(hex: "80c23b"))
                    .hAlign(.leading)
                
                Button {
                    
                } label: {
                    Text("CONTINUE")
                        .font(.bold(size: 16))
                        .foregroundColor(Color.white)
                }
                .padding(10)
                .hAlign(.center)
                .background(Color(hex: "58cc02"))
                .cornerRadius(10)
            }
            .padding()
            .presentationDetents([.height(130)])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#d7ffb8"))
        }
    }
    
    func speakText(textToSpeak: String) {
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
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

