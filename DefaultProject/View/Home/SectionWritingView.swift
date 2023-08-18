//
//  SectionWritingView.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI
import RealmSwift

struct SectionWritingView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @ObservedResults(Point.self) var point
    
    var body: some View {
        HStack(spacing: 0) {
            Image("pngegg")
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.leading)
            
            VStack(spacing: 5) {
                Text("Writing".localizedLanguage(language: language))
                    .font(.bold(size: 16))
                    .foregroundColor(Color.background)
                    .hAlign(.leading)
                Text("\(QUIZDEFAULT.SHARED.listWriting.count) \("questions".localizedLanguage(language: language))")
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
                                .trim(from: 0, to: CGFloat(point.first?.pointWriting ?? 0) / CGFloat(QUIZDEFAULT.SHARED.listWriting.count))
                                .stroke(Color.text, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                        }
                    
                    Text("\(String(format: "%.0f", CGFloat(point.first?.pointWriting ?? 0) * CGFloat(QUIZDEFAULT.SHARED.listWriting.count)))%")
                        .font(.bold(size: 12))
                        .foregroundColor(Color.text)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(Color(hex: "#e64d33").opacity(0.3))
        .cornerRadius(12)
        .onTapGesture {
            coordinator.push(.writingView)
        }
    }
}
