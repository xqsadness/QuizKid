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
    @AppStorage("Language") var language: String = "en"
    @EnvironmentObject var coordinator: Coordinator
    @State private var selectedLanguage: Language = .english(.us)
    
    var body: some View {
        VStack {
            HStack{
                Text("\("Hi".localizedLanguage(language: language)), \(USERNAME)")
                    .font(.bold(size: 20))
                    .foregroundColor(Color.background)
                    .hAlign(.leading)
                
                Spacer()
                
                Image("\(language)")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        coordinator.push(.chooseLanguageView)
                    }
            }
            .zIndex(10)
            
            VStack {
                SectionMathView()
                
                SectionColorView()
                
                SectionListeningView()
                
                SectionSurroundingObjectView()
                
                SectionHistoryView()
                
                SectionListenAndRPView()
                
                SectionWritingView()
            }
            .zIndex(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal)
        .background(Color(red: 0.89, green: 0.79, blue: 0.98))
        .onAppear{
            switch language{
            case "en":
                selectedLanguage = .english(.us)
            case "vi":
                selectedLanguage = .vietnamese
            case "fr":
                selectedLanguage = .french
            case "ru":
                selectedLanguage = .russian
            default: break
            }
        }
    }
}

extension String {
    func localizedLanguage(language: String = "en") -> String {
        if let bundlePath = Bundle.main.path(forResource: language, ofType: "lproj") {
            if let bundle = Bundle(path: bundlePath) {
                return bundle.localizedString(forKey: self, value: self, table: nil)
            }
        }
        return self
    }
}
