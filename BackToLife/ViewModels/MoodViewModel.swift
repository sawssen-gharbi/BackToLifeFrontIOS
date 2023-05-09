//
//  MoodViewModel.swift
//  BackToLife
//
//  Created by Mac mini 8 on 2/5/2023.
//


import Foundation
import UIKit
extension AddMood {
    @MainActor class ViewModel1: NSObject, ObservableObject {
      
        @Published var date: String = ""
        @Published var mood: String = ""
        @Published var depressedMood: Int = 0
        @Published var elevatedMood: Int = 0
        @Published var irritabilityMood: Int =  0
        
        //user id from userdefault
        let userId = UserDefaults.standard.string(forKey: "userId")
 
        @Published var authSuccessful: Bool = true
        @Published var errorMessage: String = ""
        @Published var isLoading: Bool = false
        
        
    
        @Published var isMoodSuccessed = false
        @Published var isMoodEditedSuccessed = false

        // add mood
        func attemptMood(report: Report) async {
            isLoading = true
            self.isMoodSuccessed = true
            defer {
                isLoading = false
            }
      
            do {
                let moodRes = try await MoodService()._addmood(mood, date, userId!, depressedMood, elevatedMood, irritabilityMood)
               
                var reportId = moodRes?._id
                UserDefaults.standard.set(reportId, forKey: "reportId")

            } catch let error {
                if type(of: error) == MoodService.self.AuthenticationError.self {
                    errorMessage = error.localizedDescription
                } else {
                    print("Application error: ", error)
                    errorMessage = "Connection error"
                }
                authSuccessful = false
            }
        }
        


        
    
    }
}

extension AddReport {
    @MainActor class ViewModel2: NSObject, ObservableObject {
      

        @Published var depressedMood: Int = 0
        @Published var elevatedMood: Int = 0
        @Published var irritabilityMood: Int =  0
        

        @Published var authSuccessful: Bool = true
        @Published var errorMessage: String = ""
        @Published var isLoading: Bool = false
        
        
    

        @Published var isMoodEditedSuccessed = false

      
        
        // edit mood
        func attemptEditMood(report: Report) async {
            isLoading = true
            self.isMoodEditedSuccessed = true
            defer {
                isLoading = false
            }
            do {
                let editMoodRes = try await MoodService()._editmood(depressedMood, elevatedMood, irritabilityMood)
                print(editMoodRes)
                
            } catch let error {
                if type(of: error) == MoodService.self.AuthenticationError.self {
                    errorMessage = error.localizedDescription
                } else {
                    print("Application error: ", error)
                    errorMessage = "Connection error"
                }
                authSuccessful = false
            }
        }
        
       
        
        
    
    }
}


extension FetchReport {
    @MainActor class ViewModel3: NSObject, ObservableObject {
     
        @Published var reportMoods : [MoodReport] = []
       

        struct MoodReport : Hashable , Codable{
            var _id: String
            var date: String
            var mood: String
            var user: String
            var depressedMood: Int
            var elevatedMood: Int
            var irritabilityMood: Int
        }

    
        //fetch
        
    func fetch() {
        
        guard let idUser = UserDefaults.standard.string(forKey: "userId") else {
            print("userId not found in UserDefaults")
            return
        }
            guard let url = URL(string: "http://localhost:7001/report/getReport/\(String(describing: idUser))") else {
            print("iddddddd",  idUser)
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, _,
            error in
            guard let date = data , error == nil else {
                return
            }
            
            
            //convert to JSON
            do {
                let reports = try JSONDecoder().decode([MoodReport].self, from: data!)
                DispatchQueue.main.async {
                    self.reportMoods = reports
                }
               
                
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
        
        func deleteReport(id: String) -> Void {
            let url = URL(string: "http://localhost:7001/report/deleteReport/\(id)")!
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"

            let confirmationAlert = UIAlertController(
                title: "Confirmation",
                message: "Are you sure you want to delete this report?",
                preferredStyle: .alert
            )
            
            confirmationAlert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.reportMoods.removeAll(where: { $0._id == id })
                    }
                }.resume()
            })
            
            confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            UIApplication.shared.windows.first?.rootViewController?.present(confirmationAlert, animated: true, completion: nil)
        }

         

       
        
        
    
    }
}
