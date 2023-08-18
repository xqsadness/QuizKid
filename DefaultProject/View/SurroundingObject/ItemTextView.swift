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
    @Binding var listText: [QUIZSURROUNDING]
    @Binding var listImg: [QUIZSURROUNDING]
    @Binding var heartPoint: Int
    @State var size: CGSize
    
    var loadAudio: ((String) -> Void)
    
    var body: some View {
        VStack {
            Text("\(answer.localizedLanguage(language: language))")
                .font(.bold(size: 14))
                .foregroundColor(Color.background)
                .padding(10)
                .cornerRadius(10)
        }
        .frame(width: (size.width - 15) / 2, height: 70)
        .background(checkedText.localizedLanguage(language: language) == answer.localizedLanguage(language: language) ? Color.blue.opacity(0.5) : Color.clear)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .foregroundColor(Color.gray)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                if checkedText.localizedLanguage(language: language) == answer.localizedLanguage(language: language) {
                    checkedText = ""
                }else{
                    checkedText = answer.localizedLanguage(language: language)
                    if checkedImg.localizedLanguage(language: language) == checkedText.localizedLanguage(language: language){
                        if let index = listText.firstIndex(where: { $0.answer.localizedLanguage(language: language) == checkedText.localizedLanguage(language: language) }) {
                            listText.remove(at: index)
                            listImg.removeAll(where: {$0.answer.localizedLanguage(language: language) == checkedText.localizedLanguage(language: language)})
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

