//
//  SectionMathView.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI
import RealmSwift

struct SectionMathView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @ObservedResults(Point.self) var point
    
    var body: some View {
        HStack{
            Image("pngwing.com (4)")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading)
            
            VStack(spacing: 5) {
                Text("Math".cw_localized)
                    .font(.bold(size: 16))
                    .foregroundColor(Color.background)
                    .hAlign(.leading)
                Text("\(CONSTANT.SHARED.DATA_MATH.count) \("questions".cw_localized)")
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
                                .trim(from: 0, to: CGFloat(point.first?.pointMath ?? 0) / CGFloat(CONSTANT.SHARED.DATA_MATH.count))
                                .stroke(Color(hex: "FFFFFF"), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                        }
                    
                    Text("\(String(format: "%.0f", CGFloat(point.first?.pointMath ?? 0) / CGFloat(CONSTANT.SHARED.DATA_MATH.count) * 100 ))%")
                        .font(.bold(size: 12))
                        .foregroundColor(Color.text)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding()
                .zIndex(1)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(Color(red: 0, green: 0.45, blue: 1).opacity(0.24))
        .cornerRadius(12)
        .zIndex(1)
        .onTapGesture {
            coordinator.push(.mathView)
        }
    }
}
