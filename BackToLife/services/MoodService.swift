//
//  moodService.swift
//  BackToLife
//
//  Created by Mac mini 8 on 2/5/2023.
//

import Foundation
import UIKit
import SwiftUI


//ADD MOOD
fileprivate struct MoodResponse: Codable {
    var newReport: NewReport?
    var message: String?
    var statusCode: Int?
    var verifReport : NewReport?
    var _id: String?
 

    init(newReport: NewReport?, message: String?, statusCode: Int?) {
        self.newReport = newReport
        self.message = message
        self.statusCode = statusCode
  
    }
}

struct NewReport: Codable {
    var date: String
    var mood: String
    var _id: String
}

fileprivate struct MoodBodyParams: Codable {
    var mood: String
    var date: String
    var user: String
    var depressedMood : Int
    var elevatedMood : Int
    var irritabilityMood : Int
 

    
    init(mood: String, date: String, user: String,depressedMood: Int , elevatedMood: Int, irritabilityMood: Int ) {
        self.mood = mood
        self.date = date
        self.user = user
        self.depressedMood = depressedMood
        self.elevatedMood = elevatedMood
        self.irritabilityMood = irritabilityMood
     
    }
}

//EDIT MOOD
fileprivate struct EditedMoodResponse: Codable {
    var editedMood: EditedMood?
    var message: String?
    var statusCode: Int?
 

    init(editedMood: EditedMood?, message: String?, statusCode: Int?) {
        self.editedMood = editedMood
        self.message = message
        self.statusCode = statusCode
  
    }
}
struct EditedMood: Codable {
    var date: String
    var mood: String
    var _id: String
    var depressedMood: Int
    var elevatedMood: Int
    var irritabilityMood: Int
}

fileprivate struct EditedMoodBodyParams: Codable {
    var depressedMood : Int
    var elevatedMood : Int
    var irritabilityMood : Int
 

    
    init(depressedMood: Int , elevatedMood: Int, irritabilityMood: Int ) {
  
        self.depressedMood = depressedMood
        self.elevatedMood = elevatedMood
        self.irritabilityMood = irritabilityMood
     
    }
}



class MoodService {
    
    var validate = false
    var navigateToReport = false
    var id: String = ""
    var userId =  UserDefaults.standard.string(forKey: "userId")
    
    
    
    //ADD MOOD
    public func _addmood(_ mood: String, _ date: String, _ user: String, _ depressedMood: Int,_ elevatedMood: Int,  _ irritabilityMood: Int) async throws -> NewReport? {
        
        let apiEndpoint = URL(string: "http://localhost:7001/report/addMood")!
        
        var request = URLRequest(url: apiEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let bodyParams = MoodBodyParams(mood: mood , date: date, user: user, depressedMood: depressedMood, elevatedMood: elevatedMood, irritabilityMood: irritabilityMood)
        
        let bodyData = try JSONEncoder().encode(bodyParams)
        
        request.httpBody = bodyData
        
        
        let session = URLSession.shared
        
        let (responseData, _) = try await session.data(for: request)
        
        
        
        
        
        let mood = try JSONDecoder().decode(MoodResponse.self, from: responseData)
        if let reportId = mood._id {
            UserDefaults.standard.set(reportId, forKey: "reportId")
            id = reportId
        }
        
        
        
        UserDefaults.standard.set(id, forKey: "reportId")
        
        print("report id ", id)
        
        
        //print("Response Mood" , mood)
        
        if mood.statusCode == 200 {
            // Display an alert to the user informing them that the mood was added successfully
            DispatchQueue.main.async {
                self.showAlert(title: "Info", message: "Mood added successfully!"){
                    let mySwiftUIView = AddReport(report: Report())
                    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: mySwiftUIView)
                }
            }
        }
        
        if let message = mood.message, message == "Report already exists !" {
            DispatchQueue.main.async {
                self.showAlert(title: "Warning", message: "You already entered your mood for today.")
            }
            
        }
        
        return mood.newReport
        
        
    }
    
    
    
    
    
    //EDIT MOOD
    public func _editmood(_ depressedMood: Int, _ elevatedMood: Int,  _ irritabilityMood: Int) async throws -> EditedMood? {
        guard let reportId = UserDefaults.standard.string(forKey: "reportId") else {
            throw NSError(domain: "Report ID not found", code: 0, userInfo: nil)
        }
        
        
        let apiEndpoint = URL(string: "http://localhost:7001/report/editMood/\(String(describing: reportId))")
        
        
        
        var request = URLRequest(url: apiEndpoint!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let bodyParams = EditedMoodBodyParams(depressedMood: depressedMood, elevatedMood: elevatedMood, irritabilityMood: irritabilityMood)
        
        let bodyData = try JSONEncoder().encode(bodyParams)
        
        request.httpBody = bodyData
        
        
        let session = URLSession.shared
        
        let (responseData, _) = try await session.data(for: request)
        
        let editedmood = try JSONDecoder().decode(EditedMoodResponse.self, from: responseData)
        
        
        
        print("Response Edited Mood" , editedmood)
        
        if editedmood.statusCode == 200 {
            DispatchQueue.main.async {
                self.showAlert(title: "Success", message: "You added your daily repoty with success"){
                    let mySwiftUIView = patientHome()
                    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: mySwiftUIView)
                }
            }
            
        }
        
        return editedmood.editedMood
        
        
    }
        
       
        

    

    
    
    
    
    
    
    
 

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
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
}
