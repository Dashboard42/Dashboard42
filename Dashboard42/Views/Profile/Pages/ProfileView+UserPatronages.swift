//
//  ProfileView+UserPatronages.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 14/05/2024.
//

import SwiftUI

extension ProfileView {

    struct UserPatronages: View {

        // MARK: - Properties

        @Environment(\.store) private var store
        @State private var userPatroned = [Api.User]()
        @State private var userPatroning = [Api.User]()
        @State private var isLoading = false
        @State private var isFirstLoad = true

        let patroned: [Api.User.Patronages]
        let patroning: [Api.User.Patronages]

        // MARK: - Body

        var body: some View {
            VStack {
                if isLoading {
                    ProgressView()
                }
                else {
                    List {
                        if !userPatroned.isEmpty {
                            Section("Parrain") {
                                ForEach(userPatroned, content: UserCard.init)
                            }
                        }

                        if !userPatroning.isEmpty {
                            Section("Filleul") {
                                ForEach(userPatroning, content: UserCard.init)
                            }
                        }
                    }
                    .overlay {
                        if userPatroned.isEmpty && userPatroning.isEmpty {
                            ContentUnavailableView("Aucun parrainage trouvé", systemImage: "person.2")
                        }
                    }
                }
            }
            .navigationTitle("Parrainages")
            .task {
                await fetchUserPatronages()
            }
        }

        // MARK: - Private Methods

        private func fetchUserPatronages() async {
            guard isFirstLoad else { return }

            isLoading = true

            do {
                for user in patroned {
                    let result = try await store.userService.fetchUser(id: user.godfatherId)
                    userPatroned.append(result)
                }

                for user in patroning {
                    let result = try await store.userService.fetchUser(id: user.userId)
                    userPatroning.append(result)
                }
            }
            catch {
                store.error = error as? Api.Errors
            }

            isFirstLoad = false
            isLoading = false
        }

    }

}

// MARK: - Previews

#Preview {
    ProfileView.UserPatronages(patroned: .sample, patroning: .sample)
}

// MARK: - Private Components

extension ProfileView.UserPatronages {

    private struct UserCard: View {

        // MARK: - Properties

        let user: Api.User

        // MARK: - Body

        var body: some View {
            NavigationLink {
                ProfileView(user: user)
            } label: {
                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: user.image.link)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 48, height: 48)
                    .clipShape(.circle)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(user.displayname)
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .fontWeight(.semibold)

                        Text(user.email)
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 8)
            }
        }
    }

}
