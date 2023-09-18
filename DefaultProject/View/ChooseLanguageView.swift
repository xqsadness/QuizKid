//
//  ChooseLanguageView.swift
//  DefaultProject
//
//  Created by darktech4 on 16/08/2023.
//

import SwiftUI
import CrowdinSDK

struct ChooseLanguageView: SwiftUI.View {
    @AppStorage("USERNAME") var USERNAME: String = ""
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @State var languagesList: [Language] = [.english(.us), .vietnamese, .french, .russian, .japanese]
    
    var body: some SwiftUI.View {
        VStack{
            HStack{
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.background)
                    Text("Languages".cw_localized)
                        .font(.bold(size: 24))
                        .foregroundColor(Color.background)
                }
                .hAlign(.leading)
                
                Spacer()
                
                Text(language)
                    .foregroundColor(.background)
                    .font(.bold(size: 15))
            }
            ScrollView{
                LazyVStack(spacing: 10){
                    ForEach(languagesList, id: \.self){ ele in
                        HStack(spacing: 10){
                            Image("\(ele.code)")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .overlay {
                                    Circle()
                                        .stroke(style: StrokeStyle(lineWidth: 1))
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(.text2)
                                }
                            
                            Text(ele.name)
                                .foregroundColor(ele.code == language ? .text : .background)
                                .font(.regular(size: 15))
                        }
                        .hAlign(.leading)
                        .padding()
                        .background(ele.code == language ? Color(hex: "554BD8") : Color.text)
                        .cornerRadius(10)
                        .contentShape(Rectangle())
                        .animation(.easeInOut, value: language)
                        .onTapGesture {
                            withAnimation {
                                language = ele.code
                                CrowdinSDK.currentLocalization = language
                            }
                        }
                    }
                    
                    HStack(spacing: 10){
                        Image("logout")
                            .resizable()
                            .frame(width: 32, height: 32)
                        
                        Text("Logout")
                            .foregroundColor(.background)
                            .font(.regular(size: 15))
                    }
                    .hAlign(.leading)
                    .padding()
                    .cornerRadius(10)
                    .contentShape(Rectangle())
                    .animation(.easeInOut, value: language)
                    .onTapGesture {
                        AuthManagerViewModel.shared.logoutUser()
                        coordinator.popToRoot()
                        coordinator.push(.loginDefaultView)
                        //                        coordinator.path = NavigationPath()
                    }
                }
            }
            .padding(.top)
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#ededed"))
        .navigationBarBackButtonHidden(true)
    }
}
