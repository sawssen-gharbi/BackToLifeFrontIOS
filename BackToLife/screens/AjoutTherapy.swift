//
//  ajout_therapy.swift
//  BackToLife
//
//  Created by Mac mini 8 on 24/3/2023.
//

import SwiftUI
import MapKit
struct ajout_therapy: View {
   
    
    
    let image  = UIImage (named: "register")
    @State private var titre: String = ""
    // by default it's empty
    @State private var address: String = "" // by default it's empty
    @State private var description: String = "" // by default it's empty
    @State private var isMapSheetPresented = false
    @State private var date = Date()// by default it's empty
    @State private var capacity: Int = 0 // by default it's empty
    @State private var isOn = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var location: CLLocationCoordinate2D?
    @State private var showMap: Bool = false
    @State private var capacityText: String = ""
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State var isAdded = false
    private var formattedDate: String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          return dateFormatter.string(from: date)
      }
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            ScrollView {
                ZStack {
                    
                    VStack {
                        
                        Text("Add a Group Therapy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                        HStack{
                            if let image = self.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 143,height: 143)
                                    .cornerRadius(80)
                            }else{
                                
                                Image("register")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    
                            }
                            
                        }
                        .overlay(RoundedRectangle(cornerRadius: 80)
                            .stroke(Color("DarkPink"), lineWidth : 3)
                        )
                        .onTapGesture {
                            showingImagePicker.toggle()
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                        .fullScreenCover(isPresented: $showingImagePicker, onDismiss: nil){
                            ImagePicker(image: $selectedImage)
                                .ignoresSafeArea()
                        }
                        .frame(width: 145,height: 145,alignment: .center)

                        
                        CaptionedTextField(caption: "The title", text: $titre, placeholder: "Enter The title")
                            .padding([.top], 20)
                           
                        CaptionedTextField(caption: "The description ", text: $description, placeholder: "Enter your description")
                            .padding([.top], 20)
                         
                        CaptionedTextField(caption: "The address ", text: $address, placeholder: "Enter your address")
                            .padding([.top], 20)
                           
                        Spacer()
                        DatePicker("Select a date", selection: $date, displayedComponents: .date)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(width: 310, height: 50)

                            .background(Color("black").opacity(0.05))
                            .cornerRadius(12)
                            .foregroundColor(Color("black").opacity(0.28))
                        Text("Selected Date: \(formattedDate)")
                                      .padding()
                                      .foregroundColor(Color("DarkPink"))
                     
                        HStack {
                                    Stepper("Capacity: \(capacity)", value: $capacity, in: 0...20)
                                        .padding()
                                        .frame(width: 250)
                                        .foregroundColor(Color.gray)
                                    
                                    TextField("Capacity", text: $capacityText, onEditingChanged: { isEditing in
                                        if !isEditing, let value = Int(capacityText) {
                                            capacity = value
                                        }
                                    })
                                    .padding()
                                    .frame(width: 100)
                                    .foregroundColor(Color("DarkPink"))
                                }

                        
                }}
                Button(action: {
                    Task {
                        addTherapy(titre: titre, address: address,description: description, date: date, capacity: capacity, image: selectedImage!) { error in
                            if let error = error {
                                // Handle the error here
                                print("Error adding therapy: \(error.localizedDescription)")
                            } else {
                                // Success
                                print("Therapy added successfully!")
                                isAdded = true 
                            }
                            
                        }}
                }) {
                    Text("Add Therapy")
                

                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor( .white)
                                            .frame(height: 44)
                                            .padding(.horizontal, 30)
                                            .background(Color("DarkPink"))
                                            .cornerRadius(50)
                                    }
                                    .background(
                                        NavigationLink(
                                            destination: list_therapy(),
                                            isActive: $isAdded,
                                            label: { EmptyView() }
                                        ))
                
            }
            
        }.navigationBarBackButtonHidden(true)
    }
    struct ajout_therapy_Previews: PreviewProvider {
        static var previews: some View {
            ajout_therapy().preferredColorScheme(.dark)
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

func addTherapy(titre: String, address: String,description: String, date: Date, capacity: Int, image: UIImage, completion: @escaping (Error?) -> Void) {
    // Convert the selected image to a Data object
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to Data"])
        completion(error)
        return
    }

    // Create a boundary string for the multipart form-data request
    let boundary = UUID().uuidString

    // Create the request object and set its method and headers
    var request = URLRequest(url: URL(string: "http://localhost:7001/therapy/add")!)
    request.httpMethod = "POST"
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    // Create the request body as a Data object
    var body = Data()
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"titre\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(titre)\r\n".data(using: .utf8)!)
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(description)\r\n".data(using: .utf8)!)
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"address\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(address)\r\n".data(using: .utf8)!)
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"date\"\r\n\r\n".data(using: .utf8)!)
    let formattedDate = dateFormatter.string(from: date)
    body.append("\(formattedDate)\r\n".data(using: .utf8)!)
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"capacity\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(capacity)\r\n".data(using: .utf8)!)
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

    // Set the request body and content length
    request.httpBody = body
    request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")

    // Create a URLSessionDataTask to perform the request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(error)
            return
        }
        
        // Handle the response here
        guard let data = data else {
              let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned from server"])
              completion(error)
              return
          }
          
          do {
              let therapy = try JSONDecoder().decode(TherapyResponse.self, from: data)
              let id = therapy.id
              print("idddddddd",id)
              // Store the therapy ID in UserDefaults
              UserDefaults.standard.set(id, forKey: "lastAddedTherapyID")
              
              completion(nil)
          } catch {
              completion(error)
          }
      }

      task.resume()
     





}
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

fileprivate struct TherapyResponse: Codable {
    var therapy: Therapy
    var id: String

}
