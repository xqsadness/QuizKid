//
//  CreateUsernameView.swift
//  SimpleQuizzApp
//
//  Created by daktech on 10/08/2023.
//

import SwiftUI

struct CreateUsernameView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @FocusState private var focusedField: FocusedField?
    @State var name: String = ""
    
    enum FocusedField {
        case name
    }
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    focusedField = nil
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.text)
                    Text("Back".cw_localized)
                        .font(.bold(size: 20))
                        .foregroundColor(Color.text)
                }
                .hAlign(.leading)
                
                Spacer()
            }
            .padding(.horizontal)
            
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
                            .focused($focusedField, equals: .name)
                            .onSubmit {
                                if name.isEmpty || name.count < 2 || name.count > 18{
                                    LocalNotification.shared.message("Name must be >= 2, <= 18 characters", .warning)
                                }else{
                                    focusedField = nil
                                    User.shared.userEmail = name
                                    if User.shared.userEmail != "" {
                                        coordinator.push(.homeView)
                                    }
                                }
                            }
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
                            .cornerRadius(6)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if name.isEmpty || name.count < 2 || name.count > 18{
                                    LocalNotification.shared.message("Name must be >= 2, <= 18 characters", .warning)
                                }else{
                                    focusedField = nil
                                    User.shared.userEmail = name
                                    if User.shared.userEmail != "" {
                                        coordinator.push(.homeView)
                                    }
                                }
                            }
                    }
                }
                .padding()
                .background(Color.text)
                .cornerRadius(6)
                .padding(.horizontal)
            }
            .vAlign(.center)
        }
        .hAlign(.center)
        .vAlign(.top)
        .background(Color.accentColor)
        .onAppear{
            focusedField = .name
        }
        .ignoresSafeArea(.keyboard)
    }
}
