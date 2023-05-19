//
//  AuthenticationService.swift
//  AuthApp
//
//  Created by Neal Archival on 7/16/22.
//

import Foundation
import UIKit


fileprivate struct RegisterResponse: Codable {
    var token: String?
    var statusCode: Int?
    var message: String?
    var role: String?

    

}



fileprivate struct LoginResponse: Codable {
    var token: String?
    var email: String?
    var statusCode: Int?
    var role: String?
    var message: String?
    var _id: String?
    var firstName: String?
    var nickName: String?
    var phone: String?
    var address: String?
    var image: String?

}

fileprivate struct LoginBodyParams: Codable {
    var email: String
    var password: String
    
    init(email: String,password: String) {
        self.email = email
        self.password = password
    }
}
class AuthenticationService {
    
    
    public func _Register(_ email: String, _ password: String,_ firstName: String,_ nickName: String,_ phone: String,_ address: String,_ role: String,_ image:UIImage,  completion: @escaping (String) -> () )  {
        // Convert the selected image to a Data object
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to Data"])
            completion("false")
            return
        }

        // Create a boundary string for the multipart form-data request
        let boundary = UUID().uuidString

        // Create the request object and set its method and headers
        var request = URLRequest(url: URL(string: "http://localhost:7001/user/signup")!)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Create the request body as a Data object
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(email)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"password\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(password)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"firstName\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(firstName)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"nickName\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(nickName)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"phone\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(phone)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"address\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(address)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"role\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(role)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Set the request body and content length
        request.httpBody = body
        request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           
            guard let data = data else {
                  let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned from server"])
                completion("false")
                  return
              }
              
              do {
                  let decoded = try JSONDecoder().decode(RegisterResponse.self, from: data)
                  if decoded.statusCode != 201 {
                               completion("false");
                               if decoded.message != nil {
                                   throw AuthenticationError(status_code: decoded.statusCode! , serverMessage: decoded.message!)
                
                               }
                                throw AuthenticationError(status_code: decoded.statusCode!, serverMessage: "Could not login ")
                            }
                
                            completion(decoded.token!);
                
              
                  
          
              } catch {
                  completion("false")
              }
          }

          task.resume()
         
   
//

          }

        


        
         
    
        
    
    
   
    
    // Errors
    public struct AuthenticationError: LocalizedError {
        public let status_code: Int?
        public var errorDescription: String?
        
        init(status_code: Int, serverMessage: String) {
            self.status_code = status_code
            self.errorDescription = serverMessage
        }
    }
    public func _login(_ email: String, _ password: String , completion: (Bool) ->  ()) async throws -> String {
            let apiEndpoint = URL(string: "http://localhost:7001/user/login")!
            
            var request = URLRequest(url: apiEndpoint)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            
            let bodyParams = LoginBodyParams(email: email , password: password)
            
            let bodyData = try JSONEncoder().encode(bodyParams)
            
            request.httpBody = bodyData
            
            
            let session = URLSession.shared
            
            let (responseData, _) = try await session.data(for: request)

          
            
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: responseData)
                print("decoded", decoded)
        var userRole = decoded.role
        UserDefaults.standard.set(userRole, forKey: "userRole")
                //userdefault
                let userId = decoded._id
        let first = decoded.firstName
        let nick = decoded.nickName
        let phone = decoded.phone
        let address = decoded.address
        let image = decoded.image
        UserDefaults.standard.set(image, forKey: "imago")

       
        let email = decoded.email
                print("user id", userId)
                UserDefaults.standard.set(userId, forKey: "userId")
        UserDefaults.standard.set(email, forKey: "email")
  

        UserDefaults.standard.set(first, forKey: "fist")
        UserDefaults.standard.set(nick, forKey: "nick")
        UserDefaults.standard.set(phone, forKey: "phone")
        print("phoneeeeeeeee",phone)
        UserDefaults.standard.set(address, forKey: "address")


                
            if decoded.statusCode != 200 {
                completion(false);

                       if decoded.message != nil {
                           throw AuthenticationError(status_code: decoded.statusCode! , serverMessage: decoded.message!)
                           
                       }
                       throw AuthenticationError(status_code: decoded.statusCode!, serverMessage: "Could not login ")
                   }
            
        completion(true);

                   
                   return decoded.token!
        
            
        }
}

