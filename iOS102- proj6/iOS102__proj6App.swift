//
//  iOS102__proj6App.swift
//  iOS102- proj6
//
//  Created by Anbu Damodaran on 4/5/24.
//

import SwiftUI
import FirebaseCore // <-- Import Firebase

@main
struct iOS102__proj6App: App {
    init() { // <-- Add an init
        FirebaseApp.configure() // <-- Configure Firebase app
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
