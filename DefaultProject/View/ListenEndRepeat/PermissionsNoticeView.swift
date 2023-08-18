//
//  PermissionsNoticeView.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI

struct PermissionsNoticeView: View {
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    var message = "Please allow access"

    var body: some View {
        ZStack{
            Color.background.opacity(0.7).ignoresSafeArea()
            VStack{
                Text("\(message)".localizedLanguage(language: language) + "!")
                    .font(.bold(size: 20))
                    .foregroundColor(.background)
                    .vAlign(.top)
                    .hAlign(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom,5)
                    .multilineTextAlignment(.center)
                
                LottieView(name: "human", loopMode: .loop)
                    .frame(width: 150, height: 150)
                    .hAlign(.top)
                
                HStack{
                    Button{
                        withAnimation {
                            coordinator.pop()
                        }
                    }label: {
                        Text("Back to home".localizedLanguage(language: language))
                            .font(.bold(size: 16))
                            .foregroundColor(.yellow)
                            .padding(.horizontal)
                            .padding(.vertical,7)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.yellow)
                            }
                    }
                    
                    Button{
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        UIApplication.shared.open(settingsURL)
                    }label: {
                        Text("Go to setting".localizedLanguage(language: language))
                            .font(.bold(size: 16))
                            .foregroundColor(.blue)
                            .padding(.horizontal)
                            .padding(.vertical,7)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.blue)
                            }
                    }
                }
                .vAlign(.bottom)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(Color.text)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}
