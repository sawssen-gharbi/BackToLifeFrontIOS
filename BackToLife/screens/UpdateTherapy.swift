//
//  UpdateTherapy.swift
//  BackToLife
//
//  Created by Mac mini 8 on 30/4/2023.
//

import SwiftUI

struct UpdateTherapy: View {
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
    @State private var showMap: Bool = false
    @State private var capacityText: String = ""

    let therapy_id = UserDefaults.standard.string(forKey: "lastAddedTherapyID")

    @State var isAdded = false
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    @Environment(\.presentationMode) var presentationMode
    var therapySelected: Therapy
    var body: some View {
        NavigationView{
            ScrollView {
                ZStack {
                    
                    VStack {
                        Text("Update a Group Therapy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                      
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

                        
                        TextField("\(therapySelected.titre)", text: $titre)
                            .padding()
                            .frame(width: 310, height: 50)
                            .background(Color("black").opacity(0.05))
                            .cornerRadius(12)
                            .disableAutocorrection(true)
                        TextField("\(therapySelected.description)", text: $description)
                            .padding()
                            .frame(width: 310, height: 50)
                            .background(Color("black").opacity(0.05))
                            .cornerRadius(12)
                            .disableAutocorrection(true)
                        TextField("\(therapySelected.address)", text: $address)
                            .padding()
                            .frame(width: 310, height: 50)
                            .background(Color("black").opacity(0.05))
                            .cornerRadius(12)
                            .disableAutocorrection(true)
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
                            
                            TextField("\(therapySelected.capacity)", text: $capacityText, onEditingChanged: { isEditing in
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
//
                        updateTherapy(titre: titre, address: address,description: description, date: date, capacity: capacity, image: selectedImage!) { error in
                            self.isAdded=error
                        
                    }
                        }
                }) {
                    Text("Update Therapy")
                    
                    
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("white"))
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
                
            }}.navigationBarBackButtonHidden(true)
    }
    func updateTherapy(titre: String, address: String,description: String, date: Date, capacity: Int, image: UIImage, completion: @escaping (Bool) -> Void) {
           let therapy_id = UserDefaults.standard.string(forKey: "lastAddedTherapyID")
        

        // Convert the selected image to a Data object
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to Data"])
            completion(false)
            return
        }

        // Create a boundary string for the multipart form-data request
        let boundary = UUID().uuidString

        // Create the request object and set its method and headers
        var request = URLRequest(url: URL(string: "http://localhost:7001/therapy/\(therapySelected._id)")!)
        request.httpMethod = "PATCH"
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
                completion(true)
                return
            }
            
            // Handle the response here
            guard let data = data else {
                  let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned from server"])
                  completion(false)
                  return
              }
            do {
                
                
                completion(true)
            } catch {
                completion(false)
            }

              
           
          }

          task.resume()
         





    }
}

//func updateTherapy(therapy: Therapy, completionHandler: @escaping (Result<Therapy, Error>) -> Void) {
//    let therapy_id = UserDefaults.standard.string(forKey: "lastAddedTherapyID")
//
//    guard let url = URL(string: "http://localhost:7001/therapy/\(") else {
//        completionHandler(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
//        return
//    }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "PATCH"
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//    do {
//        let jsonData = try JSONEncoder().encode(therapy)
//        request.httpBody = jsonData
//    } catch {
//        completionHandler(.failure(error))
//        return
//    }
//
//    let session = URLSession.shared
//    let task = session.dataTask(with: request) { (data, response, error) in
//        guard let httpResponse = response as? HTTPURLResponse,
//              (200...299).contains(httpResponse.statusCode),
//              let data = data else {
//            completionHandler(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
//            return
//        }
//
//        do {
//            let decodedData = try JSONDecoder().decode(Therapy.self, from: data)
//            completionHandler(.success(decodedData))
//        } catch {
//            completionHandler(.failure(error))
//        }
//    }
//    task.resume()
//}

