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
        VStack(spacing: 0) {
            Image("pngegg")
                .resizable()
                .frame(width: 60, height: 60)
            
            VStack(spacing: 5) {
                Text("Writing".cw_localized)
                    .font(.bold(size: 14))
                    .foregroundColor(Color.background)
                     .hAlign(.center)
                
                HStack{
                    Text("\(CONSTANT.SHARED.DATA_WRITING.count)\n\("questions".cw_localized)")
                        .font(.bold(size: 14))
                        .foregroundColor(Color.text)
                        .hAlign(.leading)
                    
                    Spacer()
                    VStack{
                        ZStack {
                            Image("Ellipse")
                                .resizable()
                                .frame(width: 52, height: 52)
                                .overlay {
                                    Circle()
                                        .trim(from: 0, to: CGFloat(point.first?.pointWriting ?? 0) / CGFloat(CONSTANT.SHARED.DATA_WRITING.count))
                                        .stroke(Color.text, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                }
                            
                            Text("\(String(format: "%.0f", CGFloat(point.first?.pointWriting ?? 0) / CGFloat(CONSTANT.SHARED.DATA_WRITING.count) * 100 ))%")
                                .font(.bold(size: 12))
                                .foregroundColor(Color.text)
                        }
                        .hAlign(.trailing)
                    }
                    .hAlign(.center)
                }
            }            
        }
        .padding()
        .frame(height: 155)
        .background(Color(hex: "#e64d33").opacity(0.3))
        .cornerRadius(12)
        .onTapGesture {
            coordinator.push(.writingView)
        }
    }
}
