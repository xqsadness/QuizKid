//
//  SurroundingObjectView.swift
//  DefaultProject
//
//  Created by daktech on 16/08/2023.
//

import SwiftUI
import AVFAudio

struct SurroundingObjectView: View {
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
    @State var checkedText: String = ""
    @State var checkedImg: String = ""
    @State var listText: [QUIZSURROUNDING] = []
    @State var listImg: [QUIZSURROUNDING] = []
    
    @State var heartPoint: Int = 3
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.background)
                    Text("Surrounding Object")
                        .font(.bold(size: 24))
                        .foregroundColor(Color.background)
                }
                .hAlign(.leading)
            }
            
            HStack{
                Text("Tap on the corresponding pairs")
                    .font(.bold(size: 16))
                    .foregroundColor(Color.background)
                
                HStack{
                    Text("\(heartPoint)")
                        .font(.bold(size: 18))
                        .foregroundColor(.text)
                    
                    Image(systemName: "heart.fill")
                        .imageScale(.medium)
                        .foregroundColor(.red)
                }
                .padding(8)
                .frame(width: 85, height: 40)
                .background(Color(hex: "9ae3ab"))
                .cornerRadius(15)
            }
            .padding(.bottom)
            
            HStack {
                VStack(spacing: 15) {
                    ForEach(listText, id: \.id) { item in
                        viewText(answer: item.answer)
                    }
                }
                .hAlign(.leading)
                
                VStack {
                    ForEach(listImg, id: \.id) { item in
                        viewImg(img: item.img, answer: item.answer)
                    }
                }
                .hAlign(.trailing)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.text)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.text)
        .navigationBarBackButtonHidden(true)
        .overlay {
            if isShowPopup {
                ZStack{
                    Color.background.opacity(0.7).ignoresSafeArea()
                    PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, totalQuestion: QUIZDEFAULT.SHARED.listQuestionsSurrounding.count)
                }
            }
        }
        .onAppear{
            listText.removeAll()
            listImg.removeAll()
            
            if listText.isEmpty{
                listText = QUIZDEFAULT.SHARED.listQuestionsSurrounding
                listText = listText.shuffled()
                
                listImg = QUIZDEFAULT.SHARED.listQuestionsSurrounding
                listImg = listText.shuffled()
            }
        }
        .onChange(of: heartPoint) { newValue in
            if newValue <= 0 {
                coordinator.pop()
            }
        }
        .onChange(of: listImg.count) { newValue in
            if newValue <= 0 {
                isShowPopup = true
            }
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
    
    @ViewBuilder
    func viewText(answer: String) -> some View{
        VStack {
            Text("\(answer)")
                .font(.bold(size: 14))
                .foregroundColor(Color.background)
                .padding(10)
                .background(checkedText == answer ? Color.blue.opacity(0.5) : Color.clear)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color.gray)
                )
                .onTapGesture {
                    if checkedText == answer {
                        checkedText = ""
                    }else{
                        checkedText = answer
                        if checkedImg == checkedText{
                            if let index = listText.firstIndex(where: { $0.answer == checkedText }) {
                                listText.remove(at: index)
                                listImg.removeAll(where: {$0.answer == checkedText})
                            }
                            loadAudio(nameSound: "correct")
                            countCorrect += 1
                            checkedImg = ""
                            checkedText = ""
                        }else if !checkedImg.isEmpty == !checkedText.isEmpty{
                            loadAudio(nameSound: "wrong")
                            heartPoint -= 1
                            countCorrect -= 1
                        }
                    }
                    Point.updatePointSurrounding(point: countCorrect)
                }
        }
    }
    
    @ViewBuilder
    func viewImg(img: String, answer: String) -> some View {
        VStack {
            Image("\(img)")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .overlay{
                    Rectangle()
                        .foregroundColor(Color.blue.opacity(0.5))
                        .opacity(checkedImg == answer ? 1 : 0)
                }
                .onTapGesture {
                    if checkedImg == answer {
                        checkedImg = ""
                    } else {
                        checkedImg = answer
                        if checkedImg == checkedText {
                            if let index = listImg.firstIndex(where: { $0.answer == checkedImg }) {
                                listImg.remove(at: index)
                                listText.removeAll(where: {$0.answer == checkedImg})
                            }
                            loadAudio(nameSound: "correct")
                            countCorrect += 1
                            checkedImg = ""
                            checkedText = ""
                        }else if !checkedImg.isEmpty == !checkedText.isEmpty {
                            loadAudio(nameSound: "wrong")
                            heartPoint -= 1
                            countCorrect -= 1
                        }
                    }
                    Point.updatePointSurrounding(point: countCorrect)
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

