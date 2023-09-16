//
//  CreateUsernameView.swift
//  SimpleQuizzApp
//
//  Created by daktech on 10/08/2023.
//

import SwiftUI

struct CreateUsernameView: View {
    @AppStorage("Language") var language: String = "en"
    @State var name: String = ""
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack{
            VStack{
                Text("Quiz kid app")
                    .font(.bold(size: 22))
                    .foregroundColor(Color.text)
                
                VStack{
                    Text("Welcome".cw_localized)
                        .font(.bold(size: 16))
                        .foregroundColor(Color.background)
                        .padding(.bottom, 10)
                    Text("Please enter your name".cw_localized)
                        .font(.bold(size: 12))
                        .foregroundColor(Color.text2)
                        .padding(.bottom, 15)
                    
                    HStack{
                        Text(name.isEmpty ? "Enter your name".cw_localized : "")
                            .font(Font.medium(size: 16))
                            .foregroundColor(.text2)
                            .hAlign(.leading)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.horizontal)
                    .overlay{
                        TextField("", text: $name)
                            .foregroundColor(Color.text2)
                            .padding(.horizontal)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color.text2)
                    )
                    .background(Color.text)
                    
                    VStack {
                        Text("START".cw_localized)
                            .font(.bold(size: 18))
                            .foregroundColor(Color.text)
                            .padding(.vertical, 10)
                            .hAlign(.center)
                            .frame(height: 50)
                            .cornerRadius(6)
                            .background(Color.blue)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                User.shared.userEmail = name
                                if User.shared.userEmail != "" {
                                    coordinator.push(.homeView)
                                }
                            }
                            .disabled(name.isEmpty || name.count < 2)
                    }
                }
                .padding()
                .background(Color.text)
                .cornerRadius(6)
                .padding(.horizontal)
            }
        }
        .hAlign(.center)
        .vAlign(.center)
        .background(Color.accentColor)
    }
}
