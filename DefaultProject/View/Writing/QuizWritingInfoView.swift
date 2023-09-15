//
//  QuizInfoView.swift
//  DefaultProject
//
//  Created by darktech4 on 17/08/2023.
//

import SwiftUI

struct QuizWritingInfoView: View {
    @AppStorage("Language") var language: String = "en"
    @Binding var progress: Double
    @Binding var selectedTab: Int
    @Binding var countCorrect: Int
    @Binding var countWrong: Int
    @Binding var isShowPopupCheck: Bool
    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        HStack {
            VStack {
                Text("\(selectedTab + 1) \("of".localizedLanguage(language: language)) \(CONSTANT.SHARED.DATA_WRITING.count)")
                    .font(.bold(size: 16))
                    .foregroundColor(Color.background)
                ProgressView(value: min(max(progress, 0), Double(CONSTANT.SHARED.DATA_WRITING.count - 1)), total: Double(CONSTANT.SHARED.DATA_WRITING.count - 1))
            }
            
            HStack {
                Text("\(countCorrect)")
                    .font(.bold(size: 18))
                    .foregroundColor(.text)
                
                Image(systemName: "checkmark")
                    .imageScale(.medium)
                    .foregroundColor(.text)
            }
            .padding(8)
            .frame(width: 85, height: 40)
            .background(Color(hex: "9ae3ab"))
            .cornerRadius(15)
            .onTapGesture {
                focusedField = nil
            }
            
            HStack {
                Text("\(countWrong)")
                    .font(.bold(size: 18))
                    .foregroundColor(.text)
                
                Image(systemName: "x.circle")
                    .imageScale(.medium)
                    .foregroundColor(.text)
            }
            .padding(8)
            .frame(width: 85, height: 40)
            .background(Color(hex: "ff9d97"))
            .cornerRadius(15)
        }
        .padding(.bottom)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isShowPopupCheck = false
            }
        }
    }
}
