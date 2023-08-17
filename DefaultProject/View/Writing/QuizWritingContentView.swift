//
//  QuizContentView.swift
//  DefaultProject
//
//  Created by darktech4 on 17/08/2023.
//

import SwiftUI
import AVFAudio

struct QuizWritingContentView: View {
    @AppStorage("Language") var language: String = "en"
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var isSpeaking: Bool = false
    //Binding var
    @State var audioPlayer: AVAudioPlayer?
    @State var synthesizer: AVSpeechSynthesizer
    @FocusState var focusedField: FocusedField?
    @Binding var textWriting: String
    @Binding var answer: String
    @Binding var countCorrect: Int
    @Binding var countWrong: Int
    @State var index: Int
    @Binding var selectedTab: Int
    @Binding var isCorrect: Bool
    @Binding var isShowPopup: Bool
    @Binding var isShowPopupCheck: Bool
    
    var body: some View {
        VStack (spacing: 0) {
            let quiz = QUIZDEFAULT.SHARED.listWriting[index]
            
            VStack{
                Text("Listen and rewrite the following sentence".localizedLanguage(language: language))
                    .font(.bold(size: 16))
                    .foregroundColor(Color.background)
                    .hAlign(.leading)
                    .padding(.top)
                    .padding(.horizontal)
                
                HStack{
                    LottieView(name: "animation_avatar", loopMode: .loop)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: 120, height: 190)
                    
                    ZStack{
                        HStack(spacing: 2) {
                            Image(systemName: "speaker.wave.2.fill")
                                .imageScale(.large)
                                .foregroundColor(Color.blue)
                            
                            Text("Tap to listen".localizedLanguage(language: language))
                                .font(.bold(size: 16))
                                .foregroundColor(Color.background)
                                .hAlign(.leading)
                        }
                    }
                    .padding(10)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .overlay{
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.text2, lineWidth: 2)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !synthesizer.isSpeaking{
                            speakText(textToSpeak: quiz.question.localizedLanguage(language: language))
                        }else{
                            synthesizer.stopSpeaking(at: .immediate)
                        }
                    }
                }
                .simultaneousGesture(DragGesture())
                .hAlign(.leading)
                .padding(.horizontal)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isShowPopupCheck = false
                }
            }
            
            ZStack{
                Text(textWriting.isEmpty ? "Enter here".localizedLanguage(language: language) : "")
                    .font(.bold(size: 14))
                    .foregroundColor(Color.text2)
                    .hAlign(.leading)
                TextField("", text: $textWriting)
                    .foregroundColor(Color.background)
                    .focused($focusedField, equals: .textWriting)
                    .disabled(selectedTab == QUIZDEFAULT.SHARED.listWriting.count - 1 && (countWrong + countCorrect == QUIZDEFAULT.SHARED.listWriting.count) ? true : false)
                    .opacity(selectedTab == QUIZDEFAULT.SHARED.listWriting.count - 1 && (countWrong + countCorrect == QUIZDEFAULT.SHARED.listWriting.count) ? 0.6 : 1)
                    .simultaneousGesture(DragGesture())
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.text2, lineWidth: 2)
                    .opacity(selectedTab == QUIZDEFAULT.SHARED.listWriting.count - 1 && (countWrong + countCorrect == QUIZDEFAULT.SHARED.listWriting.count) ? 0.6 : 1)
                    .simultaneousGesture(DragGesture())
            }
            .padding(.horizontal)
            .padding(.top, -30)
            .contentShape(Rectangle())
            .simultaneousGesture(DragGesture())
            .disabled(isShowPopupCheck ? true : false)
            .opacity(isShowPopupCheck ? 0.6 : 1)
            .onTapGesture {
                if !isShowPopupCheck{
                    focusedField = .textWriting
                }else{
                    focusedField = nil
                }
            }
            
            HStack{
                if selectedTab < QUIZDEFAULT.SHARED.listWriting.count - 1 || !(countWrong + countCorrect == QUIZDEFAULT.SHARED.listWriting.count){
                    Button{
                        answer = quiz.answer
                        focusedField = nil
                        
                        if textWriting.localizedLanguage(language: language).lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(quiz.answer.localizedLanguage(language: language).lowercased().trimmingCharacters(in: .whitespacesAndNewlines)){
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
                        Text("CHECK".localizedLanguage(language: language))
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
        utterance.voice = AVSpeechSynthesisVoice(language: language)
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
