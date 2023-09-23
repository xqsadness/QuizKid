//
//  FireImageModel.swift
//  DefaultProject
//
//  Created by daktech on 23/09/2023.
//

import Foundation
import Firebase

class FireImageModel: ObservableObject {
    @Published var actualImage: [UIImage] = []

    func downImage() {
        let imageRef = Storage.storage()
        let loc = imageRef.reference().child("Images")
        loc.listAll{(result,error) in
            if error != nil{
                print("Ooops : ", error)
                return
            }
            if let images = result {
                print("number of Images: ", images.items.count)
                for item in images.items {
                    print("images url : " , item)
                    item.getData(maxSize: 15 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("\(error)")
                        }
                        DispatchQueue.main.async {
                            if let theData = data, let image = UIImage(data: theData) {
                                self.actualImage.append(image)
                            }
                        }
                    }
                }
            }
        }
    }
}
