//
//  RandomView.swift
//  DefaultProject
//
//  Created by darktech4 on 27/09/2023.
//

import SwiftUI
import AVFAudio

struct RandomView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var audioPlayer: AVAudioPlayer?
    @State var synthesizer = AVSpeechSynthesizer()
    @FocusState private var focusedField: FocusedField?
    @State var data = CONSTANT.SHARED.DATA_HISTORY
    @State var selectedTab = 0
    @State var countCorrect = 0
    @State var countWrong = 0
    @State var countFail = 0
    @State var progress = 0.5
    @State var offset: CGFloat = -10
    @State var selectedAnswer = ""
    @State var textWriting: String = ""
    @State var answerCorrectWriting: String = ""
    @State var answerCorrectSpeaking: String = ""
    @State var answerCorrectListen: [String] = []
    @State var answerCorrectSelect: [String] = []
    @State var answerSpeaking: [String] = []
    @State var answerWriting: [String] = []
    @State var isCorrectListen = false
    @State var isCorrectSelect = false
    @State var isCorrectWriting = false
    @State var isCorrectSpeaking = false
    @State var isShowPopup = false
    @State var isFailSpeaking = false
    @State var isCheckFailBtn: Bool = false
    @State var checkPermission: Bool = false
    @State var isCheckFail: Bool = false
    @State var isShowPopupCheck: Bool = false
    @State var isHide: Bool = true
    @State var titleButon = "CONTINUE"
    @State var category: RandomEnum = .writing
    
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.background)
                    Text("Random".cw_localized)
                        .font(.bold(size: 24))
                        .foregroundColor(Color.background)
                }
                .hAlign(.leading)
            }
            
            RandomInfoView(dataListen: $data, countCorrect: $countCorrect, countWrong: $countWrong, selectedTab: $selectedTab, progress: $progress)
            
            VStack{
                TabView(selection: $selectedTab) {
                    ForEach(data.indices, id: \.self) { index in
                        VStack {
                            if category.rawValue == RandomEnum.listen.rawValue{
                                RandomListenView(synthesizer: synthesizer, speechRecognizer: speechRecognizer,index: .constant(index) ,audioPlayer: audioPlayer,data: $data , answerCorrect: $answerCorrectListen, isCorrect: $isCorrectListen, selectedTab: $selectedTab, progress: $progress, isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, offset: $offset){ text in
                                    speakText(textToSpeak: text)
                                } loadAudio: {nameSound in
                                    loadAudio(nameSound: nameSound)
                                }
//                                .onAppear{
//                                    answerCorrectListen = data[index].answer
//                                    print(answerCorrectSelect)
//                                }
                            }else if category.rawValue == RandomEnum.speaking.rawValue{
                                RandomSpeakingView(speechRecognizer: speechRecognizer, synthesizer: synthesizer, index: index, isHide: $isHide, countCorrect: $countCorrect, countWrong: $countWrong, selectedTab: $selectedTab, data: $data){
                                    handleTapToSpeak(answer: data[index].answer)
                                }
                                .onAppear{
                                    isCheckFail = false
                                    isFailSpeaking = false
                                }
                            }
                            else if category.rawValue == RandomEnum.writing.rawValue{
                                RandomWritingView(speechRecognizer: speechRecognizer,audioPlayer:audioPlayer ,synthesizer: synthesizer, textWriting: $textWriting, answer: $answerWriting,answerCorrectWriting: $answerCorrectWriting ,countCorrect: $countCorrect, countWrong: $countWrong, progress: $progress, data: $data, index: index, selectedTab: $selectedTab, isCorrect: $isCorrectWriting, isShowPopup: $isShowPopup, isShowPopupCheck: $isShowPopupCheck)
                            }
                            else{
                                RandomSelectView(synthesizer: synthesizer, speechRecognizer: speechRecognizer,index: index,audioPlayer: audioPlayer,data: $data, answerCorrect: $answerCorrectSelect, isCorrect: $isCorrectSelect, selectedTab: $selectedTab, progress: $progress, isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, offset: $offset){ text in
                                    speakText(textToSpeak: text)
                                } loadAudio: {nameSound in
                                    loadAudio(nameSound: nameSound)
                                }
                                .onAppear{
                                    answerCorrectSelect = data[index].answer
                                }
                            }
                        }
                        .tag(index)
                        .contentShape(Rectangle())
                        .gesture(DragGesture())
                        .onAppear{
                            let allCases = RandomEnum.allCases
                            let randomIndex = Int.random(in: 0..<allCases.count)
                            self.category = allCases[randomIndex]
                        }
                        .animation(.easeInOut, value: selectedTab)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.text)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 2)
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.text)
        .popup(isPresented: $isShowPopup) {
            PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, title: "Random", totalQuestion: data.count)
        }
        .onAppear{
            QuizTimer.shared.start()
        }
        .onDisappear{
            QuizTimer.shared.reset()
            synthesizer.stopSpeaking(at: .immediate)
        }
        //writing
        .overlay(alignment: .bottom) {
            if isShowPopupCheck{
                QuestionResultWritingView(isCorrect: $isCorrectWriting, isShowPopupCheck: $isShowPopupCheck, answer: $answerCorrectWriting) {
                    handleContinue()
                }
            }
        }
        .onChange(of: speechRecognizer.isTimeout) { newValue in
            if newValue && !isCheckFailBtn{
                if selectedTab < data.count - 1 || !(countWrong + countCorrect == data.count){
                    audioPlayer?.pause()
                    speechRecognizer.stopTranscribing()
                    
                    var isCorrectAnswer = false
                    
                    for i in answerSpeaking{
                        if speechRecognizer.transcript.lowercased() == i.cw_localized.lowercased() && !isFailSpeaking{
                            isCorrectAnswer = true
                            answerCorrectSpeaking = i
                        }else{
                            answerCorrectSpeaking = i
                            break
                        }
                    }
                    
                    if isCorrectAnswer{
                        loadAudio(nameSound: "correct")
                        DispatchQueue.main.async {
                            isCorrectSpeaking = true
                        }
                        countCorrect += 1
                    }else if !isCorrectSpeaking && !isCheckFail {
                        loadAudio(nameSound: "wrong")
                        if countFail < 2{
                            titleButon = "Again"
                        }else{
                            titleButon = "Understand"
                        }
                        DispatchQueue.main.async {
                            isFailSpeaking = true
                        }
                    }
                }else if selectedTab == data.count - 1 && (countWrong + countCorrect == data.count){
                    loadAudio(nameSound: "congralutions")
                    withAnimation {
                        isShowPopup = true
                    }
                    audioPlayer?.pause()
                }
                speechRecognizer.transcript = ""
            }
        }
        // speaking
        .overlay(alignment: .bottom) {
            PopupResultView(synthesizer: synthesizer, speechRecognizer: speechRecognizer, isCorrect: $isCorrectSpeaking, isFail: $isFailSpeaking, isShowPopup: $isShowPopup, progress: $progress, selectedTab: $selectedTab, countWrong: $countWrong, countFail: $countFail, answerCorrectSpeaking: $answerCorrectSpeaking, titleButon: $titleButon){ nameSound in
                loadAudio(nameSound: nameSound)
            }
        }
    }
    
    // speaking
    func handleTapToSpeak(answer: [String]){
        answerSpeaking = answer
        if selectedTab < data.count - 1 || !(countWrong + countCorrect == data.count){
            audioPlayer?.pause()
            if !speechRecognizer.isSpeaking {
                speechRecognizer.isSpeaking = true
                synthesizer.stopSpeaking(at: .immediate)
                speechRecognizer.transcribe()
                isCheckFailBtn = false
            } else {
                isCheckFailBtn = true
                speechRecognizer.isSpeaking = false
                speechRecognizer.stopTranscribing()
               
                var isCorrectAnswer = false
                
                for i in answer{
                    if speechRecognizer.transcript.lowercased() == i.cw_localized.lowercased() && !isFailSpeaking{
                        isCorrectAnswer = true
                        answerCorrectSpeaking = i
                    }else{
                        answerCorrectSpeaking = i
                        break
                    }
                }
                
                if isCorrectAnswer{
                    loadAudio(nameSound: "correct")
                    DispatchQueue.main.async {
                        isCorrectSpeaking = true
                    }
                    countCorrect += 1
                }else if !isCorrectSpeaking{
                    isCheckFail = true
                    loadAudio(nameSound: "wrong")
                    if countFail < 2{
                        titleButon = "Again"
                    }else{
                        titleButon = "Understand"
                    }
                    DispatchQueue.main.async {
                        isFailSpeaking = true
                    }
                }
            }
        }else if selectedTab == data.count - 1 && (countWrong + countCorrect == data.count){
            loadAudio(nameSound: "congralutions")
            withAnimation {
                isShowPopup = true
            }
            audioPlayer?.pause()
        }
        speechRecognizer.transcript = ""
    }
    
    func handleContinue(){
        synthesizer.stopSpeaking(at: .immediate)
        if selectedTab != data.count - 1 && (countWrong + countCorrect != data.count){
            textWriting = ""
        }
        focusedField = nil
        
        if selectedTab < data.count - 1 {
            isShowPopupCheck = false
            progress += 1
            isCorrectWriting = false
            withAnimation {
                selectedTab += 1
            }
        }else{
            withAnimation {
                isShowPopup = true
                QuizTimer.shared.reset()
            }
            audioPlayer?.pause()
            if countCorrect == 0{
                loadAudio(nameSound: "wrong")
            }else{
                loadAudio(nameSound: "congralutions")
            }
        }
    }
    
    func speakText(textToSpeak: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.35
        synthesizer.speak(utterance)
    }
    
    func loadAudio(nameSound: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch let err{
            print(err.localizedDescription)
        }
        if let audioURL = Bundle.main.url(forResource: nameSound, withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            DispatchQueue.main.async {
                audioPlayer?.play()
            }
        }
    }
}

enum RandomEnum: String {
    case listen = "listen"
    case writing = "writing"
    case select = "select"
    case speaking = "speaking"
}

extension RandomEnum {
    static var allCases: [RandomEnum] {
        return [.listen, .writing, .select, .speaking]
    }
}
