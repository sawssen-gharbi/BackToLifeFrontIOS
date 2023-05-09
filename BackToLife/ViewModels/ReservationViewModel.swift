//
//  RegisterViewModel.swift
//  BackToLife
//
//  Created by Mac mini 8 on 30/4/2023.
//

import SwiftUI
import Foundation
class ViewModel1: ObservableObject {
    
    
    
    @Published var reservations: [Reservation] = []
    @Published var showAlert = false

    func fetchReservations(doctorID: String) {
        let url = URL(string: "http://localhost:7001/reservation?doctor_id=\(doctorID)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error: invalid HTTP response")
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let reservations = try decoder.decode([Reservation].self, from: data)
                    DispatchQueue.main.async {
                        self.reservations = reservations
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    func Accept(reservationId : String){
           let url = URL(string: "http://localhost:7001/reservation/accept")!
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           let requestBody: [String: Any] = [
               "_id": reservationId
           ]
           request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               guard let data = data else {
                   print(error)
                   return
               }
               do {
                   let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                   print(result)
                   // Set showAlert to true after the server responds with success
                   DispatchQueue.main.async {
                       self.showAlert = true
                   }
               } catch {
                   print(error)
               }
           }
           task.resume()
       }
   }
