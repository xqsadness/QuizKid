//
//  ItemTextView.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI

struct ItemTextView: View {
    @AppStorage("Language") var language: String = "en"
    @Binding var countCorrect: Int
    @Binding var checkedImg: String
    @Binding var checkedText: String
    @State var answer: String
    @Binding var listText: [QUIZ]
    @Binding var listImg: [QUIZ]
    @Binding var heartPoint: Int
    @State var size: CGSize
    
    var loadAudio: ((String) -> Void)
    
    var body: some View {
        VStack {
            Text("\(answer.cw_localized)")
                .font(.bold(size: 14))
                .foregroundColor(Color.background)
                .padding(10)
                .cornerRadius(10)
        }
        .frame(width: (size.width - 15) / 2, height: 70)
        .background(checkedText.cw_localized == answer.cw_localized ? Color.blue.opacity(0.5) : Color.clear)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .foregroundColor(Color.gray)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                if checkedText.cw_localized == answer.cw_localized {
                    checkedText = ""
                }else{
                    checkedText = answer.cw_localized
                    if checkedImg.cw_localized == checkedText.cw_localized{
                        if let index = listText.firstIndex(where: { $0.answer.cw_localized == checkedText.cw_localized }) {
                            listText.remove(at: index)
                            listImg.removeAll(where: {$0.answer.cw_localized == checkedText.cw_localized})
                        }
                        loadAudio("correct")
                        countCorrect += 1
                        checkedImg = ""
                        checkedText = ""
                    }else if !checkedImg.isEmpty == !checkedText.isEmpty{
                        loadAudio("wrong")
                        heartPoint -= 1
                    }
                }
                Point.updatePointSurrounding(point: countCorrect)
            }
        }
    }
}

