//
//  SectionColorView.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI
import RealmSwift

struct SectionColorView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @ObservedResults(Point.self) var point
    
    var body: some View {
        HStack{
            Image("chromatic")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading)
            
            VStack(spacing: 5) {
                Text("Color".cw_localized)
                    .font(.bold(size: 16))
                    .foregroundColor(Color.background)
                    .hAlign(.leading)
                Text("\(CONSTANT.SHARED.DATA_COLOR.count) \("questions".cw_localized)")
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
                        .overlay{
                            Circle()
                                .trim(from: 0, to: CGFloat(point.first?.pointColor ?? 0) / CGFloat(CONSTANT.SHARED.DATA_COLOR.count))
                                .stroke(Color(hex: "FFFFFF"), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                        }
                    
                    Text("\(String(format: "%.0f", CGFloat(point.first?.pointColor ?? 0) / CGFloat(CONSTANT.SHARED.DATA_COLOR.count) * 100 ))%")
                        .font(.bold(size: 12))
                        .foregroundColor(Color.text)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(Color(red: 0.96, green: 0.33, blue: 0.33).opacity(0.48))
        .cornerRadius(12)
        .onTapGesture {
            coordinator.push(.colorView)
        }
    }
}
