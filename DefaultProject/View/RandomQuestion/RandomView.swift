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
    @State var answerCorrectListen: [String] = []
    @State var answerCorrectSelect: [String] = []
    @State var answerCorrectWriting: [String] = []
    @State var answerCorrectSpeaking: String = ""
    @State var isCorrect = false
    @State var isShowPopup = false
    @State var isCheckFailBtn: Bool = false
    @State var checkPermission: Bool = false
    @State var isCheckFail: Bool = false
    @State var isShowPopupCheck: Bool = false
    @State var isHide: Bool = true
    @State var titleButon = "CONTINUE"
    @State var isFail = false
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
                .onTapGesture {
                    selectedTab = data.count - 1
                }
            
            VStack{
                TabView(selection: $selectedTab) {
                    ForEach(data.indices, id: \.self) { index in
                        VStack {
                            if category.rawValue == RandomEnum.listen.rawValue{
                                RandomListenView(synthesizer: synthesizer, speechRecognizer: speechRecognizer,index: index,audioPlayer: audioPlayer,data: $data , answerCorrect: $answerCorrectListen, isCorrect: $isCorrect, selectedTab: $selectedTab, progress: $progress, isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, offset: $offset){ text in
                                    speakText(textToSpeak: text)
                                } loadAudio: {nameSound in
                                    loadAudio(nameSound: nameSound)
                                }
                                .onAppear{
                                    answerCorrectListen = data[index].answer
                                }
                            }else if category.rawValue == RandomEnum.speaking.rawValue{
                                RandomSpeakingView(speechRecognizer: speechRecognizer, synthesizer: synthesizer, index: index, isHide: $isHide, countCorrect: $countCorrect, countWrong: $countWrong, selectedTab: $selectedTab, data: $data){
                                    handleTapToSpeak(answer: data[index].question.cw_localized)
                                }
                                .onAppear{
                                    isCheckFail = false
                                    isFail = false
                                    if let answer = data[index].answer.first{
                                        answerCorrectSpeaking = answer
                                    }
                                }
                            }
                            else if category.rawValue == RandomEnum.writing.rawValue{
                                RandomWritingView(speechRecognizer: speechRecognizer,audioPlayer:audioPlayer ,synthesizer: synthesizer, textWriting: $textWriting, answer: $answerCorrectWriting, countCorrect: $countCorrect, countWrong: $countWrong, progress: $progress, data: $data, index: index, selectedTab: $selectedTab, isCorrect: $isCorrect, isShowPopup: $isShowPopup, isShowPopupCheck: $isShowPopupCheck)
                            }
                            else{
                                RandomSelectView(synthesizer: synthesizer, speechRecognizer: speechRecognizer,index: index,audioPlayer: audioPlayer,data: $data, answerCorrect: $answerCorrectSelect, isCorrect: $isCorrect, selectedTab: $selectedTab, progress: $progress, isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, offset: $offset){ text in
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
        .overlay(alignment: .bottom) {
            if isShowPopupCheck{
                if let answer = answerCorrectWriting.first{
                    QuestionResultWritingView(isCorrect: $isCorrect, isShowPopupCheck: $isShowPopupCheck, answer: .constant(answer)) {
                        handleContinue()
                    }
                }
            }
        }
        .onChange(of: speechRecognizer.isTimeout) { newValue in
            if newValue && !isCheckFailBtn{
                if selectedTab < data.count - 1 || !(countWrong + countCorrect == data.count){
                    audioPlayer?.pause()
                    speechRecognizer.stopTranscribing()
                    if speechRecognizer.transcript.lowercased().cw_localized == answerCorrectSpeaking.cw_localized.lowercased() && !isFail{
                        loadAudio(nameSound: "correct")
                        DispatchQueue.main.async {
                            isCorrect = true
                        }
                        countCorrect += 1
                    }else if !isCorrect && !isCheckFail {
                        loadAudio(nameSound: "wrong")
                        if countFail < 2{
                            titleButon = "Again"
                        }else{
                            titleButon = "Understand"
                        }
                        DispatchQueue.main.async {
                            isFail = true
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
        .overlay(alignment: .bottom) {
            PopupResultView(synthesizer: synthesizer, speechRecognizer: speechRecognizer, isCorrect: $isCorrect, isFail: $isFail, isShowPopup: $isShowPopup, progress: $progress, selectedTab: $selectedTab, countWrong: $countWrong, countFail: $countFail, answerCorrectSpeaking: $answerCorrectSpeaking, titleButon: $titleButon){ nameSound in
                loadAudio(nameSound: nameSound)
            }
        }
    }
    
    // speaking
    func handleTapToSpeak(answer: String){
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
                
                print("\(speechRecognizer.transcript.lowercased()) - \(answer.lowercased())")
                if speechRecognizer.transcript.lowercased() == answer.lowercased() && !isFail{
                    loadAudio(nameSound: "correct")
                    DispatchQueue.main.async {
                        isCorrect = true
                    }
                    countCorrect += 1
                }else if !isCorrect{
                    isCheckFail = true
                    loadAudio(nameSound: "wrong")
                    if countFail < 2{
                        titleButon = "Again"
                    }else{
                        titleButon = "Understand"
                    }
                    DispatchQueue.main.async {
                        isFail = true
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
            isCorrect = false
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
