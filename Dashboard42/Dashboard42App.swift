//
//  Dashboard42App.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

@main
struct Dashboard42App: App {

    // MARK: - Properties

    @State private var store = Store()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.store, store)
                .handleError(error: store.error, actions: store.errorAction)
        }
    }
}
