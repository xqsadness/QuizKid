//
//  ListenAndRPContentView.swift
//  DefaultProject
//
//  Created by darktech4 on 17/08/2023.
//

import SwiftUI
import AVFAudio

struct ListenAndRPContentView: View {
    @AppStorage("Language") var language: String = "en"
    @StateObject var speechRecognizer: SpeechRecognizer
    @State var synthesizer: AVSpeechSynthesizer
    @State var index: Int
//    @Binding var isSpeaking: Bool
    @Binding var isHide: Bool
    @Binding var countCorrect: Int
    @Binding var countWrong: Int
    @Binding var selectedTab: Int
    
    var handleTapToSpeak: (() -> Void)
    var handleTapToSpeakOnchange: (() -> Void)
    
    var body: some View {
        VStack (spacing: 0) {
            let quiz = CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT[index]
            Text("Repeat what you hear".cw_localized)
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
                        
                        if isHide{
                            HStack(spacing: 10){
                                ForEach(0..<4){ _ in
                                    Image("line")
                                        .resizable()
                                        .frame(width: 20,height: 15)
                                }
                            }
                            .padding(.top,7)
                        }else{
                            Text("\(quiz.question.cw_localized)")
                                .font(.bold(size: 14))
                                .foregroundColor(Color.background)
                        }
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
                .contentShape(Rectangle())
                .onTapGesture {
                    if !synthesizer.isSpeaking{
                        speakText(textToSpeak: quiz.question.cw_localized)
                    }else{
                        synthesizer.stopSpeaking(at: .immediate)
                    }
                }
            }
            .simultaneousGesture(DragGesture())
            .hAlign(.leading)
            .padding(.horizontal)
            
            Text(isHide ? "Show".cw_localized : "Hide".cw_localized)
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
                .simultaneousGesture(DragGesture())
            
            HStack{
                if speechRecognizer.isSpeaking {
                    LottieView(name: "animation_soundwave", loopMode: .loop)
                        .frame(height: 57)
                } else {
                    if selectedTab == CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.count - 1 && (countWrong + countCorrect == CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.count){
                        Text("Done".cw_localized)
                            .font(.bold(size: 17))
                            .foregroundColor(Color.blue)
                    }else{
                        Image(systemName: "mic.fill")
                            .imageScale(.large)
                            .foregroundColor(Color.blue)
                        Text("Tap to speak".cw_localized)
                            .font(.bold(size: 17))
                            .foregroundColor(Color.blue)
                    }
                }
            }
            .padding(speechRecognizer.isSpeaking ? 0 : 15)
            .frame(maxWidth: .infinity)
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            }
            .padding(.horizontal, 15)
            .padding(.top)
            .contentShape(Rectangle())
            .simultaneousGesture(DragGesture())
            .onTapGesture {
                handleTapToSpeak()
            }
            
            .onChange(of: speechRecognizer.isSpeaking) { newValue in
                if !newValue{
                    handleTapToSpeakOnchange()
                }
            }
            
            if speechRecognizer.transcript.isEmpty{
                HStack(spacing: 10){
                    ForEach(0..<3){ _ in
                        Image("line")
                            .resizable()
                            .frame(width: 35,height: 30)
                    }
                }
                .padding(.top,20)
            }else{
                Text("\(speechRecognizer.transcript.cw_localized)")
                    .font(.bold(size: 17))
                    .foregroundColor(Color.blue)
                    .padding(.top,20)
            }
            
            Spacer()
            
            VStack(spacing: 10){
                
            }
            .padding()
            .simultaneousGesture(DragGesture())
        }
    }
    
    func speakText(textToSpeak: String) {
        speechRecognizer.isSpeaking = false
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch let err{
            print(err.localizedDescription)
            speechRecognizer.transcript = "Something went wrong, please try again !"
        }
        
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}
