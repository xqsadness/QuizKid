//
//  test.swift
//  DefaultProject
//
//  Created by darktech4 on 20/09/2023.
//

import SwiftUI
import Combine

class testVMD: ObservableObject{
    @Published var count = 0
    var timer: AnyCancellable?
    var arr = [1,2,3,4,5].publisher
    
    init() {
        setUptimer()
    }
    
    func setUptimer(){
        timer = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink{ time in
                print(time)
                self.count += 1
            }
    }
    
    
}

struct test: View {
    @StateObject var cmd = testVMD()
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack{
            Text("\(formatTime(seconds: cmd.count))")
                .padding(.bottom)
            
            Button{
                cmd.timer?.cancel()
            }label: {
                Text("stop")
            }
            .padding(.bottom)
            
            Button{
                cmd.setUptimer()
            }label: {
                Text("start")
            }
        }
        .onAppear{
            let arr = [1,2,5,2,6,7,8]
            
            cancellable = arr.publisher
                .sink { value in
                    print(value)
                }
            if let jsonURL = Bundle.main.url(forResource: "data", withExtension: "json") {
                
                var urlApi = URL(string: "https://api.github.com/repos/johnsundell/publish")!
                
                let publisher = URLSession.shared.dataTaskPublisher(for: jsonURL)
                
                cancellable = publisher
                    .map(\.data)
//                                .decode(type: QUIZ.self, decoder: JSONDecoder())
//                    .tryMap { data -> QuizDataCombine in
//                        let json = try JSON(data: data)
//
//                        //DATA_COLOR
//                        let jsonColors = json["listQuestionsColor"]
//                        var listColor: [QUIZ] = []
//                        for (_, json) : (String, JSON) in jsonColors{
//                            listColor.append(QUIZ(id: json["id"].stringValue, answer: json["answer"].stringValue, question: json["question"].stringValue, a: json["a"].stringValue, b: json["b"].stringValue, c: json["c"].stringValue, d: json["d"].stringValue, img: json["img"].stringValue))
//                        }
//
//                        //DATA_MATH
//                        let jsonMath = json["listQuestionsMath"]
//                        var listMath: [QUIZ] = []
//                        for (_, json) : (String, JSON) in jsonMath{
//                            listMath.append(QUIZ(id: json["id"].stringValue, answer: json["answer"].stringValue, question: json["question"].stringValue, a: json["a"].stringValue, b: json["b"].stringValue, c: json["c"].stringValue, d: json["d"].stringValue, img: json["img"].stringValue))
//                        }
//
//                        //DATA_LISTEN
//                        let jsonListen = json["listQuestionsListen"]
//                        var listListen: [QUIZ] = []
//                        for (_, json) : (String, JSON) in jsonListen{
//                            listListen.append(QUIZ(id: json["id"].stringValue, answer: json["answer"].stringValue, question: json["question"].stringValue, a: json["a"].stringValue, b: json["b"].stringValue, c: json["c"].stringValue, d: json["d"].stringValue, img: json["img"].stringValue))
//                        }
//
//                        return QuizDataCombine(listQuestionsMath: listMath, listQuestionsColor: listColor, listQuestionsListen: listListen)
//                    }
                    .receive(on: DispatchQueue.main)
                    .sink(
                        receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                print("Request completed successfully.")
                            case .failure(let error):
                                print("Request failed with error: \(error)")
                            }
                        },
                        receiveValue: { value in
                            print("Received value: \(value)")
                        }
                    )
                cancellable?.cancel()

            }
            

        }
    }
    
    func formatTime(seconds: Int) -> String {
        let minutes = (seconds / 60) % 60
        let seconds = seconds % 60

        let timeString = String(format: "%dmin %dsec", minutes, seconds)
        return timeString
    }

}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}

struct Repository: Codable {
    var id: String
    var name: String
    var url: URL
    var full_name: String
    var owner: Owner
}

struct Owner: Codable {
    var id: String
    var login: String
    var type: String
    var site_admin: Bool
}


