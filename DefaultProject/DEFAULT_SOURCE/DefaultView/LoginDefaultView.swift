//
//  LoginDefaultView.swift
//  DefualtSource
//
//  Created by darktech4 on 06/09/2023.
//

import SwiftUI

struct LoginDefaultView: View {
    @StateObject var appController = APPCONTROLLER.shared
    @StateObject var authManagerViewModel = AuthManagerViewModel.shared
    @EnvironmentObject var coordinator: Coordinator
    @FocusState private var focusedField: FocusedField?
    @State var name: String = ""

    enum FocusedField {
        case username, password
    }
    
    var body: some View {
        VStack{
            styledText(text: "Welcome, \(authManagerViewModel.isSignin ? "Sign in" : "Sign up")", foregroundColor: .background, font: .regular(size: 28))
                .padding(.bottom,50)
            
            if APPCONTROLLER.shared.ADS_READY && User.isShowBanner(){
                SwiftUIBannerAd()
                    .frame(height: 62, alignment: .top)
                    .padding(.bottom)
            }
                        
            HStack{
                TextField("", text: $authManagerViewModel.email)
                    .placeholder(when: authManagerViewModel.email.isEmpty) {
                        Text("Email").foregroundColor(.gray)
                    }
                    .keyboardType(.emailAddress)
                    .foregroundColor(.background)
                    .focused($focusedField, equals: .username)
            }
            .padding(16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            
            HStack{
                if authManagerViewModel.showHidePswd {
                    TextField("", text: $authManagerViewModel.pswd)
                        .placeholder(when: authManagerViewModel.pswd.isEmpty) {
                            Text("Password").foregroundColor(.gray)
                        }
                        .font(.regular(size: 15))
                        .foregroundColor(.background)
                        .focused($focusedField, equals: .password)
                } else {
                    SecureField("Password ...", text: $authManagerViewModel.pswd)
                        .placeholder(when: authManagerViewModel.pswd.isEmpty) {
                            Text("Password").foregroundColor(.gray)
                        }
                        .font(.regular(size: 15))
                        .foregroundColor(.background)
                        .focused($focusedField, equals: .password)
                }
                
                Button(action: {
                    withAnimation {
                        authManagerViewModel.showHidePswd.toggle()
                    }
                }) {
                    Image(systemName: authManagerViewModel.showHidePswd ? "eye" : "eye.slash" )
                        .imageScale(.large)
                        .foregroundColor(.background)
                }
            }
            .padding(16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            
            Button(action: {
                if authManagerViewModel.isSignin{
                    focusedField = nil
                    authManagerViewModel.login()
                }else{
                    authManagerViewModel.registerUser()
                }
            }) {
                Text("\(authManagerViewModel.isSignin ? "Login" : "Sign up")")
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background (Color.green.opacity (0.75))
                    .foregroundColor(.background)
                    .cornerRadius (16)
                    .padding(.top, 16)
            }
            .disableWithOpacity(authManagerViewModel.email == "" || authManagerViewModel.pswd == "" )
            .buttonStyle(PlainButtonStyle())
            
            styledText(text: !authManagerViewModel.isSignin ? "Sign in, if you're have account?" : "Sign up, if you're new?", foregroundColor: .background, font: .regular(size: 15))
                .onTapGesture {
                    withAnimation {
                        authManagerViewModel.isSignin.toggle()
                    }
                }
                .padding(.top)
                .hAlign(.leading)
            
            styledText(text: "Or continue with guest.", foregroundColor: .blue, font: .regular(size: 19))
                .onTapGesture {
                    withAnimation {
                        coordinator.push(.createUsernameView)
                    }
                }
                .padding(.top)
                .hAlign(.center)
        }
        .padding()
        .background(Color.text)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.text)
        .ignoresSafeArea(.keyboard)
        .overlay {
            LoadingView(show: $authManagerViewModel.isLoading)
        }
    }
}


