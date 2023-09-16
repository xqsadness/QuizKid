//
//  AuthManagerViewModel.swift
//  DefualtSource
//
//  Created by darktech4 on 07/09/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AuthManagerViewModel: ObservableObject {
    static var shared = AuthManagerViewModel()
    
    @Published var email = ""
    @Published var pswd = ""
    @Published var errorMessage = ""
    @Published var showHidePswd = false
    @Published var isLoading: Bool = false
    @Published var showError = false
    @Published var isSignin = true
    
    func login(){
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: pswd)
                
                DispatchQueue.main.async {
                    User.shared.userUID = authResult.user.uid
                    User.shared.userEmail =  authResult.user.email ?? "nil"
                    LocalNotification.shared.message("Login sucsess", .success)
                    Coordinator.shared.push(.homeView)
                }
            } catch {
                await setError(error)
            }
        }
    }
    func registerUser(){
        isLoading = true
//        closeKeyBoard()
        Task {
            do{
                try await Auth.auth().createUser(withEmail: email, password: pswd)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isSignin = true
                }
                LocalNotification.shared.message("Register sucsess", .success)
            }catch{
                try await Auth.auth().currentUser?.delete()
                await setError(error)
            }
        }
    }
    
    func setError(_ error: Error) async{
        await MainActor.run(body: {
            LocalNotification.shared.message(error.localizedDescription, .error)
            isLoading = false
        })
    }
    
    func logoutUser(){
        do {
            try Auth.auth().signOut()
            LocalNotification.shared.message("Logout sucsess", .success)
        }
        catch let err {
            print("Error logout: " + err.localizedDescription)
            return
        }
        resetUserData()
    }
    
    func resetUserData() {
        self.email = ""
        self.pswd = ""
        User.shared.userEmail = ""
        User.shared.userUID = ""
    }
}
