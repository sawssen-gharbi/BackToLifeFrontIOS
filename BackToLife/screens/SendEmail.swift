//
//  SendEmail.swift
//  BackToLife
//
//  Created by Mac mini 8 on 15/4/2023.
import SwiftUI

struct ResetView: View {
    @State private var email: String = ""
    @State private var isLoading: Bool = false
    @State private var message: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Image("email")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                
                CaptionedTextField(caption: "Email Address", text: $email, placeholder: "Enter your email")
                    .padding([.top], 20)

                
                
             Button(action: {
                                     Task {
                                         let result: () = try await resetPassword()
                                         isLoading = true // set isLoggedIn to true if login is successful
                                     }
                                 }) {
                                     Text("Work Your email")
                                         .frame(maxWidth: .infinity)
                                         .padding()
                                         .foregroundColor(.white)
                                         .background(Color("DarkPink"))
                                         .cornerRadius(10)
                                         .padding(.horizontal, 20)
                                 }
                                 .background(
                                     NavigationLink(
                                         destination: ResetPasswordPage(),
                                         isActive: $isLoading,
                                         label: { EmptyView() }
                                     ))
                
                Text(message)
                    .foregroundColor(message == "email sent successfully." ? .green : .red)
                    .padding()
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Send email", displayMode: .inline)
            .navigationBarTitleDisplayMode(.large)
            
            .fullScreenCover(isPresented: $isLoading) {
                ResetPasswordPage()
            }
        }
    }
    
    private func resetPassword() {
        //isLoading = true
        
        let url = URL(string: "http://localhost:7001/user/reset_password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "email=\(email)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        message = "email sent successfully."
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController?.present(UIHostingController(rootView: ResetPasswordPage()), animated: true)
                        }
                    } else {
                        message = "Failed to send email. Please try again."
                    }
                } else {
                    message = "Failed to send email. Please try again."
                }
            }
        }.resume()
    }
}
