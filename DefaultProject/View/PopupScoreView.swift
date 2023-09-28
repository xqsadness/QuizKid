//
//  PopupScoreView.swift
//  DefaultProject
//
//  Created by darktech4 on 12/08/2023.
//

import SwiftUI

struct PopupScoreView: View {
    @AppStorage("Language") var language: String = "en"
    @Binding var isShowPopup: Bool
    @Binding var countCorrect: Int
    @Binding var countWrong: Int
    @State var title: String
    @State var totalQuestion: Int
    @EnvironmentObject var coordinator: Coordinator
    var isShowTimeSpent = true

    var body: some View {
        VStack{
            Circle()
                .foregroundColor(Color(hex: "796dee"))
                .frame(width: 130, height: 130)
                .overlay(
                    VStack(spacing: 10){
                        Text("\(countCorrect)")
                            .foregroundColor(.text)
                            .font(.bold(size: 40))
                        
                        Text("\("Out of".cw_localized) \(totalQuestion)")
                            .foregroundColor(.text)
                            .font(.regular(size: 19))
                    }
                )
                .vAlign(.top)
            
            Text(countCorrect == 0 ? "You didn't get any question right !".cw_localized : "Congralutions! You have scored".cw_localized)
                .font(.bold(size: 20))
                .foregroundColor(.background)
                .vAlign(.top)
                .hAlign(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom,15)
            
            styledText(text: "\(title) Quiz", foregroundColor: .background, font: .bold(size: 16))
                .hAlign(.leading)
                .padding(.bottom)
            
            VStack(spacing: 8){
                HStack{
                    styledText(text: "Correct Answer", foregroundColor: .text2, font: .regular(size: 15))
                    Spacer()
                    styledText(text: "\(countCorrect)", foregroundColor: .background, font: .regular(size: 15))
                }
                .frame(width: 160, alignment: .center)
                
                HStack{
                    styledText(text: "Wrong Answer", foregroundColor: .text2, font: .regular(size: 15))
                    Spacer()
                    styledText(text: "\(countWrong)", foregroundColor: .background, font: .regular(size: 15))
                }
                .frame(width: 160, alignment: .center)
                
                HStack{
                    styledText(text: "Total Answered", foregroundColor: .text2, font: .regular(size: 15))
                    Spacer()
                    styledText(text: "\(totalQuestion)", foregroundColor: .background, font: .regular(size: 15))
                }
                .frame(width: 160, alignment: .center)
                
                if isShowTimeSpent{
                    HStack{
                        styledText(text: "Time spent", foregroundColor: .text2, font: .regular(size: 15))
                        Spacer()
                        styledText(text: "\(QuizTimer.shared.formatTimeInterval(QuizTimer.shared.elapsedTime))", foregroundColor: .background, font: .regular(size: 15))
                    }
                    .frame(width: 160, alignment: .center)
                }
            }
            .hAlign(.center)
            
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
            .vAlign(.bottom)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: countCorrect == 0 ? 420 : 390)
        .background(Color.text)
        .cornerRadius(12)
        .padding(.horizontal)
        .overlay {
            LottieView(name: "congralutions", loopMode: .loop)
                .frame(maxWidth: .infinity)
                .frame(height: 400)
                .padding(.horizontal)
                .allowsHitTesting(false)
        }
    }
}
