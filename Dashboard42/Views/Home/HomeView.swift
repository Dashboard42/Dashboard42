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
                            Shortcut(
                                image: "briefcase.fill",
                                destination: ProfileView.UserProjects(
                                    projects: user.projectsUsers,
                                    cursus: user.cursusUsers
                                )
                            )
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
                .refreshable {
                    await refresh(user: user)
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

    private func refresh(user: Api.User) async {
        isLoading = true

        do {
            store.userEvents = try await store.eventService.fetchUserEvents(userId: user.id)
            store.userExams = try await store.examService.fetchUserExams(userId: user.id)
            store.userScales = try await store.correctionService.fetchUserScales()
        }
        catch {
            store.error = error as? Api.Errors
        }

        isLoading = false
    }

}
