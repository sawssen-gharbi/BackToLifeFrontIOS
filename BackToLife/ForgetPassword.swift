//
//  ForgetPassword.swift
//  BackToLife
//
//  Created by Mac mini 8 on 15/4/2023.
//

import SwiftUI

struct ResetPasswordPage: View {
    @State private var email: String = ""
    @State private var resetCode: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = false
    @State private var message: String = ""
    @State private var isShowingLogin = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image("forget")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                    VStack(spacing: 10) {
                      
                        
                        CaptionedTextField(caption: "your code", text: $resetCode, placeholder: "Enter your email")
                            .padding([.top], 20)
                        ViewableSecureField(caption: "New Password", text: $password, placeholder: "Enter your password")
                            .padding([.top], 5)
                        ViewableSecureField(caption: "Password", text: $confirmPassword, placeholder: "Enter your password")
                            .padding([.top], 5)
                    }
                    if isLoading {
                        ProgressView()
                    } else {
                        Button(action: resetPassword) {
                            Text("Reset Password")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(Color("white"))
                                .background(Color("DarkPink"))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                        }
                        .disabled( resetCode.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                    }
                    Text(message)
                        .padding(.top, 10)
                        .foregroundColor(.red)
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing:
                Button(action: {
                    isShowingLogin = true
                }) {
                    Text("Login")
                }
            )
            .fullScreenCover(isPresented: $isShowingLogin) {
                LoginView()
            }
        }
    }
    
    func resetPassword() {
        isLoading = true
        let url = URL(string: "http://localhost:7001/user/edit_password")!
        let body = [                 "resetCode": resetCode,            "password": password        ]
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    message = "Failed to reset password. Please try again. Error: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        message = "Password reset successfully."
                        isShowingLogin = true
                    } else {
                        message = "Failed to reset password. Please try again. Status code: \(httpResponse.statusCode)"
                    }
                }
            }
        }.resume()
    }
}



struct ResetPasswordPage_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordPage()
    }
}
