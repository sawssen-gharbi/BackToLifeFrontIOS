//
//  login.swift
//  BackToLife
//
//  Created by Mac mini 8 on 6/4/2023.
//


import SwiftUI


struct LoginView: View {
    
    @EnvironmentObject var userData: UserData
    @StateObject private var viewModel = ViewModel()
    
    @State  var email: String = ""
    @State  var password: String = ""
    @State var emailIsValid: Bool = true
    @State private var isLoggedIn = false
    var role = UserDefaults.standard.string(forKey: "userRole")
    
    
    //    @State private var showLoginGoogleView = false
    //
    //    //186991793457-48c41p24gv1rtucaiqt32mktgpgm3g0p.apps.googleusercontent.com
    
    
    
    var body: some View {
        NavigationView {
            ScrollView{
                ZStack {
                    VStack {
                        
                        Text("Login")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                            .padding(.top, 20)
                        
                        Image(uiImage: #imageLiteral(resourceName: "hey"))
                            .resizable()
                            .frame(width: 300 , height: 200)
                        
                        
                        Spacer()
                        
                        
                        
                        
                        
                        CaptionedTextField(caption: "Email Address", text: $viewModel.email, placeholder: "Enter your email")
                            .padding([.top], 20)
                        ViewableSecureField(caption: "Password", text: $viewModel.password, placeholder: "Enter your password")
                            .padding([.top], 5)
                        if viewModel.errorMessage != "" {
                            Text(viewModel.errorMessage)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.red)
                        }
                        
                        
                        
                        //PrimaryButton(title: "Login")
                        Button(action: {
                            
                            Task {
                                let result: () = try await viewModel.attemptLogin(userData: self.userData )
                                if viewModel.authSuccessful {
                                    isLoggedIn = true
                                }// set isLoggedIn to true if login is successful
                                
                            }
                        }) {
                            Text("Login")
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
                                destination:
                                    role == "patient" ? AnyView(patientHome().navigationBarBackButtonHidden(true))
                                
                                : role  == "doctor" ? AnyView(HomeView().navigationBarBackButtonHidden(true))
                                : AnyView(EmptyView()),
                                isActive: $isLoggedIn,
                                label: { EmptyView() }
                            )
                        )
                        HStack {
                            Text("New around here!")
                            NavigationLink(destination: register()) {
                                Text("Sign Up")
                                    .foregroundColor(Color("DarkPink"))
                            }
                        }
                              
  HStack {
      Text("Forget Password!")
      NavigationLink(destination: ResetView()) {
          Text("Reset Pwd")
              .foregroundColor(Color("DarkPink"))
      }
  }
                        
                 
                        
                     
                    
                   
                        
                    }
                    
                }
            }
        }
    }
    
    
    
    struct login_Previews: PreviewProvider {
           static var previews: some View {
               LoginView()
                  
                   
           }
           
           struct PrimaryButton: View {
               var title: String
               var body: some View {
                   Text(title)
                       .font(.title3)
                       .fontWeight(.bold)
                       .foregroundColor( .white)
                       .frame(height: 44)
                       .padding(.horizontal, 88)
                       .background(Color("DarkPink"))
                       .cornerRadius(50)
               }
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
               .background(Color("white"))
               .cornerRadius(50.0)
               .shadow(color: Color("black").opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
           }
       }}
