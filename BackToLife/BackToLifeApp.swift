//
//  BackToLifeApp.swift
//  BackToLife
//
//  Created by Mac mini 8 on 5/4/2023.
//

import SwiftUI
import UIKit


@main
struct BackToLifeApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var userData = UserData()
    @StateObject private var report = Report()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userData)
                .environmentObject(report)
               
             
                
                       
                    }
                }
    
        }
