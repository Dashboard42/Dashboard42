//
//  Dashboard42App.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

@main
struct Dashboard42App: App {
    @State private var store: Store = Store(network: Network())

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.store, self.store)
        }
    }
}
