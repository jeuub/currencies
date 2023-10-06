//
//  currencyApp.swift
//  currency
//
//  Created by Eiyub Bodur on 10/06/23.
//

import SwiftUI

@main
struct currencyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
