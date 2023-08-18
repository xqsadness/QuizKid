//
//  SectionListeningView.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI
import RealmSwift

struct SectionListeningView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @ObservedResults(Point.self) var point
    
    var body: some View {
        HStack{
            Image("PngItem_766243")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading)
            
            VStack(spacing: 5) {
                Text("Listen".localizedLanguage(language: language))
                    .font(.bold(size: 16))
                    .foregroundColor(Color.background)
                    .hAlign(.leading)
                Text("\(QUIZDEFAULT.SHARED.listQuestionsListen.count) \("questions".localizedLanguage(language: language))")
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
                                .trim(from: 0, to: CGFloat(point.first?.pointListen ?? 0) / CGFloat(QUIZDEFAULT.SHARED.listQuestionsListen.count))
                                .stroke(Color(hex: "FFFFFF"), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                        }
                    
                    Text("\(String(format: "%.0f", CGFloat(point.first?.pointListen ?? 0) / CGFloat(QUIZDEFAULT.SHARED.listQuestionsListen.count) * 100 ))%")
                        .font(.bold(size: 12))
                        .foregroundColor(Color.text)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(Color(red: 0.31, green: 0.89, blue: 0.57).opacity(0.48))
        .cornerRadius(12)
        .onTapGesture {
            coordinator.push(.listeningView)
        }
    }
}

