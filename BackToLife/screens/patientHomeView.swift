//
//  patientHome.swift
//  BackToLife
//
//  Created by Mac mini 8 on 6/4/2023.
//

import SwiftUI

struct patientHome: View {
    @State private var isDrawerOpen = false
    
    var body: some View {
        ZStack {
            TabView {
                AddMood().navigationBarBackButtonHidden(true)
                    .tabItem { Label("Home", systemImage: "house") }
                FetchReport()
                    .tabItem { Label("My Reports", systemImage: "doc.text") }
                DrawerView()
                    .tabItem { Label("", systemImage: "plus.circle") }

                list_therapy_Patient().navigationBarBackButtonHidden(true)
                    .tabItem { Label("My therapies", systemImage: "list.dash") }
                profileView1().navigationBarBackButtonHidden(true)
                    .tabItem { Label("Profile", systemImage: "person") }
             
            }
          
        }
    }}

struct patientHome_Previews: PreviewProvider {
    static var previews: some View {
        patientHome()
    }
}
struct DrawerView: View {
    let items = ["Breathing Exercice", "Meditation tips", "About"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    NavigationLink(destination: destinationForItem(item)) {
                        Text(item)
                    }
                }
            }
            .navigationBarTitle("Drawer", displayMode: .inline)
        }
    }
    
    func destinationForItem(_ item: String) -> some View {
        switch item {
        case "Breathing Exercice":
            return AnyView(Breathing())
        case "Meditation tips":
            return AnyView(Meditation())
        case "About":
            return AnyView(EmptyView())
        default:
            return AnyView(EmptyView())
        }
    }
}
