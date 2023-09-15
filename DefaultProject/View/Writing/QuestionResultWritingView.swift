//
//  QuestionResultView.swift
//  DefaultProject
//
//  Created by darktech4 on 17/08/2023.
//

import SwiftUI

struct QuestionResultWritingView: View {
    @AppStorage("Language") var language: String = "en"
    @Binding  var isCorrect: Bool
    @Binding var isShowPopupCheck: Bool
    @Binding var answer: String
    
    var handleContinue: (() -> Void)
    
    var body: some View {
        VStack(spacing: 7){
            HStack{
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color(hex: isCorrect ? "58a700" : "ea2b2b"))
                Text(isCorrect ? "Perfect".cw_localized : "Wrong".cw_localized)
                    .font(.bold(size: 20))
                    .foregroundColor(Color(hex: isCorrect ? "58a700" : "ea2b2b"))
            }
            .hAlign(.topLeading)
            .padding(.top,15)
            
            Text("Answer:".cw_localized)
                .font(.bold(size: 16))
                .foregroundColor(Color(hex: isCorrect ? "58a700" : "ea2b2b"))
                .hAlign(.leading)
            Text(" \(answer.cw_localized)")
                .font(.bold(size: 14))
                .foregroundColor(Color(hex: isCorrect ? "58a700" : "ea2b2b"))
                .hAlign(.leading)
            
            Button {
                withAnimation {
                    isShowPopupCheck = false
                }
            } label: {
                Text("CONTINUE".cw_localized)
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
