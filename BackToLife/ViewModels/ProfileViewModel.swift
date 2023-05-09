//
//  ProfileViewModel.swift
//  BackToLife
//
//  Created by Mac mini 8 on 2/5/2023.
//
import Foundation
final class ProfileViewModel: ObservableObject{
    
   
    
    func updateUser(id: String , firstName: String, email: String, nickName: String, address: String, phone: String,  completion: @escaping (Bool) -> ()){
        
        print("update user view model \(id)")
        guard let url = URL(string: "http://localhost:7001/user/updateUser") else{
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            //postman;fonction
            "userId": id,
            "firstName": firstName,
            "nickName": nickName,
            "email": email,
            "address": address,
            "phone":  phone,
            
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response , error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode update profile : \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200){
                    do {
                        completion(true)
                    }
                    catch{
                        completion(false)
                        print(error)
                    }
                }else{
                    completion(false)
                    print(httpResponse.statusCode)
                }
            }
            
        }//end task
        task.resume()
    }
}
