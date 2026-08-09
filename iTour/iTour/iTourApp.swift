//
//  iTourApp.swift
//  iTour
//
//  Created by Cepheus on 10/08/26.
//

import SwiftUI
import SwiftData

@main
struct iTourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
		}.modelContainer(for: Destination.self)
    }
}
