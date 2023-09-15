//
//  SurroundingObjectView.swift
//  DefaultProject
//
//  Created by daktech on 16/08/2023.
//

import SwiftUI
import AVFAudio

struct SurroundingObjectView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @State var audioPlayer: AVAudioPlayer?
    @State var listText: [QUIZ] = []
    @State var listImg: [QUIZ] = []
    @State var checkedText: String = ""
    @State var checkedImg: String = ""
    @State var heartPoint: Int = 5
    @State var countCorrect = 0
    @State var countWrong = 0
    @State var isShowPopup = false
    @State var isShowPopupFail = false
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.background)
                    Text("Surrounding Object".cw_localized)
                        .font(.bold(size: 24))
                        .foregroundColor(Color.background)
                }
                .hAlign(.leading)
            }
            
            HStack{
                Text("Tap on the corresponding pairs".cw_localized)
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
            
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false){
                    HStack(spacing: 13) {
                        VStack(spacing: 15) {
                            ForEach(listText, id: \.id) { item in
                                ItemTextView(countCorrect: $countCorrect, checkedImg: $checkedImg, checkedText: $checkedText, answer: item.answer, listText: $listText, listImg: $listImg, heartPoint: $heartPoint, size: geometry.size){ nameSound in
                                    loadAudio(nameSound: nameSound)
                                }
                            }
                        }
                        
                        VStack(spacing: 15) {
                            ForEach(listImg, id: \.id) { item in
                                ItemImgView(countCorrect: $countCorrect, checkedImg: $checkedImg, checkedText: $checkedText, img: item.img, answer: item.answer, listText: $listText, listImg: $listImg, heartPoint: $heartPoint, size: geometry.size) { nameSound in
                                    loadAudio(nameSound: nameSound)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background(Color.text)
                    .padding(.top)
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.text)
        .navigationBarBackButtonHidden(true)
        .overlay {
            if isShowPopup {
                ZStack{
                    Color.background.opacity(0.7).ignoresSafeArea()
                    PopupScoreView(isShowPopup: $isShowPopup, countCorrect: $countCorrect, countWrong: $countWrong, totalQuestion: CONSTANT.SHARED.DATA_SURROUNDING.count)
                }
            }
            if isShowPopupFail {
                ZStack{
                    Color.background.opacity(0.7).ignoresSafeArea()
                    VStack{
                        Text("You have run out of lives".cw_localized + "!")
                            .font(.bold(size: 20))
                            .foregroundColor(.background)
                            .vAlign(.top)
                            .hAlign(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom,15)
                        
                        LottieView(name: "human", loopMode: .loop)
                            .frame(width: 130, height: 130)
                            .hAlign(.top)
                        
                        HStack{
                            Button{
                                withAnimation {
                                    isShowPopup = false
                                    coordinator.pop()
                                }
                            }label: {
                                Text("Back to home".cw_localized)
                                    .font(.bold(size: 16))
                                    .foregroundColor(.yellow)
                                    .padding(.horizontal)
                                    .padding(.vertical,7)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 2)
                                            .foregroundColor(.yellow)
                                    }
                            }
                            
                            Button{
                                withAnimation {
                                    isShowPopupFail = false
                                    listText.removeAll()
                                    listImg.removeAll()
                                    checkedImg = ""
                                    checkedText = ""
                                    if listText.isEmpty{
                                        listText = CONSTANT.SHARED.DATA_SURROUNDING
                                        listText = listText.shuffled()
                                        
                                        listImg = CONSTANT.SHARED.DATA_SURROUNDING
                                        listImg = listText.shuffled()
                                    }
                                    heartPoint = 5
                                }
                            }label: {
                                Text("Play Again".cw_localized)
                                    .font(.bold(size: 16))
                                    .foregroundColor(.blue)
                                    .padding(.horizontal)
                                    .padding(.vertical,7)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 2)
                                            .foregroundColor(.blue)
                                    }
                            }
                        }
                        .vAlign(.bottom)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .background(Color.text)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
        }
        .onAppear{
            listText.removeAll()
            listImg.removeAll()
            
            if listText.isEmpty{
                listText = CONSTANT.SHARED.DATA_SURROUNDING
                listText = listText.shuffled()
                
                listImg = CONSTANT.SHARED.DATA_SURROUNDING
                listImg = listText.shuffled()
            }
        }
        .onChange(of: heartPoint) { newValue in
            if newValue <= 0 {
                withAnimation {
                    isShowPopupFail = true
                }
            }
        }
        .onChange(of: listImg.count) { newValue in
            if newValue <= 0 {
                loadAudio(nameSound: "congralutions")
                withAnimation {
                    isShowPopup = true
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
}

