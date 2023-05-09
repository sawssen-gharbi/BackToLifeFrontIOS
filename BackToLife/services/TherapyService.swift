//
//  TherapyService.swift
//  BackToLife
//
//  Created by Mac mini 8 on 14/4/2023.
//

//import Foundation
//struct PostResponse: Codable {
//    let message: String
//    let statusCode: Int
//}
//fileprivate struct PostBodyParams: Codable {
//    let title: String
//    let address: String
//    let capacity: Int
//    let date: String
//    let image: String
//   // let role : String
//
//    init(title: String,address: String,capacity: Int,date: String,image: String) {
//        self.title = title
//        self.address = address
//        self.capacity = capacity
//        self.date = date
//        self.image = image
//       // self.role = role
//    }
//}
//class TherapyService {
//    //    public func AddTherapy(_ title: String, _ address: String, _ capacity: Int, _ date: String, _ image: String) async throws -> Void {
//    //        let apiEndpoint = URL(string: "http://localhost:7001/therapy")!
    //
    //        var request = URLRequest(url: apiEndpoint)
    //        request.httpMethod = "POST"
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        if let imageURL = URL(string: image),
    //           let imageData = try? Data(contentsOf: imageURL) {
    //            let base64Image = imageData.base64EncodedString(options: .lineLength64Characters)
    //
    //            let bodyParams = PostBodyParams(title: title, address: address, capacity: capacity, date: date, image: base64Image)
    //            let bodyData = try JSONEncoder().encode(bodyParams)
    //            request.httpBody = bodyData
    //
    //            let session = URLSession.shared
    //            let (responseData, response) = try await session.data(for: request)
    //
    //            print("Response body: \(String(data: responseData, encoding: .utf8) ?? "")")
    //
    //            if let httpResponse = response as? HTTPURLResponse {
    //                let statusCode = httpResponse.statusCode
    //                print("Response status code: \(statusCode)")
    //
    //                if let dataString = String(data: responseData, encoding: .utf8) {
    //                    print("Response data: \(dataString)")
    //                    guard let httpResponse = response as? HTTPURLResponse,
    //                          httpResponse.statusCode == 201 /* OK */ else {
    //                        throw AuthenticationError(status_code: statusCode, serverMessage:  "Could not create account")
    //                    }
    //                }
    //                do {
    //                    let decoder = JSONDecoder()
    //                    decoder.keyDecodingStrategy = .convertFromSnakeCase
    //
    //                    let response = try decoder.decode(RegisterResponse.self, from: responseData)
    //                    print("Decoded response: \(response)")
    //
    //                    if response.statusCode == 201 {
    //                        print("Account created successfully")
    //                    } else {
    //                        throw AuthenticationError(status_code: response.statusCode!, serverMessage: "Could not create account")
    //                    }
    //                } catch let error {
    //                    print("Error decoding response: \(error)")
    //                    throw error
    //                }
    //            }
    //        } else {
    //            print("Could not retrieve image data from provided URL.")
    //        }
    //    }
    //
    //
    //    public struct AuthenticationError: LocalizedError {
    //       public let statusCode: Int?
    //       public var errorDescription: String?
    //
    //       init(status_code: Int, serverMessage: String) {
    //           self.statusCode = status_code
    //           self.errorDescription = serverMessage
    //       }
    //   }
    //
    //}

