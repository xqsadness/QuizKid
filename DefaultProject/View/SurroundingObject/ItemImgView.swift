//
//  ItemImgView.swift
//  DefaultProject
//
//  Created by darktech4 on 18/08/2023.
//

import SwiftUI
import FirebaseStorage
import SDWebImage
import SDWebImageSwiftUI
import Kingfisher

struct ItemImgView: View {
    @AppStorage("Language") var language: String = "en"
    @Binding var countCorrect: Int
    @Binding var checkedImg: String
    @Binding var checkedText: String
    @State var img: String
    @State var answer: String
    @Binding var listText: [QUIZ]
    @Binding var listImg: [QUIZ]
    @Binding var heartPoint: Int
    @State var size: CGSize
    
    var loadAudio: ((String) -> Void)
    @State private var downloadedImage: UIImage? = nil

    var body: some View {
        VStack {
            FirebaseImageView2(imageName: img)
                .frame(height: 50)
            
        }
        .frame(width: (size.width - 15) / 2, height: 70)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .foregroundColor(Color.gray)
        )
        .overlay{
            Rectangle()
                .foregroundColor(Color.blue.opacity(0.5))
                .opacity(checkedImg == answer.cw_localized ? 1 : 0)
                .cornerRadius(10)
        }
        .contentShape(Rectangle())
        .onAppear{}
        .onTapGesture {
            withAnimation {
                if checkedImg == answer.cw_localized {
                    checkedImg = ""
                } else {
                    checkedImg = answer.cw_localized
                    if checkedImg.cw_localized == checkedText.cw_localized {
                        if let index = listImg.firstIndex(where: { $0.answer.cw_localized == checkedImg.cw_localized }) {
                            listImg.remove(at: index)
                            listText.removeAll(where: {$0.answer.cw_localized == checkedImg.cw_localized})
                        }
                        loadAudio("correct")
                        countCorrect += 1
                        checkedImg = ""
                        checkedText = ""
                    }else if !checkedImg.isEmpty == !checkedText.isEmpty {
                        loadAudio("wrong")
                        heartPoint -= 1
                    }
                }
                Point.updatePointSurrounding(point: countCorrect)
            }
        }
    }
}

func loadImageFromFirebase(imageName: String, completion: @escaping (Data?) -> Void) {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let imageRef = storageRef.child("\(imageName)")

    imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
        if let error = error {
            // Handle the error
            print("Error downloading image: \(error.localizedDescription)")
            completion(nil)
        } else {
            // Image downloaded successfully
            print("Image downloaded successfully.")
            completion(data)
        }
    }
}

struct FirebaseImageView: View {
    @State private var imageData: Data? = nil
    let imageName: String

    init(imageName: String) {
        self.imageName = imageName
    }
    
    var body: some View {
        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            // Display a placeholder or loading indicator if imageData is nil
            ProgressView()
                .frame(maxHeight: .infinity)
                .foregroundColor(Color.black)
                .onAppear {
                    // Load image here
                    loadImageFromFirebase(imageName: self.imageName) { data in
                        DispatchQueue.main.async {
                            self.imageData = data
                        }
                    }
                }
        }
    }
}


struct FirebaseImageView2: View {
    let imageName: String

    @State private var imageUrl: URL?

    init(imageName: String) {
        self.imageName = imageName
    }

    var body: some View {
        VStack {
            if let imageUrl = imageUrl {
//                WebImage(url: imageUrl)
                KFImage( imageUrl)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            // Tải URL từ Firebase Storage khi chế độ xem xuất hiện
            getFirebaseStorageURL(forImageName: imageName) { url in
                DispatchQueue.main.async {
                    self.imageUrl = url
                }
            }
        }
    }
}


func getFirebaseStorageURL(forImageName imageName: String, completion: @escaping (URL?) -> Void) {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let imageRef = storageRef.child(imageName)

    imageRef.downloadURL { (url, error) in
        if let error = error {
            // Xử lý lỗi nếu có
            print("Error getting download URL: \(error.localizedDescription)")
            completion(nil)
        } else if let url = url {
            // Trả về URL nếu tìm thấy
            completion(url)
        }
    }
}
