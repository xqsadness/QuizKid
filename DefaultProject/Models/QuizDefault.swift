//
//  QuizDefault.swift
//  DefaultProject
//
//  Created by daktech on 11/08/2023.
//

import Foundation

class QUIZDEFAULT{
    static var SHARED = QUIZDEFAULT()
    
    var listQuestionsMath: [QUIZMATH] = [
        QUIZMATH(answer: "Eight", question: "What is 5 plus 3?", a: "7", b: "8", c: "6", d: "5"),
        QUIZMATH(answer: "Five", question: "How many fingers are there on each of your hands?", a: "4", b: "5", c: "6", d: "7"),
        QUIZMATH(answer: "Three", question: "If you have 4 apples and you give one to your friend, how many apples do you have left?", a: "1", b: "2", c: "3", d: "4"),
        QUIZMATH(answer: "Three", question: "How many faces does a cube have?", a: "1", b: "2", c: "3", d: "6"),
        QUIZMATH(answer: "Zero", question: "What is 8 times 0?", a: "1", b: "3", c: "5", d: "0"),
        QUIZMATH(answer: "Ten", question: "If you have 10 fingers, how many fingers do you need to count to 20?", a: "10", b: "5", c: "3", d: "4"),
        QUIZMATH(answer: "Four", question: "How many legs does a dog have?", a: "2", b: "3", c: "4", d: "5"),
        QUIZMATH(answer: "Fourteen", question: "What is 7 times 2?", a: "9", b: "12", c: "14", d: "21"),
        QUIZMATH(answer: "Eleven", question: "What is 4 plus 7?", a: "54", b: "4", c: "11", d: "14"),
        QUIZMATH(answer: "Cat", question: "If a cat is in front of a chicken coop, the chicken coop is in front of the house, and the house is in front of a pond, then what is in front of a window?", a: "Chicken", b: "Cat", c: "Fish", d: "Dog"),
        QUIZMATH(answer: "9", question: "There is a bridge with 5 ducks on it. Under the bridge, there are 4 ducks. How many ducks are there in total?", a: "10", b: "8", c: "9", d: "11"),
        QUIZMATH(answer: "Go up", question: "You have 3 matchsticks. If you want to form 3 triangles by moving only one matchstick, where do you need to move it?", a: "Go up", b: "Go through the middle", c: "Go underneath", d: "Cannot be done"),
        QUIZMATH(answer: "Sunday", question: "If today is Saturday, what day is tomorrow?", a: "Saturday", b: "Sunday", c: "Monday", d: "Friday"),
        QUIZMATH(answer: "At the end of the road", question: "If you walk 10 steps along a road, where are you?", a: "At the beginning of the road", b: "In the middle of the road", c: "At the end of the road", d: "Cannot be determined"),
        QUIZMATH(answer: "4 times", question: "You have 2 red balls, 3 blue balls, and 1 yellow ball. If you randomly draw a ball from the bag, how many times do you need to draw to ensure you have at least one blue ball?", a: "2 times", b: "3 times", c: "4 times", d: "6 times"),
    ]
    
    var listQuestionsColor: [QUIZCOLOR] = [
        QUIZCOLOR(answer: "Orange", question: "What color is this fruit?", a: "Red", b: "Orange", c: "Yellow", d: "Green", img: "cam"),
        QUIZCOLOR(answer: "Red", question: "What color is this cherry?", a: "Red", b: "Green", c: "Yellow", d: "Purple", img: "cherry"),
        QUIZCOLOR(answer: "White", question: "What color is this dog?", a: "Black", b: "Brown", c: "Red", d: "White", img: "conchotrang"),
        QUIZCOLOR(answer: "Yellow", question: "What color is this?", a: "Yellow", b: "Purple", c: "Blue", d: "Orange", img: "conga"),
        QUIZCOLOR(answer: "Red", question: "What color is this?", a: "Green", b: "Orange", c: "Blue", d: "Red", img: "images (1)"),
        QUIZCOLOR(answer: "Blue", question: "What color is the girl's dress?", a: "Blue", b: "Green", c: "Black", d: "White", img: "IMG_3959-scaled"),
        QUIZCOLOR(answer: "Brown", question: "What color is this rabbit?", a: "Black", b: "Red", c: "Gray", d: "Brown", img: "thonau"),
        QUIZCOLOR(answer: "Red", question: "What color is this?", a: "Green", b: "Orange", c: "Black", d: "Red", img: "xedo"),
        QUIZCOLOR(answer: "Yellow", question: "What color is this?", a: "Purple", b: "Orange", c: "Blue", d: "Yellow", img: "hinh-anh-qua-chuoi-tieu"),
        QUIZCOLOR(answer: "Red", question: "What color is the inside of this watermelon?", a: "Yellow", b: "Green", c: "Black", d: "Red", img: "duahau"),
    ]
    
    var listQuestionsListen: [QUIZLISTEN] = [
        QUIZLISTEN(answer: "Shoes", question: "Shoes", a: "Shoes", b: "Gloves", c: "Coat", d: "Hat", img: ""),
        QUIZLISTEN(answer: "Mining", question: "Mining", a: "Sheep farming", b: "Gardening", c: "Baking", d: "Mining", img: ""),
        QUIZLISTEN(answer: "Planting", question: "Planting", a: "Baking", b: "Cooking rice", c: "Planting", d: "Raising chickens", img: ""),
        QUIZLISTEN(answer: "Elephant", question: "Elephant", a: "Dog", b: "Pig", c: "Elephant", d: "Cat", img: ""),
        QUIZLISTEN(answer: "Rose", question: "Rose", a: "Wild grass flower", b: "Sunflower", c: "Chrysanthemum", d: "Rose", img: ""),
        QUIZLISTEN(answer: "Mouth", question: "Mouth", a: "Nose", b: "Eye", c: "Ear", d: "Mouth", img: ""),
        QUIZLISTEN(answer: "Sun", question: "Sun", a: "Moon", b: "Sun", c: "Mercury", d: "Venus", img: ""),
        QUIZLISTEN(answer: "Planet", question: "Planet", a: "Onion", b: "Leafy greens", c: "Planet", d: "Action", img: ""),
        QUIZLISTEN(answer: "Computer", question: "Computer", a: "Desktop computer", b: "Airplane", c: "Projector", d: "Computer", img: ""),
        QUIZLISTEN(answer: "Baby", question: "Baby", a: "Youngest", b: "Baby", c: "Well-behaved", d: "Grown-up", img: ""),
    ]

    var listQuestionsSurrounding: [QUIZSURROUNDING] = [
        QUIZSURROUNDING(answer: "Watermelon", question: "Watermelon", a: "", b: "", c: "", d: "", img: "duahau"),
        QUIZSURROUNDING(answer: "Banana Pepper", question: "Banana Pepper", a: "", b: "", c: "", d: "", img: "hinh-anh-qua-chuoi-tieu"),
        QUIZSURROUNDING(answer: "Brown Rabbit", question: "Brown Rabbit", a: "", b: "", c: "", d: "", img: "thonau"),
        QUIZSURROUNDING(answer: "Ao Dai", question: "Ao Dai", a: "", b: "", c: "", d: "", img: "IMG_3959-scaled"),
        QUIZSURROUNDING(answer: "Strawberry", question: "Strawberry", a: "", b: "", c: "", d: "", img: "images (1)"),
        QUIZSURROUNDING(answer: "Rooster", question: "Rooster", a: "", b: "", c: "", d: "", img: "conga"),
        QUIZSURROUNDING(answer: "White Dog", question: "White Dog", a: "", b: "", c: "", d: "", img: "conchotrang"),
        QUIZSURROUNDING(answer: "Cherry", question: "Cherry", a: "", b: "", c: "", d: "", img: "cherry"),
        QUIZSURROUNDING(answer: "Orange", question: "Orange", a: "", b: "", c: "", d: "", img: "cam"),
        QUIZSURROUNDING(answer: "Car", question: "Car", a: "", b: "", c: "", d: "", img: "xedo"),
    ]

    var listQuestionsHistory: [QUIZHISTORY] = [
        QUIZHISTORY(answer: "Ba Ria", question: "In the year 1933, France merged Truong Sa into which province?", a: "Ba Ria", b: "Kien Giang", c: "Gia Dinh", d: "Khanh Hoa", img: ""),
        QUIZHISTORY(answer: "Vietnam", question: "The Paracel and Spratly Islands belong to which country?", a: "Vietnam", b: "Thailand", c: "Laos", d: "China", img: ""),
        QUIZHISTORY(answer: "to counter the Soviet Union and socialist countries.", question: "In March 1947, US President Truman officially launched the 'Cold War' for the purpose of?", a: "to counter the Soviet Union and socialist countries.", b: "to maintain world peace and security after the war.", c: "to appease the workers' struggle in capitalist countries.", d: "to counter the liberation movements in Latin America.", img: ""),
        QUIZHISTORY(answer: "play a primary role in maintaining global peace and security.", question: "The role of the United Nations Security Council is to?", a: "play a primary role in maintaining global peace and security.", b: "protect the fundamental national rights of countries.", c: "ensure peace for nations.", d: "prevent countries from violating each other's sovereignty.", img: ""),
        QUIZHISTORY(answer: "Convened the Yalta Conference (USSR) from February 04 to February 11, 1945.", question: "In the final stages of World War II, what did the Allies do to change the global situation?", a: "Launched a massive assault on Germany's capital Berlin.", b: "Urgently demanded a complete defeat of the Nazi powers.", c: "Rapidly organized a new world order after the war.", d: "Convened the Yalta Conference (USSR) from February 04 to February 11, 1945.", img: ""),
        QUIZHISTORY(answer: "the world was divided into two camps: capitalism and socialism.", question: "The fundamental cause of the Cold War after World War II was", a: "the world was divided into two camps: capitalism and socialism.", b: "unsatisfactory post-World War II division of influence.", c: "disagreements at the Yalta Conference.", d: "US not achieving its goals at the Yalta Conference.", img: ""),
        QUIZHISTORY(answer: "the role of the United Nations.", question: "Resolving disputes and conflicts in various regions through peaceful means, this is one of the contents of", a: "the principles of the United Nations.", b: "the role of the United Nations.", c: "resolutions of the Yalta Conference.", d: "the purpose of the United Nations.", img: ""),
        QUIZHISTORY(answer: "5 and 4 BC", question: "When was history created?", a: "5 and 4 BC", b: "6 and 7 BC", c: "1 AND 3 BC", d: "2 and 4 BC", img: ""),
        QUIZHISTORY(answer: "About 5,000 years", question: "About 5,000 years", a: "About 4,000 years", b: "About 3,000 years", c: "About 2,000 years", d: "About 1,000 years", img: ""),
        QUIZHISTORY(answer: "Greece", question: "Who invented history?", a: "Greece", b: "VietNam", c: "Russia", d: "America", img: ""),
    ]
}

struct QUIZMATH {
    var id = UUID()
    var answer: String = ""
    var question: String = ""
    var a: String = ""
    var b: String = ""
    var c: String = ""
    var d: String = ""
}

struct QUIZCOLOR {
    var id = UUID()
    var answer: String = ""
    var question: String = ""
    var a: String = ""
    var b: String = ""
    var c: String = ""
    var d: String = ""
    var img: String = ""
}

struct QUIZSURROUNDING {
    var id = UUID()
    var answer: String = ""
    var question: String = ""
    var a: String = ""
    var b: String = ""
    var c: String = ""
    var d: String = ""
    var img: String = ""
}

struct QUIZLISTEN {
    var id = UUID()
    var answer: String = ""
    var question: String = ""
    var a: String = ""
    var b: String = ""
    var c: String = ""
    var d: String = ""
    var img: String = ""
}

struct QUIZHISTORY {
    var id = UUID()
    var answer: String = ""
    var question: String = ""
    var a: String = ""
    var b: String = ""
    var c: String = ""
    var d: String = ""
    var img: String = ""
}
