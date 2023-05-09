//
//  register.swift
//  BackToLife
//
//  Created by Mac mini 8 on 20/3/2023.
//

//  register.swift
//  BackToLife
//
//  Created by Mac mini 8 on 20/3/2023.
//

import SwiftUI

struct register: View {
    let image  = UIImage (named: "register")
    @EnvironmentObject var userData: UserData
      @StateObject private var viewModel = ViewModel()
    @State private var isLoggedIn = false
    @State private var email: String = ""
    // by default it's empty
    @State private var firstname: String = "" // by default it's empty
    @State private var nickName: String = "" // by default it's empty
    @State private var address: String = ""
    @State private var role: String = ""

    @State private var password: String = "" // by default it's empty
    @State private var phone: String = "" // by default it's empty
    @State private var isOn = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    var body: some View {
        NavigationView{
            ScrollView {
                ZStack {
                    
                    VStack {
                        Text("Sign Up")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Image(uiImage: image!)
                            .resizable()
                            .frame(width: 200, height: 300)
                        
                        CaptionedTextField(caption: "FirstName", text: $viewModel.firstName, placeholder: "Enter your firstName")
                            .padding([.top], 20)
                        CaptionedTextField(caption: "Your Nickname", text: $viewModel.nickName, placeholder: "Enter your nickName")
                            .padding([.top], 20)
                        CaptionedTextField(caption: "Email Address", text: $viewModel.email, placeholder: "Enter your email")
                            .padding([.top], 20)
                        ViewableSecureField(caption: "Password", text: $viewModel.password, placeholder: "Enter your password")
                            .padding([.top], 5)
                        if viewModel.errorMessage != "" {
                            Text(viewModel.errorMessage)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.red)
                        }
                        
                        CaptionedTextField(caption: "Phone Number", text: $viewModel.phone, placeholder: "Enter phone number")
                            .keyboardType(.numberPad) // add keyboardType modifier to the CaptionedTextField view
                            .padding()
                        CaptionedTextField(caption: "Your Address", text: $viewModel.address, placeholder: "Enter your address")
                            .padding([.top], 20)
                        HStack{
                            Toggle(isOn: $isOn) {
                                Text("I'm a doctor")
                            }
                            .toggleStyle(iOSCheckboxToggleStyle()).foregroundColor(Color("DarkPink"))
                            .onChange(of: isOn) { newValue in
                                if newValue {
                                    showingImagePicker = true
                                    viewModel.role = "doctor"
                                    
                                    // Perform any additional logic here if needed
                                }
                            }
                            
                            
                            
                            
                        }}}
                
                
                
                Button(action: {
                   
                            Task {
                                let result: () = try await viewModel.attemptLogin(userData: self.userData )
                                if viewModel.authSuccessful {
                                                       isLoggedIn = true
                                                   }
                            }
                       
                    }) {
                        Text("Create Account")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor( Color("white"))
                            .frame(height: 44)
                            .padding(.horizontal, 88)
                            .background(Color("DarkPink"))
                            .cornerRadius(50)
                    }
                                      
                                      
                                      .background(
                                          NavigationLink(
                                              destination: LoginView(),
                                              isActive: $isLoggedIn,
                                              label: { EmptyView() }
                                          )
                                          
                                      )
                HStack {
                    Text("Already have an account!")
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .foregroundColor(Color("DarkPink"))
                    }
                }
                
                
            }
            VStack {
                ForEach(0..<100) { index in
                    Text("Row \(index)")
                        .font(.title)
                        .padding()
                }
            }
        }.navigationBarBackButtonHidden(true)
        
    }
    
}
struct register_Previews: PreviewProvider {
    static var previews: some View {
        register()
    }
}
struct SocalLoginButton: View {
    var image: Image
    var text: Text
    
    var body: some View {
        HStack {
            image
                .padding(.horizontal)
            Spacer()
            text
                .font(.title2)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(50.0)
        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
    }
}

struct PrimaryButton: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("DarkPink"))
            .cornerRadius(50)
            .padding(.horizontal,88)
    }
}

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        // 1
        Button(action: {

            // 2
            configuration.isOn.toggle()

        }, label: {
            HStack {
                // 3
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")

                configuration.label.foregroundColor(Color("DarkPink"))
            }
        })
    }
}

