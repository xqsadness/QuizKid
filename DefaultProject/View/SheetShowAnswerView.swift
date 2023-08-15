//
//  SheetShowAnswerView.swift
//  DefaultProject
//
//  Created by darktech4 on 15/08/2023.
//

import SwiftUI

struct SheetShowAnswerCorrectView: View {
    @Binding var answer: String
    var callback: (() -> Void)
    
    var body: some View {
        VStack(spacing: 9){
            HStack{
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color(hex: "58a700"))
                Text("Perfect!")
                    .font(.bold(size: 20))
                    .foregroundColor(Color(hex: "58a700"))
            }
            .hAlign(.topLeading)
            .padding(.top,15)
            
            Text("Mean: ")
                .font(.bold(size: 16))
                .foregroundColor(Color(hex: "58a700"))
                .hAlign(.leading)
            Text("\(answer)")
                .font(.bold(size: 18))
                .foregroundColor(Color(hex: "80c23b"))
                .hAlign(.leading)
            
            Button {
                callback()
            } label: {
                Text("CONTINUE")
                    .font(.bold(size: 16))
                    .foregroundColor(Color.white)
                    .padding(10)
                    .hAlign(.center)
                    .background(Color(hex: "58cc02"))
                    .cornerRadius(10)
            }
        }
        .padding()
        .presentationDetents([.height(130)])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#d7ffb8"))
    }
}

struct SheetShowAnswerFailedView: View {
    @Binding var answer: String
    @Binding var titleButon: String
    @Binding var isFail: Bool
    var callback: (() -> Void)
    
    var body: some View {
        VStack(spacing: 9){
            HStack{
                Image(systemName: "x.circle")
                    .imageScale(.large)
                    .foregroundColor(Color(hex: "ff4b4b"))
                Text("Wrong !")
                    .font(.bold(size: 20))
                    .foregroundColor(Color(hex: "ff4b4b"))
            }
            .hAlign(.topLeading)
            .padding(.top,15)
            
            Text("Mean: ")
                .font(.bold(size: 16))
                .foregroundColor(Color(hex: "ff4b4b"))
                .hAlign(.leading)
            Text("\(answer)")
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
        .presentationDetents([.height(130)])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "ffdfe0"))
    }
}

