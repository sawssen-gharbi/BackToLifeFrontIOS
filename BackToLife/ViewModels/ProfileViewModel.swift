//
//  ProfileViewModel.swift
//  BackToLife
//
//  Created by Mac mini 8 on 2/5/2023.
//
import Foundation
import UIKit
final class ProfileViewModel: ObservableObject{
    

    
    func updateUser( firstName: String, email: String, nickName: String, address: String, phone: String, image:UIImage, completion: @escaping (Bool) -> ()){
        
        var userConnected_id = UserDefaults.standard.string(forKey: "userId") ?? "hamza"


     // Convert the selected image to a Data object
     guard let imageData = image.jpegData(compressionQuality: 0.8) else {
         let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to Data"])
         completion(false)
         return
     }

     // Create a boundary string for the multipart form-data request
     let boundary = UUID().uuidString
print("http://localhost:7001/user/updateUser/\(userConnected_id)")
     // Create the request object and set its method and headers
        var request = URLRequest(url: URL(string: "http://localhost:7001/user/updateUser/\(userConnected_id)")!)
     request.httpMethod = "PATCH"
     request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

     // Create the request body as a Data object
     var body = Data()
     body.append("--\(boundary)\r\n".data(using: .utf8)!)
     body.append("Content-Disposition: form-data; name=\"firstName\"\r\n\r\n".data(using: .utf8)!)
     body.append("\(firstName)\r\n".data(using: .utf8)!)
     body.append("--\(boundary)\r\n".data(using: .utf8)!)
     body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n".data(using: .utf8)!)
     body.append("\(email)\r\n".data(using: .utf8)!)
     body.append("--\(boundary)\r\n".data(using: .utf8)!)
     body.append("Content-Disposition: form-data; name=\"nickName\"\r\n\r\n".data(using: .utf8)!)
     body.append("\(nickName)\r\n".data(using: .utf8)!)
     body.append("--\(boundary)\r\n".data(using: .utf8)!)
     body.append("Content-Disposition: form-data; name=\"address\"\r\n\r\n".data(using: .utf8)!)
     body.append("\(address)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"phone\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(phone)\r\n".data(using: .utf8)!)
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
