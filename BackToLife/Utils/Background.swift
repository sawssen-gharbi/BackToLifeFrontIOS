//
//  Background.swift
//  BackToLife
//
//  Created by Mac mini 8 on 15/4/2023.
//


import SwiftUI
import Foundation

struct Background: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        DispatchQueue.main.async {
            // Superview twice to make fullScreenCover transparent
            // Child ZStack -> fullScreenSheet
            view.superview!.superview!.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
