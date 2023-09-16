//
//  ContentView.swift
//  DefaultProject
//
//  Created by CycTrung on 04/06/2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("USERNAME") var USERNAME: String = ""

    var body: some View {
        if User.shared.userUID != "" {
            HomeView()
        } else {
            LoginDefaultView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
