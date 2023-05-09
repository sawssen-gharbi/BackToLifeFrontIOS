import Foundation
import SwiftUI

extension register {
    @MainActor class ViewModel: NSObject, ObservableObject {
        
         
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var firstName: String = ""
        @Published var nickName: String = ""
        @Published var phone: String = ""
        @Published var role: String = "patient"
        @Published var address: String = ""
        @Published var authSuccessful: Bool = true
        @Published var errorMessage: String = ""
        @Published var isLoading: Bool = false
        
        
        //google
        @Published var isLoginSuccessed = false
        

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
                
                let tokenRes = try await AuthenticationService()._Register(email, password, firstName, nickName, phone, address, role) { (resp) in
                    
                    if(resp == true){
                        
                        print("success signUp")
                        authSuccessful = true

                        
                    } else {
                        print("error signUp")
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

extension String {
    var isValidEmail: Bool {
        // Add your email validation logic here
        // For example:
        let emailRegex = "\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b"
        let emailPredicate = NSPredicate(format:"SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        // Add your password validation logic here
        // For example, to require at least 8 characters:
        return self.count >= 8
    }
}
