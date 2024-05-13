//
//  HomeView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 11/05/2024.
//

import SwiftUI

struct HomeView: View {

    // MARK: - Properties

    @Environment(\.store) private var store
    @State private var isLoading = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            if let user = store.user, !isLoading {
                ScrollView {
                    VStack(spacing: 40) {
                        HStack(spacing: 20) {
                            Avatar(url: user.image.link)
                            WelcomeBackTitle(name: user.displayname)
                        }

                        HStack {
                            Shortcut(image: "briefcase.fill", destination: EmptyView())
                            Shortcut(image: "graduationcap.fill", destination: EmptyView())
                                .frame(maxWidth: .infinity)
                            Shortcut(image: "calendar", destination: EmptyView())
                            Shortcut(image: "scroll.fill", destination: EmptyView())
                                .frame(maxWidth: .infinity)
                            Shortcut(image: "clock.fill", destination: EmptyView())
                        }

                        UpcomingActivities()
                    }
                    .padding()
                }
            }
            else {
                ProgressView()
            }
        }
    }
}

// MARK: - Previews

#Preview {
    HomeView()
}

// MARK: - Private Methods

extension HomeView {
}
