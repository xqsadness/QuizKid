//
//  LoadImageFirebase.swift
//  DefaultProject
//
//  Created by darktech4 on 29/09/2023.
//

import Foundation
import Kingfisher
import FirebaseStorage
import SwiftUI

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
                KFImage(imageUrl)
                    .resizable()
                    .onSuccess { result in
                        // Xử lý sau khi hình ảnh tải thành công
                        print("Image loaded successfully")
                    }
                    .retry(maxCount: 3, interval: .seconds(5))
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .fade(duration: 0.25)
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
