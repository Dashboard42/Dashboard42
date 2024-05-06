//
//  ContentView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Properties

    @Environment(\.store) private var store
    @AppStorage(Constants.AppStorage.Keys.userIsConnected) private var userIsConnected: Bool?

    // MARK: - Body

    var body: some View {
        @Bindable var store = store

        if userIsConnected != true {
            OnBoardingView()
        }
        else {
            AppTabView(selection: $store.selection)
        }
    }
}

// MARK: - Previews

#Preview {
    ContentView()
}

// MARK: - Private Methods

extension ContentView {
}
