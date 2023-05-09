//
//  TherapyViewModel.swift
//  BackToLife
//
//  Created by Mac mini 8 on 26/4/2023.
//

import SwiftUI
import Foundation 
class ViewModel: ObservableObject {
 


    @Published var therapies: [Therapy] = []
    @Published var showAlert = false

    
    func fetch() {
           guard let url = URL(string: "http://localhost:7001/therapy") else {
               return
           }
           let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
               guard let data = data, error == nil else {
                   print("Error: \(error?.localizedDescription ?? "unknown error")")
                   return
               }
               do {
                   let decoder = JSONDecoder()
                   decoder.keyDecodingStrategy = .convertFromSnakeCase // add this line
                   let therapiess = try decoder.decode([Therapy].self, from: data)
                   print([Therapy].self)
                   DispatchQueue.main.async {
                       self?.therapies = therapiess
                   }
               } catch {
                   print("Error decoding JSON: \(self?.therapies)")
               }
           }
           task.resume()
       }
    func deleteTherapy(id: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "http://localhost:7001/therapy/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

    let confirmationAlert = UIAlertController(
        title: "Confirmation",
        message: "Are you sure you want to delete this therapy?",
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
                self.therapies.removeAll(where: { $0._id == id })
            }
        }.resume()
    })
    
    confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    UIApplication.shared.windows.first?.rootViewController?.present(confirmationAlert, animated: true, completion: nil)
}

 

   }


