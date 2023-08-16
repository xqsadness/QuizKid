//
//  WritingView.swift
//  DefaultProject
//
//  Created by daktech on 16/08/2023.
//

import SwiftUI
import AVFAudio

struct WritingView: View {
    enum FocusedField {
        case textWriting
    }
    @FocusState private var focusedField: FocusedField?
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var countCorrect = 0
    @State var countWrong = 0
    @State private var textToSpeak: String = ""
    @State private var selectedAnswer = ""
    @State private var answerCorrect = ""
    @State private var selectedTab = 0
    @State private var te = 0
    @State private var isCorrect = false
    @State private var isFail = false
    @State private var isSubmit = false
    @State private var isShowPopup = false
    @State private var cc = false
    @State var audioPlayer: AVAudioPlayer?
    
    let synthesizer = AVSpeechSynthesizer()
    @State private var progress = 0.5
    @State var isHide: Bool = false
    @State var isSpeaking: Bool = false
    @State var textWriting: String = ""
    @State var isShowPopupCheck: Bool = false
    @State var answer: String = ""
    
    var body: some View {
        ZStack (alignment: .top){
            VStack{
                HStack{
                    Button {
                        coordinator.pop()
                    } label: {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .foregroundColor(Color.background)
                        Text("Writing")
                            .font(.bold(size: 24))
                            .foregroundColor(Color.background)
                    }
                    .hAlign(.leading)
                }
                
                HStack{
                    VStack{
                        Text("\(selectedTab + 1) of \(QUIZDEFAULT.SHARED.listWriting.count)")
                            .font(.bold(size: 16))
                            .foregroundColor(Color.background)
                        ProgressView(value: min(max(progress, 0), Double(QUIZDEFAULT.SHARED.listWriting.count - 1)), total: Double(QUIZDEFAULT.SHARED.listWriting.count - 1))
                    }
                    .onTapGesture {
                        withAnimation {
                            selectedTab += 1
                        }
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
                    .onTapGesture {
                        focusedField = nil
                    }
                    
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
                        ForEach(QUIZDEFAULT.SHARED.listWriting.indices, id: \.self) { index in
                            let quiz = QUIZDEFAULT.SHARED.listWriting[index]
                            VStack (spacing: 0) {
                                Text("Listen and rewrite the following sentence")
                                    .font(.bold(size: 16))
                                    .foregroundColor(Color.background)
                                    .hAlign(.leading)
                                    .padding(.top)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedTab += 1
                                        }
                                    }
                                HStack{
                                    LottieView(name: "animation_avatar", loopMode: .loop)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .frame(width: 120, height: 190)
                                    
                                    ZStack{
                                        HStack(spacing: 2) {
                                            Image(systemName: "speaker.wave.2.fill")
                                                .imageScale(.large)
                                                .foregroundColor(Color.blue)
                                            
                                            Text("Tap to listen")
                                                .font(.bold(size: 16))
                                                .foregroundColor(Color.background)
                                                .hAlign(.leading)
                                        }
                                        .onTapGesture {
                                            if !synthesizer.isSpeaking{
                                                speakText(textToSpeak: quiz.question)
                                            }else{
                                                synthesizer.stopSpeaking(at: .immediate)
                                            }
                                        }
                                    }
                                    .padding(10)
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.text2, lineWidth: 2)
                                    }
                                }
                                .simultaneousGesture(DragGesture())
                                .hAlign(.leading)
                                .padding(.horizontal)
                                
                                ZStack{
                                    Text(textWriting.isEmpty ? "Enter here" : "")
                                        .font(.bold(size: 14))
                                        .foregroundColor(Color.text2)
                                        .hAlign(.leading)
                                    TextField("", text: $textWriting)
                                        .foregroundColor(Color.background)
                                        .focused($focusedField, equals: .textWriting)
                                        .disabled(selectedTab == QUIZDEFAULT.SHARED.listWriting.count - 1 && (countWrong + countCorrect == QUIZDEFAULT.SHARED.listWriting.count) ? true : false)
                                        .opacity(selectedTab == QUIZDEFAULT.SHARED.listWriting.count - 1 && (countWrong + countCorrect == QUIZDEFAULT.SHARED.listWriting.count) ? 0.6 : 1)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.text2, lineWidth: 2)
                                        .opacity(selectedTab == QUIZDEFAULT.SHARED.listWriting.count - 1 && (countWrong + countCorrect == QUIZDEFAULT.SHARED.listWriting.count) ? 0.6 : 1)
                                }
                                .padding(.horizontal)
                                .padding(.top, -30)
                                .contentShape(Rectangle())
                                .simultaneousGesture(DragGesture())
                                .onTapGesture {
                                    focusedField = .textWriting
                                }
                                
                                HStack{
                                    if selectedTab < QUIZDEFAULT.SHARED.listWriting.count - 1 || !(countWrong + countCorrect == QUIZDEFAULT.SHARED.listWriting.count){
                                        Button{
                                            answer = quiz.answer
                                            focusedField = nil
                                            if textWriting.lowercased().contains(quiz.answer.lowercased()){
                                                loadAudio(nameSound: "correct")
                                                isCorrect = true
                                                withAnimation {
                                                    isShowPopupCheck = true
                                                }
                                                countCorrect += 1
                                            }else{
                                                withAnimation {
                                                    isShowPopupCheck = true
                                                }
                                                loadAudio(nameSound: "wrong")
                                                isCorrect = false
                                                countWrong += 1
                                            }
                                            
                                            DispatchQueue.main.async {
                                                Point.updatepointWriting(point: countCorrect)
                                            }
                                        } label: {
                                            Text("CHECK")
                                                .font(.bold(size: 16))
                                                .foregroundColor(Color(hex: textWriting.isEmpty ? "b5b5b5" : "FFFFFF"))
                                                .padding()
                                                .hAlign(.center)
                                                .background(Color(hex: textWriting.isEmpty ? "e5e5e5" : "58cc02"))
                                                .cornerRadius(10)
                                        }
                                        .contentShape(Rectangle())
                                        .disabled(textWriting.isEmpty ? true : false)
                                        .opacity(textWriting.isEmpty ? 0.6 : 1)
                                    }else if selectedTab == QUIZDEFAULT.SHARED.listWriting.count - 1 && (countWrong + countCorrect == QUIZDEFAULT.SHARED.listWriting.count){
                                        Button{
                                            withAnimation{
                                                isShowPopup = true
                                            }
                                            loadAudio(nameSound: "congralutions")
                                        } label: {
                                            Text("Done")
                                                .font(.bold(size: 16))
                                                .foregroundColor(Color(hex: "FFFFFF"))
                                                .padding()
                                                .hAlign(.center)
                                                .background(Color(hex: "58cc02"))
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                .simultaneousGesture(DragGesture())
                                .padding()
                            }
                            .tag(index)
                            .contentShape(Rectangle()).gesture(DragGesture())
                            .onAppear{
                                focusedField = nil
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
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
                PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, totalQuestion: QUIZDEFAULT.SHARED.listWriting.count)
            }
            
            if isShowPopupCheck{
                VStack(spacing: 7){
                    HStack{
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(Color(hex: isCorrect ? "58a700" : "ea2b2b"))
                        Text(isCorrect ? "Perfect!" : "Wrong!")
                            .font(.bold(size: 20))
                            .foregroundColor(Color(hex: isCorrect ? "58a700" : "ea2b2b"))
                    }
                    .hAlign(.topLeading)
                    .padding(.top,15)
                    
                    Text("Answer: ")
                        .font(.bold(size: 16))
                        .foregroundColor(Color(hex: isCorrect ? "58a700" : "ea2b2b"))
                        .hAlign(.leading)
                    Text("\(answer)")
                        .font(.bold(size: 14))
                        .foregroundColor(Color(hex: isCorrect ? "58a700" : "ea2b2b"))
                        .hAlign(.leading)
                    
                    Button {
                        withAnimation {
                            isShowPopupCheck = false
                        }
                    } label: {
                        Text("CONTINUE")
                            .font(.bold(size: 16))
                            .foregroundColor(Color.white)
                            .padding(10)
                            .hAlign(.center)
                            .background(Color(hex: isCorrect ? "58cc02" : "ff4b4b"))
                            .cornerRadius(10)
                    }
                    .contentShape(Rectangle())
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .background(Color(hex: isCorrect ? "#d7ffb8" : "ffdfe0"))
                .vAlign(.bottom)
                //                .cornerRadius(13, corners: [.topLeft, .topRight])
                .transition(.move(edge: .bottom))
                .onDisappear{
                    handleContinue()
                }
            }
        }
    }
    
    func handleContinue(){
        synthesizer.stopSpeaking(at: .immediate)
        if selectedTab != QUIZDEFAULT.SHARED.listWriting.count - 1 && (countWrong + countCorrect != QUIZDEFAULT.SHARED.listWriting.count){
            textWriting = ""
        }
        focusedField = nil
        
        if selectedTab < QUIZDEFAULT.SHARED.listWriting.count - 1 {
            isShowPopupCheck = false
            progress += 1
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
        utterance.rate = 0.3
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

