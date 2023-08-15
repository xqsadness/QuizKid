//
//  HomeView.swift
//  DefaultProject
//
//  Created by Darktech on 8/10/23.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    @AppStorage("USERNAME") var USERNAME: String = ""
    @EnvironmentObject var coordinator: Coordinator
    @ObservedResults(Point.self) var point
    
    var body: some View {
        VStack {
            HStack{
                Text("Hi \(USERNAME)")
                    .font(.bold(size: 20))
                    .foregroundColor(Color.background)
                    .hAlign(.leading)
            }
            .onTapGesture {
                coordinator.push(.speechToTextView)
            }
            
            VStack {
                HStack{
                    Image("pngwing.com (4)")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.leading)
                    
                    VStack(spacing: 5) {
                        Text("Math")
                            .font(.bold(size: 16))
                            .foregroundColor(Color.background)
                            .hAlign(.leading)
                        Text("\(QUIZDEFAULT.SHARED.listQuestionsMath.count) questions")
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
                                        .trim(from: 0, to: CGFloat(point.first?.pointMath ?? 0) / CGFloat(QUIZDEFAULT.SHARED.listQuestionsMath.count))
                                        .stroke(Color(hex: "FFFFFF"), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                }
                            
                            Text("\(String(format: "%.0f", CGFloat(point.first?.pointMath ?? 0) * CGFloat(QUIZDEFAULT.SHARED.listQuestionsMath.count)))%")
                                .font(.bold(size: 12))
                                .foregroundColor(Color.text)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(Color(red: 0, green: 0.45, blue: 1).opacity(0.24))
                .cornerRadius(12)
                .onTapGesture {
                    coordinator.push(.mathView)
                }
                
                HStack{
                    Image("chromatic")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.leading)
                    
                    VStack(spacing: 5) {
                        Text("Color")
                            .font(.bold(size: 16))
                            .foregroundColor(Color.background)
                            .hAlign(.leading)
                        Text("10 questions")
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
                                        .trim(from: 0, to: 0.68)
                                        .stroke(Color(hex: "FFFFFF"), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                }
                            
                            Text("68%")
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
                
                HStack{
                    Image("PngItem_766243")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.leading)
                    
                    VStack(spacing: 5) {
                        Text("Listen")
                            .font(.bold(size: 16))
                            .foregroundColor(Color.background)
                            .hAlign(.leading)
                        Text("\(QUIZDEFAULT.SHARED.listQuestionsListen.count) questions")
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
                            
                            Text("\(String(format: "%.0f", CGFloat(point.first?.pointListen ?? 0) * CGFloat(QUIZDEFAULT.SHARED.listQuestionsListen.count)))%")
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
                
                HStack{
                    Image("flag")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.leading)
                    
                    VStack(spacing: 5){
                        Text("Surrounding objects")
                            .font(.bold(size: 16))
                            .foregroundColor(Color.background)
                            .hAlign(.leading)
                        Text("10 questions")
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
                                        .trim(from: 0, to: 0.68)
                                        .stroke(Color(hex: "FFFFFF"), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                }
                            
                            Text("68%")
                                .font(.bold(size: 12))
                                .foregroundColor(Color.text)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(Color(red: 0.78, green: 0.56, blue: 0.95).opacity(0.48))
                .cornerRadius(12)
                
                HStack{
                    Image("history-book")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.leading)
                    
                    VStack(spacing: 5) {
                        Text("History")
                            .font(.bold(size: 16))
                            .foregroundColor(Color.background)
                            .hAlign(.leading)
                        Text("\(QUIZDEFAULT.SHARED.listQuestionsHistory.count) questions")
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
                
                HStack{
                    Image("history-book")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.leading)
                    
                    VStack(spacing: 5) {
                        Text("Listen And Repeat")
                            .font(.bold(size: 16))
                            .foregroundColor(Color.background)
                            .hAlign(.leading)
                        Text("\(QUIZDEFAULT.SHARED.listListenAndRepeat.count) questions")
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
                                        .trim(from: 0, to: CGFloat(point.first?.pointListenAndRepeat ?? 0) / CGFloat(QUIZDEFAULT.SHARED.listListenAndRepeat.count))
                                        .stroke(Color.text, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                }
                            
                            Text("\(String(format: "%.0f", CGFloat(point.first?.pointListenAndRepeat ?? 0) * CGFloat(QUIZDEFAULT.SHARED.listListenAndRepeat.count)))%")
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
                    coordinator.push(.listenAndRepeat)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal)
        .background(Color(red: 0.89, green: 0.79, blue: 0.98))
    }
}
