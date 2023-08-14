//
//  Question.swift
//  DefaultProject
//
//  Created by darktech4 on 11/08/2023.
//

import Foundation
import SwiftUI

struct Question: Identifiable{
    var id: UUID?
    var questionText: String = ""
    var answer: String = ""
    var optionA: String = ""
    var optionB: String = ""
    var optionC: String = ""
    var optionD: String = ""
    var image: String = ""
}
