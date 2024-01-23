//
//  datasVideoApp.swift
//  datasVideo
//
//  Created by duverney muriel on 11/01/24.
//

import SwiftUI
import SwiftData

@main
struct datasVideoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Container.self)
        }
    }
}
