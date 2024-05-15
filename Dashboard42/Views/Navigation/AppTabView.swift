//
//  AppTabView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

struct AppTabView: View {

    // MARK: - Properties

    @Environment(\.store) private var store
    @Binding var selection: AppScreen

    // MARK: - Body

    var body: some View {
        VStack {
            TabView(selection: $selection) {
                ForEach(AppScreen.allCases) { screen in
                    screen.destination
                        .tag(screen as AppScreen?)
                        .tabItem { screen.label }
                }
            }
            .tint(.night)
        }
        .slideIn(rowHeight: 50, duration: 1, delay: 0.2)
    }
}

// MARK: - Previews

#Preview {
    AppTabView(selection: .constant(.home))
}
