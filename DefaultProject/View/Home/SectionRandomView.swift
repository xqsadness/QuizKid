//
//  SectionRandomView.swift
//  DefaultProject
//
//  Created by darktech4 on 27/09/2023.
//

import SwiftUI
import RealmSwift

struct SectionRandomView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @ObservedResults(Point.self) var point
    
    var body: some View {
        VStack(spacing: 0) {
            LottieView(name: "animation_human2", loopMode: .loop)
                .frame(width: 80, height: 60)
            
            VStack(spacing: 5) {
                Text("Random".cw_localized)
                    .font(.bold(size: 14))
                    .foregroundColor(Color.background)
                    .hAlign(.leading)
                
                HStack{
                    Text("\(CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.count) \n\("questions".cw_localized)")
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
                                        .trim(from: 0, to: CGFloat(point.first?.pointListenAndRepeat ?? 0) / CGFloat(CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.count))
                                        .stroke(Color.text, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                }
                            
                            Text("\(String(format: "%.0f", CGFloat(point.first?.pointListenAndRepeat ?? 0) / CGFloat(CONSTANT.SHARED.DATA_LISTEN_AND_REPEAT.count) * 100 ))%")
                                .font(.bold(size: 12))
                                .foregroundColor(Color.text)
                        }
                        .hAlign(.trailing)
                    }
                }
            }

        }
        .padding()
        .frame(height: 155)
        .background(Color(hex: "#e45d807"))
        .cornerRadius(12)
        .onTapGesture {
            coordinator.push(.randomView)
        }
    }
}
