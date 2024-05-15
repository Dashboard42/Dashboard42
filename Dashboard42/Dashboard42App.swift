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

    @AppStorage(Constants.AppStorage.userColorscheme) private var userColorscheme: Int?
    @AppStorage(Constants.AppStorage.userLanguage) private var userLanguage: String?
    @State private var store = Store()

    private var identifier: String { userLanguage ?? Locale.current.identifier }
    private var colorscheme: ColorScheme? { AppColorScheme.transformToColorScheme(colorScheme: userColorscheme ?? 0) }

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.store, store)
                .environment(\.locale, .init(identifier: identifier))
                .preferredColorScheme(colorscheme)
                .handleError(error: store.error, actions: store.errorAction)
        }
    }
}
