//
//  SheetShowAnswerView.swift
//  DefaultProject
//
//  Created by darktech4 on 15/08/2023.
//

import SwiftUI

struct SheetShowAnswerCorrectView: View {
    @AppStorage("Language") var language: String = "en"
    @Binding var answer: String
    var callback: (() -> Void)
    
    var body: some View {
        VStack(spacing: 9){
            HStack{
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color(hex: "58a700"))
                Text("Perfect".cw_localized)
                    .font(.bold(size: 20))
                    .foregroundColor(Color(hex: "58a700"))
            }
            .hAlign(.topLeading)
            .padding(.top,15)
            
            Text("Mean:".cw_localized)
                .font(.bold(size: 16))
                .foregroundColor(Color(hex: "58a700"))
                .hAlign(.leading)
            Text(" \(answer.cw_localized.capitalized)")
                .font(.bold(size: 18))
                .foregroundColor(Color(hex: "80c23b"))
                .hAlign(.leading)
            
            Button {
                callback()
            } label: {
                Text("CONTINUE".cw_localized)
                    .font(.bold(size: 16))
                    .foregroundColor(Color.white)
                    .padding(10)
                    .hAlign(.center)
                    .background(Color(hex: "58cc02"))
                    .cornerRadius(10)
            }
        }        
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 130)
        .background(Color(hex: "#d7ffb8"))
        .vAlign(.bottom)
        //                .cornerRadius(13, corners: [.topLeft, .topRight])
        .transition(.move(edge: .bottom))
    }
}

struct SheetShowAnswerFailedView: View {
    @AppStorage("Language") var language: String = "en"
    @Binding var answer: String
    @Binding var titleButon: String
    var callback: (() -> Void)
    
    var body: some View {
        VStack(spacing: 9){
            HStack{
                Image(systemName: "x.circle")
                    .imageScale(.large)
                    .foregroundColor(Color(hex: "ff4b4b"))
                Text("Wrong".cw_localized)
                    .font(.bold(size: 20))
                    .foregroundColor(Color(hex: "ff4b4b"))
            }
            .hAlign(.topLeading)
            .padding(.top,15)
            
            Text("Mean:".cw_localized)
                .font(.bold(size: 16))
                .foregroundColor(Color(hex: "ff4b4b"))
                .hAlign(.leading)
            Text(" \(answer.cw_localized.capitalized)")
                .font(.bold(size: 18))
                .foregroundColor(Color(hex: "f06767"))
                .hAlign(.leading)
            
                Text("\(titleButon)")
                    .font(.bold(size: 16))
                    .foregroundColor(Color.white)
                    .padding(10)
                    .hAlign(.center)
                    .background(Color(hex: "ff4b4b"))
                    .cornerRadius(10)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        callback()
                    }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 130)
        .background(Color(hex: "ffdfe0"))
        .vAlign(.bottom)
        //                .cornerRadius(13, corners: [.topLeft, .topRight])
        .transition(.move(edge: .bottom))
    }
}

