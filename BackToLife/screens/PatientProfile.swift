//
//  PatientProfile.swift
//  BackToLife
//
//  Created by Mac mini 8 on 2/5/2023.
//

import Foundation
import SwiftUI

struct profileView1: View {
    //let _id: String
    //let image: String

    
    //personal
    let _id = UserDefaults.standard.string(forKey: "userId")
    @State var email: String = ""
    @State var password: String = ""
    @State var firstName: String = ""
    @State var nickName: String = ""
    @State var phone: String = ""
    @State var address: String = ""
  
    @State private var navigateToLogin = false
    @State private var url_image=UserDefaults.standard.string(forKey: "imago") ?? "nil"

    
    //image
    @State var shouldShowImagePicker = false
    @State var image:UIImage?
    
    @StateObject var viewModel = ProfileViewModel()
    
    
    var body: some View {
        NavigationView{
            Form{
                
                //Image
                HStack
                              {
                                  
                                  
                                  
                                  HStack{
                                      
                                      if let image = self.image {
                                          Image(uiImage: image)
                                              .resizable()
                                              .scaledToFill()
                                              .frame(width: 143,height: 143)
                                              .cornerRadius(80)
                                      }else{
                                          
                                          AsyncImage(url: URL(string: self.url_image)){
                                              image in
                                              image.resizable()
                                                  .scaledToFill()
                                                  .frame(width: 143,height: 143)
                                                  .cornerRadius(80)
                                          } placeholder: {
                                              ProgressView()
                                          }
                                          
                                              
                                      }
                                      
                                  }
                                  .overlay(RoundedRectangle(cornerRadius: 80)
                                      .stroke(Color("Color1"), lineWidth : 3)
                                  )
                                  .onTapGesture {
                                      shouldShowImagePicker.toggle()
                                  }
                                  .navigationViewStyle(StackNavigationViewStyle())
                                  .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
                                      ImagePicker(image: $image)
                                          .ignoresSafeArea()
                                  }
                                  .frame(width: 145,height: 145,alignment: .center)
                                  
                              }.padding(.horizontal, 80)
                                  
                              
                              
                
                
                
                
                //personal information
                Section(header: Text("Personal Information")) {
                    HStack{
                        TextField("FistName", text: $firstName).onAppear{
                           self.firstName = UserDefaults.standard.string(forKey: "fist") ?? "nil"
                       }
                        Spacer()

                        Image(systemName: "person.2.wave.2")
                    }
                    HStack{
                        TextField("NickName", text: $nickName).onAppear{
                            self.nickName = UserDefaults.standard.string(forKey: "nick") ?? "nil"
                        }
                        Spacer()

                        Image(systemName: "person.badge.clock")
                    }
                    HStack{
                        TextField("Email", text: $email)
                            .disabled(true)
                            .onAppear{
                                self.email = UserDefaults.standard.string(forKey: "email") ?? "nil"
                            }
                        Spacer()

                        Image(systemName: "mail")
                    }
                   
                    
                    //
                    //                    DatePicker("Date naissance" , selection: Date().timeIntervalSinceNow, displayedComponents: .date).onAppear{
                    //                        let dateFormatter = DateFormatter()
                    //                          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                    //                          dateFormatter.dateFormat = "yyyy-MM-dd"
                    //
                    //
                    //
                    //                          let dateP = dateFormatter.date(from:Date().timeIntervalSinceNow)
                    //
                    //                        let calendar = Calendar.current
                    //                        let components = calendar.dateComponents([.year, .month, .day, .hour], from: dateP ?? Date())
                    //
                    //                        let finalDate = calendar.date(from:components)
                    //
                    //
                    //                        self.birthdate = finalDate ?? Date()
                    //                    }
                    
                }
                
                //school information
                Section(header: Text("More Information")) {
                    HStack{
                        TextField("Address", text: $address).onAppear{
                            self.address = UserDefaults.standard.string(forKey: "address") ?? "nil"
                        }
                        Spacer()

                        Image(systemName: "map.circle.fill")
                    }
                    HStack{
                        TextField("Phone", text: $phone).onAppear{
                            self.phone = UserDefaults.standard.string(forKey: "phone") ?? "nil"
                        }
                        Spacer()

                        Image(systemName: "phone.and.waveform")

                    }
                   
                }
                
                
                //actions
                Section(header: Text("Actions")) {
                    HStack {
                        Text("Log out")
                        Spacer(minLength: 15)
                        Button(action: {
                            // Clear UserDefaults
                            UserDefaults.standard.removeObject(forKey: "userRole")
                            
                            // Navigate to the login view
                            navigateToLogin = true
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                    }
                    .navigationTitle("Actions")
                    .sheet(isPresented: $navigateToLogin) {
                        LoginView()
                    }
                
            
                    Button(action: {
                        // Handle share action
                        let shareURL = URL(string: "https://github.com/ranianadine28/BackToLifeAndroid")!
                        let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
                        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                    }) {
                        HStack {
                            Text("Share")
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }

                
            }
            .accentColor(.red)
            .navigationTitle("Account")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button("Update", action: updateUser)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func updateUser(){
        viewModel.updateUser( firstName: firstName, email: email, nickName: nickName, address: address, phone: phone,image: image!){
            (resp) in
            //update shared preferences and binding value
            if(resp == true){
                let pref = UserDefaults.standard
                pref.set(self._id, forKey: "id")
                pref.set(self.email, forKey: "email")
                pref.set(self.firstName, forKey: "first")
                pref.set(self.nickName, forKey: "nick")
                pref.set(self.address, forKey: "address")
                pref.set(self.phone, forKey: "phone")

           
            }else{
                //show alert
                print("resp == false")
            }
        }
    }
    
    struct ImagePicker : UIViewControllerRepresentable{
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
        
        @Binding var image: UIImage?
        
        let ctr = UIImagePickerController()
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(parent : self)
        }
        
        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
        {
            
            let parent : ImagePicker
            
            init(parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                parent.image = info[.originalImage] as? UIImage
                picker.dismiss(animated: true)
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
            
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            ctr.delegate = context.coordinator
            return ctr
        }
    }
}



struct profileView_Previews: PreviewProvider {
    static var previews: some View {
        profileView1()
    }
}
