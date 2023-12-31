//
//  SectionSurroundingObjectView.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI
import RealmSwift

struct SectionSurroundingObjectView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @ObservedResults(Point.self) var point
    
    var body: some View {
        VStack{
            Image("flag")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading)
            
            VStack(spacing: 5){
                Text("Surrounding objects".cw_localized)
                    .font(.bold(size: 16))
                    .foregroundColor(Color.background)
                    .hAlign(.leading)
                
                HStack{
                    Text("\(CONSTANT.SHARED.DATA_SURROUNDING.count) \("questions".cw_localized)")
                        .font(.bold(size: 14))
                        .foregroundColor(Color.text)
                        .hAlign(.leading)
                    
                    Spacer()
                    
                    VStack{
                        ZStack {
                            Image("Ellipse")
                                .resizable()
                                .frame(width: 52, height: 52)
                                .overlay{
                                    Circle()
                                        .trim(from: 0, to: CGFloat(point.first?.pointSurrounding ?? 0) / CGFloat(CONSTANT.SHARED.DATA_SURROUNDING.count))
                                        .stroke(Color(hex: "FFFFFF"), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                }
                            
                            Text("\(String(format: "%.0f", CGFloat(point.first?.pointSurrounding ?? 0) / CGFloat(CONSTANT.SHARED.DATA_SURROUNDING.count) * 100 ))%")
                                .font(.bold(size: 12))
                                .foregroundColor(Color.text)
                        }
                    }
                    .hAlign(.trailing)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 155)
        .background(Color(red: 0.78, green: 0.56, blue: 0.95).opacity(0.48))
        .cornerRadius(12)
        .onTapGesture {
            coordinator.push(.surroundingObjectView)
        }
    }
}

