//
//  AuthenticationService.swift
//  AuthApp
//
//  Created by Neal Archival on 7/16/22.
//

import Foundation


fileprivate struct RegisterResponse: Codable {
    var token: String?
    var statusCode: Int?
    var message: String?
    var role: String?

    

}

fileprivate struct RegisterBodyParams: Codable {
    var email: String
    var password: String
    var firstName: String
    var nickName: String
    var phone: String
    var address: String
    var role: String
    init(email: String,password: String,firstName: String,nickName: String,phone: String, address: String, role: String) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.nickName = nickName
        self.phone = phone
        self.address = address
        self.role = role

    }
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
    
    
    public func _Register(_ email: String, _ password: String,_ fullName: String,_ nickName: String,_ phone: String,_ address: String,_ role: String, completion: (Bool) ->  () ) async throws -> String {
        let apiEndpoint = URL(string: "http://localhost:7001/user/signup")!
        
        var request = URLRequest(url: apiEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let bodyParams = RegisterBodyParams(email: email , password: password, firstName: fullName, nickName: nickName, phone: phone, address: address, role: role)
        
        let bodyData = try JSONEncoder().encode(bodyParams)
        
        request.httpBody = bodyData
        
        
        let session = URLSession.shared
        
        let (responseData, _) = try await session.data(for: request)

      
        
            let decoded = try JSONDecoder().decode(RegisterResponse.self, from: responseData)
    

        var r = decoded.role
        UserDefaults.standard.set(r, forKey: "rr")
   
    
      print("decoded", decoded)
        if decoded.statusCode != 201 {
            completion(false);
                   if decoded.message != nil {
                       throw AuthenticationError(status_code: decoded.statusCode! , serverMessage: decoded.message!)
                       
                   }
                   throw AuthenticationError(status_code: decoded.statusCode!, serverMessage: "Could not login ")
               }
        
        completion(true);
               
               return decoded.token!
    
        
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

