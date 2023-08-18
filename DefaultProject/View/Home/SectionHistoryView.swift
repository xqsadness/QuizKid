//
//  SectionHistoryView.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI
import RealmSwift

struct SectionHistoryView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @ObservedResults(Point.self) var point
    
    var body: some View {
        HStack{
            Image("history-book")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading)
            
            VStack(spacing: 5) {
                Text("History".localizedLanguage(language: language))
                    .font(.bold(size: 16))
                    .foregroundColor(Color.background)
                    .hAlign(.leading)
                Text("\(QUIZDEFAULT.SHARED.listQuestionsHistory.count) \("questions".localizedLanguage(language: language))")
                    .font(.bold(size: 14))
                    .foregroundColor(Color.text)
                    .hAlign(.leading)
            }
            
            Spacer()
            
            VStack{
                ZStack {
                    Image("Ellipse")
                        .resizable()
                        .frame(width: 52, height: 52)
                        .overlay {
                            Circle()
                                .trim(from: 0, to: CGFloat(point.first?.pointHistory ?? 0) / CGFloat(QUIZDEFAULT.SHARED.listQuestionsHistory.count))
                                .stroke(Color.text, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                        }
                    
                    Text("\(String(format: "%.0f", CGFloat(point.first?.pointHistory ?? 0) * CGFloat(QUIZDEFAULT.SHARED.listQuestionsHistory.count)))%")
                        .font(.bold(size: 12))
                        .foregroundColor(Color.text)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(Color(red: 0.77, green: 0.81, blue: 0.84))
        .cornerRadius(12)
        .onTapGesture {
            coordinator.push(.historyView)
        }
    }
}

