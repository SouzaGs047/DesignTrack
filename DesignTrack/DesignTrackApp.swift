//
//  DesignTrackApp.swift
//  DesignTrack
//
//  Created by GUSTAVO SOUZA SANTANA on 11/02/25.
//

import SwiftUI
import SwiftData

@main
struct DesignTrackApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [ProjectModel.self,
                                      LogModel.self,
                                      LogImageModel.self,
                                      FontModel.self,
                                      ColorModel.self])
        }
    }
}
