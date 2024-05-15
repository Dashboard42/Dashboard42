//
//  SearchView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 15/05/2024.
//

import SwiftData
import SwiftUI

struct SearchView: View {

    // MARK: - Properties

    @Environment(\.store) private var store
    @Environment(\.modelContext) private var modelContext
    @Query private var historySearch: [HistorySearch]

    @State private var searched = ""
    @State private var isSearchedSucceded: Bool?
    @State private var user: Api.User?

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                if isSearchedSucceded == false {
                    ContentUnavailableView.search(text: searched)
                }
                else {
                    if !historySearch.isEmpty {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Historique de recherche")
                                .foregroundStyle(.primary)
                                .font(.headline)
                                .padding([.top, .horizontal])

                            List {
                                ForEach(historySearch.reversed()) { historyUser in
                                    UserCard(user: historyUser, fetchUser: fetchUser)
                                }
                                .onDelete(perform: onDelete)
                            }
                            .listStyle(.plain)
                        }
                    }
                    else {
                        ContentUnavailableView(
                            "Aucun historique de recherche",
                            systemImage: "magnifyingglass",
                            description: Text("Recherchez un étudiant pour le voir dans la liste.")
                        )
                    }
                }
            }
            .navigationTitle("Recherche")
            .searchable(text: $searched)
            .autocorrectionDisabled()
            .onAppear { isSearchedSucceded = nil }
            .onChange(of: searched) { isSearchedSucceded = nil }
            .onSubmit(of: .search) {
                Task {
                    await fetchUser(login: searched.lowercased())
                }
            }
            .navigationDestination(isPresented: .constant(isSearchedSucceded == true)) {
                if let user = user {
                    ProfileView(user: user)
                }
            }
        }
    }

    // MARK: - Private Methods

    private func fetchUser(login: String) async {
        do {
            let endpoint = Api.UserEndpoints.fetchUserByLogin(login: login)
            let result = try await Api.shared.fetch(endpoint, type: Api.User.self)

            user = result
            isSearchedSucceded = true

            guard !historySearch.contains(where: { $0.login == result.login }) else { return }
            modelContext.insert(HistorySearch(login: result.login, email: result.email, image: result.image.link))
        }
        catch {
            store.error = error as? Api.Errors
        }
    }

    private func onDelete(indexSet: IndexSet) {
        let count = historySearch.count - 1

        for index in indexSet {
            modelContext.delete(historySearch[count - index])
        }
    }

}

// MARK: - Previews

#Preview {
    SearchView()
}

// MARK: - Private Components

extension SearchView {

    struct UserCard: View {

        // MARK: - Properties

        let user: HistorySearch
        let fetchUser: (String) async -> Void

        // MARK: - Body

        var body: some View {
            HStack {
                AsyncImage(url: URL(string: user.image)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 48, height: 48)
                .clipShape(.circle)

                VStack(alignment: .leading, spacing: 2) {
                    Text(user.login)
                        .foregroundStyle(.primary)
                        .font(.headline)

                    Text(user.email)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 8)
            .onTapGesture {
                Task {
                    await fetchUser(user.login)
                }
            }
        }

    }

}
