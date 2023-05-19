//
//  TherapyDetailView.swift
//  BackToLife
//
//  Created by Mac mini 8 on 26/4/2023.
//
import SwiftUI
import UserNotifications


struct DetailsScreen: View {
    @State private var remainingDuration: TimeInterval = 0
    @State private var timer: Timer?
    @State private var idUserConnected: String?
    @State private var roleUserConnected: String?
    @State private var hasTimerStopped = false
    @State private var hasReserved = false
    @State private var isReserved = false
    @State private var isLoading = false
    
    let therapy_id = UserDefaults.standard.string(forKey: "lastAddedTherapyID")
    let userConnected_id = UserDefaults.standard.string(forKey: "userId")
    
    var therapy: Therapy
    
    let notificationCenter = UNUserNotificationCenter.current()
       
       var body: some View {
           ScrollView {
               VStack(spacing: 40) { // Add spacing between elements
                   Text("Reservation")
                       .font(.largeTitle)
                       .fontWeight(.bold)
                   Spacer()

                   URLImage(urlString: therapy.image)
                       .frame(maxWidth: .infinity)
                               Spacer()
                   
                   Text(therapy.titre)
                       .font(.system(size: 30))
                       .foregroundColor(Color("DarkPink"))
                       .multilineTextAlignment(.center)
                   
                   Text(therapy.date)
                       .font(.system(size: 20)) // Decrease font size
                       .foregroundColor(Color("black"))
                       .padding(.bottom, 5) // Add bottom padding
                   
                   Text("Address: \(therapy.address)")
                       .font(.caption)
                       .foregroundColor(.gray)
                   
                   Text(therapy.description)
                       .font(.caption)
                       .foregroundColor(.gray)
                   
                   Button(action: {
                       // Call the reserve function
                       isLoading = true
                       Task {
                           isReserved = await reserve(patientID: userConnected_id!,  therapyID: therapy._id)
                           isLoading = false
                           
                           if isReserved {
                               Text("Therapy reserved successfully!")
                               // Request notification authorization
                               UNUserNotificationCenter.current().getNotificationSettings { settings in
                                      if settings.authorizationStatus == .authorized {
                                          let content = UNMutableNotificationContent()
                                          content.title = "Therapy reserved successfully!"
                                          content.sound = UNNotificationSound.default
                                          
                                          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                          let request = UNNotificationRequest(identifier: "ReservationSuccess", content: content, trigger: trigger)
                                          
                                          UNUserNotificationCenter.current().add(request)
                                      }
                                  }
                           }
                       }
                   }, label: {
                       Text("Reserve Now")
                           .font(.title3)
                           .fontWeight(.bold)
                           .foregroundColor( Color("white"))
                           .frame(height: 44)
                           .padding(.horizontal, 88)
                           .background(Color("DarkPink"))
                           .cornerRadius(50)
                   })
                   .disabled(isLoading)
                   .opacity(isLoading ? 0.5 : 1.0)
                   .padding(.top, 10) // Add top padding
                   
                   if isLoading {
                       ProgressView()
                   } else if isReserved {
                       Text("Therapy reserved successfully!")
                   }
              // Add bottom spacing
               }
               .padding() // Add padding to VStack
               .navigationBarTitle("", displayMode: .inline)
               // Remove navigation title
           }
       }
   }
    

struct URLImagePa: View {
  
    let urlString: String
    @State var data: Data?
    var body: some View {
        if let data = data , let uiimage = UIImage(data: data){
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .frame(width : 200 , height: 70)

                .shadow(color: .black.opacity(0.1),radius: 5, x: 5 , y: 5)
                .shadow(color: .black.opacity(0.1),radius: 5, x: -5 , y: -5)
        }
        else {
            Image("")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .frame(width : 200 , height: 70)

                .shadow(color: .black.opacity(0.1),radius: 5, x: 5 , y: 5)
                .shadow(color: .black.opacity(0.1),radius: 5, x: -5 , y: -5)
                .onAppear{
                    fetchData()
                }
                            }
        }
    
    private func fetchData() {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url){data,_,_ in
            self.data = data
            
        }
        task.resume()
    }
    
}
func createReservation(patientId: String, doctorId: String, therapyId: String,completion: @escaping (Result<Reservation, Error>) -> Void) {
    let url = URL(string: "http://localhost:7001/reservation/send")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let requestBody = [
        "patient_id": patientId,
        "doctor_id": doctorId,
        "therapy_id": therapyId,
       
    ]

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        request.httpBody = jsonData
    } catch {
        completion(.failure(error))
        return
    }

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            completion(.failure(error ?? APIError.unknown))
            return
        }

        do {
            let decoder = JSONDecoder()
            let reservation = try decoder.decode(Reservation.self, from: data)
            completion(.success(reservation))
        } catch let error {
            print("Error decoding reservation: \(error)")
            completion(.failure(APIError.decodingFailed))
        }

    }

    task.resume()
}
enum APIError: Error {
    case unknown
    case invalidEndpoint
    case invalidResponse
    case decodingFailed
    // other cases
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "An unknown error occurred."
        case .invalidEndpoint:
            return "The API endpoint is invalid."
        case .invalidResponse:
            return "The API response is invalid."
        case .decodingFailed:
            return "The API response is mochklaaaa."
        // other cases
        }
    }
}
func reserve(patientID: String,  therapyID: String) async -> Bool {
    // URL
    guard let url = URL(string: "http://localhost:7001/reservation/send") else { return false }
    
    // Headers
    var headers = [String: String]()
    headers["Content-Type"] = "application/json"
    
    // Body
    let body = ["patient_id": patientID,  "therapy_id": therapyID]
    
    // Request
    do {
        var request = try JSONSerialization.data(withJSONObject: body, options: [])
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = request
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        if let message = response?["message"] as? String {
            // Show success dialog
            let alert = await  UIAlertController(title: "Information", message: "therapy reserved successfully!", preferredStyle: .alert)
            await alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            await UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            
            // Send notification
           
            return true
        } else if let error = response?["error"] as? String {
            // Show error dialog
            let alert = await UIAlertController(title: "Information", message: error, preferredStyle: .alert)
            await alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            await UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            return false
        }
    } catch {
        // Show error dialog
        let alert = await UIAlertController(title: "Information", message: "Verify: Server error! Try again later", preferredStyle: .alert)
        await alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        await UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        return false
    }
    
    return true
    let content = UNMutableNotificationContent()
    content.title = "Therapy reserved successfully!"
    content.sound = UNNotificationSound.default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: "reservationNotification", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    
}
