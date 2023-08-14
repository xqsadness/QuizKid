//
//  PopupScoreView.swift
//  DefaultProject
//
//  Created by darktech4 on 12/08/2023.
//

import SwiftUI

struct PopupScoreView: View {
    @Binding var isShowPopup: Bool
    @Binding var countCorrect: Int
    @Binding var countWrong: Int
    @State var totalQuestion: Int
    
    var body: some View {
        VStack{
            Text(countCorrect == 0 ? "You didn't get any question right !" : "Congralutions! You have scored")
                .font(.bold(size: 20))
                .foregroundColor(.background)
                .vAlign(.top)
                .hAlign(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom,15)
            
            Circle()
                .foregroundColor(Color(hex: "796dee"))
                .frame(width: 130, height: 130)
                .overlay(
                    VStack(spacing: 10){
                        Text("\(countCorrect)")
                            .foregroundColor(.text)
                            .font(.bold(size: 40))
                        
                        Text("Out of \(totalQuestion)")
                            .foregroundColor(.text)
                            .font(.regular(size: 19))
                    }
                )
                .vAlign(.top)
            
            Button{
                withAnimation {
                    isShowPopup = false
                }
            }label: {
                Text("Back to home")
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
        .frame(height: 300)
        .background(Color.text)
        .cornerRadius(12)
        .padding(.horizontal)
        .overlay {
            LottieView(name: "congralutions", loopMode: .loop)
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .padding(.horizontal)
                .allowsHitTesting(false)
        }
    }
}

