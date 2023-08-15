//
//  ListenAndRepeatView.swift
//  DefaultProject
//
//  Created by daktech on 15/08/2023.
//

import SwiftUI
import AVFoundation

struct ListenAndRepeatView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var countCorrect = 0
    @State var countWrong = 0
    @State private var textToSpeak: String = ""
    @State private var selectedAnswer = ""
    @State private var answerCorrect = ""
    @State private var titleButon = "CONTINUE"
    @State private var selectedTab = 0
    @State private var isCorrect = false
    @State private var isFail = false
    @State private var isSubmit = false
    @State private var isShowPopup = false
    @State var audioPlayer: AVAudioPlayer?
    
    let synthesizer = AVSpeechSynthesizer()
    @State private var progress = 0.5
    @State var isHide: Bool = true
    @State var isSpeaking: Bool = false
    @State var countFail = 0
    
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
                            Text("Repeat what you hear \(index + 1)")
                                .font(.bold(size: 16))
                                .foregroundColor(Color.background)
                                .hAlign(.leading)
                                .padding(.top)
                                .padding(.horizontal)
                            
                            HStack{
                                LottieView(name: "animation_human", loopMode: .loop)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(width: 120, height: 190)
                                
                                ZStack{
                                    HStack{
                                        Image(systemName: "speaker.wave.2.fill")
                                            .imageScale(.large)
                                            .foregroundColor(Color.blue)
                                            .onTapGesture {
                                                if !synthesizer.isSpeaking{
                                                    speakText(textToSpeak: quiz.question)
                                                }else{
                                                    synthesizer.stopSpeaking(at: .immediate)
                                                }
                                            }
                                        
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
                            
                            Text(isHide ? "Show" : "Hide")
                                .font(.bold(size: 14))
                                .foregroundColor(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                .padding(.horizontal, 15)
                                .padding(.top, -30)
                                .onTapGesture {
                                    withAnimation {
                                        isHide.toggle()
                                    }
                                }
                            
                            Button {
                                if selectedTab < QUIZDEFAULT.SHARED.listListenAndRepeat.count - 1 || !(countWrong + countCorrect == QUIZDEFAULT.SHARED.listListenAndRepeat.count){
                                    audioPlayer?.pause()
                                    if !isSpeaking {
                                        isSpeaking = true
                                        synthesizer.stopSpeaking(at: .immediate)
                                        speechRecognizer.transcribe()
                                    } else {
                                        isSpeaking = false
                                        speechRecognizer.stopTranscribing()
                                        if speechRecognizer.transcript.lowercased() == quiz.answer.lowercased(){
                                            loadAudio(nameSound: "correct")
                                            isCorrect = true
                                            countCorrect += 1
                                        }else{
                                            loadAudio(nameSound: "wrong")
                                            if countFail < 2{
                                                titleButon = "Again"
                                            }else{
                                                titleButon = "Understand"
                                            }
                                            isFail = true
                                        }
                                    }
                                }else if selectedTab == QUIZDEFAULT.SHARED.listListenAndRepeat.count - 1 && (countWrong + countCorrect == QUIZDEFAULT.SHARED.listListenAndRepeat.count){
                                    loadAudio(nameSound: "congralutions")
                                    withAnimation {
                                        isShowPopup = true
                                    }
                                    audioPlayer?.pause()
                                }
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
                            .simultaneousGesture(DragGesture())
                            
                            Text("\(speechRecognizer.transcript)")
                                .font(.bold(size: 17))
                                .foregroundColor(Color.blue)
                                .padding(.top,20)
                            
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
                .transition(.slide) // Thêm transition animation ở đây
                .animation(.easeInOut)
                
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
        .sheet(isPresented: $isCorrect, onDismiss: {
            synthesizer.stopSpeaking(at: .immediate)
            if selectedTab < QUIZDEFAULT.SHARED.listListenAndRepeat.count - 1 {
                progress += 1
                resetSpeak()
                withAnimation {
                    selectedTab += 1
                    isCorrect = false
                }
                countFail = 0
            }else{
                loadAudio(nameSound: "congralutions")
                isCorrect = false
                withAnimation {
                    isShowPopup = true
                }
            }
        }){
            SheetShowAnswerCorrectView(answer: $answerCorrect){
                isCorrect = false
            }
        }
        .sheet(isPresented: $isFail, onDismiss: {
            if countFail < 2{
                isFail = false
                countFail += 1
            }else{
                if selectedTab < QUIZDEFAULT.SHARED.listListenAndRepeat.count - 1 {
                    progress += 1
                    countWrong += 1
                    resetSpeak()
                    withAnimation {
                        selectedTab += 1
                    }
                    isFail = false
                    countFail = 0
                }else{
                    isShowPopup = true
                }
            }
        }){
            SheetShowAnswerFailedView(answer: $answerCorrect, titleButon: $titleButon,isFail : $isFail){
                isFail = false
            }
        }
    }
    
    func resetSpeak(){
        speechRecognizer.transcript = ""
        speechRecognizer.reset()
        isSpeaking = false
    }
    
    func speakText(textToSpeak: String) {
        isSpeaking = false
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
    func loadAudio(nameSound: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        if let audioURL = Bundle.main.url(forResource: nameSound, withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            DispatchQueue.main.async {
                audioPlayer?.play()
            }
        }
    }
}

