//
//  ProfileView+UserProjects.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

extension ProfileView {

    struct UserProjects: View {

        // MARK: - Properties

        @State private var selectedFilter = String(localized: "Tous")
        @State private var searched = ""

        let projects: [Api.User.Projects]
        let cursus: [Api.User.Cursus]

        private var filteredProjects: [Api.User.Projects] {
            let cursusId = cursus.first(where: { $0.cursus.name.capitalized == selectedFilter })?.cursus.id
            var filteredProjects =
                selectedFilter == String(localized: "Tous") ? projects : projects.filter { $0.cursusIds.first == cursusId }
            filteredProjects =
                searched.isEmpty
                ? filteredProjects
                : filteredProjects.filter { $0.project.name.lowercased().contains(searched.lowercased()) }
            return filteredProjects
        }

        private var filteredGroupedProjects: [GroupedUserProjects] { createGroupedUserProjects(for: filteredProjects) }

        // MARK: - Body

        var body: some View {
            List(filteredGroupedProjects) { groupedProject in
                if !groupedProject.projects.isEmpty {
                    Section(groupedProject.monthYear) {
                        ForEach(groupedProject.projects) { project in
                            ProjectRow(project: project, cursus: cursus)
                        }
                    }
                }
            }
            .navigationTitle("Projets")
            .searchable(text: $searched)
            .toolbar {
                FilterButton(selection: $selectedFilter, cursus: cursus)
            }
            .overlay {
                if !searched.isEmpty && filteredProjects.isEmpty {
                    ContentUnavailableView.search(text: searched)
                }
                else if filteredProjects.isEmpty {
                    ContentUnavailableView(
                        "Aucun projet trouvé",
                        systemImage: "briefcase",
                        description: Text(
                            "Vous devez être inscrit ou avoir rendu un projet pour le voir dans la liste."
                        )
                    )
                }
            }
        }
    }

}

// MARK: - Previews

#Preview {
    ProfileView.UserProjects(projects: .sample, cursus: .sample)
}

// MARK: - Private UI Components

extension ProfileView.UserProjects {

    private struct ProjectRow: View {

        // MARK: - Properties

        let project: Api.User.Projects
        let cursus: [Api.User.Cursus]

        private var image: String {
            guard let validated = project.validated else { return "timer" }
            return validated ? "checkmark.circle" : "xmark.circle"
        }

        private var color: Color {
            guard let validated = project.validated else { return .orange }
            return validated ? .green : .red
        }

        private var status: LocalizedStringResource { project.validated == nil ? "En cours" : "Terminé" }

        private var cursusName: String {
            cursus.first(where: { $0.cursus.id == project.cursusIds.first })?.cursus.name ?? "Indéfinie"
        }

        // MARK: - Body

        var body: some View {
            HStack(spacing: 20) {
                Image(systemName: image)
                    .foregroundStyle(color)
                    .font(.headline)
                    .imageScale(.large)

                VStack(alignment: .leading) {
                    Text(project.project.name)
                        .foregroundStyle(.primary)
                        .font(.system(.subheadline, weight: .bold))

                    Text("\(cursusName) - \(status)")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if let finalMark = project.finalMark {
                    Text("\(finalMark.formatted()) %")
                        .foregroundStyle(color)
                        .font(.system(.subheadline, weight: .bold))
                }
            }
            .padding(.vertical, 8)
        }
    }

    private struct FilterButton: View {

        // MARK: - Properties

        @Binding var selection: String
        let filters: [String]

        init(selection: Binding<String>, cursus: [Api.User.Cursus]) {
            self._selection = selection

            var filters: Set<String> = Set(cursus.map(\.cursus.name.capitalized))
            filters.insert("Tous")

            self.filters = Array(filters).sorted()
        }

        // MARK: - Body

        var body: some View {
            Menu {
                Picker("Sélectionner un filtre", selection: $selection) {
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

// MARK: - Private Components

extension ProfileView.UserProjects {

    private struct GroupedUserProjects: Identifiable {
        let monthYear: String
        let projects: [Api.User.Projects]

        var id: String { monthYear }
    }

    private func createGroupedUserProjects(for projects: [Api.User.Projects]) -> [GroupedUserProjects] {
        let finishedProjects = projects.filter(\.marked)
        let projectsInProgress = GroupedUserProjects(
            monthYear: "En cours",
            projects: projects.filter { $0.markedAt == nil }
        )

        let dictionary = Dictionary(grouping: finishedProjects, by: \.markedAtFormatted)
        let sortedKeys = dictionary.keys.sorted { lhs, rhs in
            let lhsProject = projects.first(where: { $0.markedAtFormatted == lhs })
            let rhsProject = projects.first(where: { $0.markedAtFormatted == rhs })

            guard let lhsDate = lhsProject?.markedAt, let rhsDate = rhsProject?.markedAt else { return false }
            return lhsDate > rhsDate
        }

        var list = sortedKeys.compactMap { GroupedUserProjects(monthYear: $0, projects: dictionary[$0] ?? []) }

        list.insert(projectsInProgress, at: 0)

        return list

    }

}
