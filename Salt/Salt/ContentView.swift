//
//  ContentView.swift
//  Salt
//
//  Created by Gordon Gooi on 21/12/21.
//

import SwiftUI
import RealmSwift


// MARK: Main Views
/// The main screen that determines whether to present the SyncContentView or the LocalOnlyContentView.

@main
struct ContentView: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            // Using Sync?
            if let app = app {
                SyncContentView(app: app)
            } else {
                LocalOnlyContentView()
            }
        }
    }
}
