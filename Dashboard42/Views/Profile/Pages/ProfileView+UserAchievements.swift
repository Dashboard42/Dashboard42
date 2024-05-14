//
//  ProfileView+UserAchievements.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 14/05/2024.
//

import SwiftUI

extension ProfileView {

    struct UserAchievements: View {

        // MARK: - Properties

        @State private var selectedFilter = "Tous"
        @State private var searched = ""

        let achievements: [Api.User.Achievements]

        private var filteredAchievements: [Api.User.Achievements] {
            let filteredAchievements =
                selectedFilter == "Tous"
                ? achievements : achievements.filter { $0.kind.capitalized == selectedFilter }

            guard !searched.isEmpty else { return filteredAchievements }
            return filteredAchievements.filter { $0.name.lowercased().contains(searched.lowercased()) }
        }

        // MARK: - Body

        var body: some View {
            List(filteredAchievements) { achievement in
                VStack(alignment: .leading, spacing: 4) {
                    Text(achievement.name)
                        .foregroundStyle(.primary)

                    Text(achievement.description)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Accomplissements")
            .searchable(text: $searched)
            .toolbar {
                FilterButton(selection: $selectedFilter, achievements: achievements)
            }
            .overlay {
                if !searched.isEmpty && filteredAchievements.isEmpty {
                    ContentUnavailableView.search(text: searched)
                }
                else if filteredAchievements.isEmpty {
                    ContentUnavailableView(
                        "Aucun accomplissement trouvé",
                        systemImage: "graduationcap",
                        description: Text(
                            "Vous devez atteindre des objectifs pour débloquer des accomplissements."
                        )
                    )
                }
            }
        }
    }

}

// MARK: - Previews

#Preview {
    ProfileView.UserAchievements(achievements: .sample)
}

// MARK: - Private Components

extension ProfileView.UserAchievements {

    private struct FilterButton: View {

        // MARK: - Properties

        @Binding var selection: String
        let filters: [String]

        init(selection: Binding<String>, achievements: [Api.User.Achievements]) {
            self._selection = selection

            var filters: Set<String> = Set(achievements.map(\.kind.capitalized))
            filters.insert("Tous")

            self.filters = Array(filters).sorted()
        }

        // MARK: - Body

        var body: some View {
            Menu {
                Picker("Select a filter", selection: $selection) {
                    ForEach(filters, id: \.self, content: Text.init)
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .imageScale(.large)
            }
            .tint(.night)
        }
    }

}
