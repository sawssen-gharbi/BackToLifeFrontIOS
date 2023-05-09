//
//  loginViewModel.swift
//  BackToLife
//
//  Created by Mac mini 8 on 30/4/2023.
//

import Foundation

extension LoginView {
    @MainActor class ViewModel: NSObject, ObservableObject {
      
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var authSuccessful: Bool = true
        @Published var errorMessage: String = ""
        @Published var isLoading: Bool = false
        
        
        //google
        @Published var isLoginSuccessed = false
        
     
        
        
        // login
        // login
        func attemptLogin(userData: UserData) async {
            isLoading = true
            self.isLoginSuccessed = true
            defer {
                isLoading = false
            }

            
            do {
                
                if email.isEmpty {
                    errorMessage = "Email cannot be empty"
                    authSuccessful = false
                    return
                }
                
                if !email.isValidEmail {
                    errorMessage = "Please enter a valid email"
                    authSuccessful = false
                    return
                }
                
                if password.isEmpty {
                    errorMessage = "Password cannot be empty"
                    authSuccessful = false
                    return
                }
                
                if !password.isValidPassword {
                    errorMessage = "Password must contain at least 8 characters"
                    authSuccessful = false
                    return
                }
                
                let tokenRes = try await AuthenticationService()._login(email, password) { (resp) in
                    
                    if(resp == true){
                        
                        print("success login")
                        authSuccessful = true

                        
                    } else {
                        print("error login")
                    }
                    
                }
                
                userData.token = tokenRes
                print(tokenRes)
                
            } catch let error {
                if type(of: error) == AuthenticationService.AuthenticationError.self {
                    errorMessage = error.localizedDescription
                } else {
                    print("Application error: ", error.localizedDescription)
                    errorMessage = "Connection error"
                }
                authSuccessful = false
            }
        }
    }
}



