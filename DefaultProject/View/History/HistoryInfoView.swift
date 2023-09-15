//
//  HistoryInfoView.swift
//  DefaultProject
//
//  Created by darktech4 on 17/08/2023.
//

import SwiftUI

struct HistoryInfoView: View {
    @AppStorage("Language") var language: String = "en"
    @Binding var countCorrect: Int
    @Binding var countWrong: Int
    @Binding var selectedTab: Int
    @Binding var progress: Double
    
    var body: some View {
        HStack{
            VStack{
                Text("\(selectedTab + 1) \("of".cw_localized) \(CONSTANT.SHARED.DATA_HISTORY.count)")
                    .font(.bold(size: 16))
                    .foregroundColor(Color.background)
                ProgressView(value: min(max(progress, 0), Double(CONSTANT.SHARED.DATA_HISTORY.count - 1)), total: Double(CONSTANT.SHARED.DATA_HISTORY.count - 1))
            }
            
            HStack{
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
            
            HStack{
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
    }
}
