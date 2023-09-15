//
//  ItemImgView.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI

struct ItemImgView: View {
    @AppStorage("Language") var language: String = "en"
    @Binding var countCorrect: Int
    @Binding var checkedImg: String
    @Binding var checkedText: String
    @State var img: String
    @State var answer: String
    @Binding var listText: [QUIZ]
    @Binding var listImg: [QUIZ]
    @Binding var heartPoint: Int
    @State var size: CGSize
    
    var loadAudio: ((String) -> Void)
    
    var body: some View {
        VStack {
            Image("\(img)")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            
        }
        .frame(width: (size.width - 15) / 2, height: 70)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .foregroundColor(Color.gray)
        )
        .overlay{
            Rectangle()
                .foregroundColor(Color.blue.opacity(0.5))
                .opacity(checkedImg == answer.cw_localized ? 1 : 0)
                .cornerRadius(10)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                if checkedImg == answer.cw_localized {
                    checkedImg = ""
                } else {
                    checkedImg = answer.cw_localized
                    if checkedImg.cw_localized == checkedText.cw_localized {
                        if let index = listImg.firstIndex(where: { $0.answer.cw_localized == checkedImg.cw_localized }) {
                            listImg.remove(at: index)
                            listText.removeAll(where: {$0.answer.cw_localized == checkedImg.cw_localized})
                        }
                        loadAudio("correct")
                        countCorrect += 1
                        checkedImg = ""
                        checkedText = ""
                    }else if !checkedImg.isEmpty == !checkedText.isEmpty {
                        loadAudio("wrong")
                        heartPoint -= 1
                    }
                }
                Point.updatePointSurrounding(point: countCorrect)
            }
        }
    }
}
