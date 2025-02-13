//
//  SplashScreen.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 06/02/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            if isActive {
                ContentView()
            } else {
                VStack {
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .scaleEffect(scale)
                        .animation(
                            Animation.easeInOut(duration: 0.4)
                                .repeatForever(autoreverses: true), value: scale
                        )
                        .onAppear {
                            scale = 1.05 // Valor de escala inicial
                        }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            self.isActive = true
                        }
                        
                    }
                }
            }
        }
    }
}



