//
//  ScaleList.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

struct ScaleList: View {

    // MARK: - Properties

    let scales: [Api.Scale]
    let maxLength: Int

    init(scales: [Api.Scale], maxLength: Int? = nil) {
        self.scales = scales
        self.maxLength = maxLength != nil ? maxLength! : scales.count
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Corrections")
                .foregroundStyle(.secondary)
                .font(.subheadline)

            ForEach(scales.prefix(maxLength), content: ScaleRow.init)
        }
    }
}

// MARK: - Previews

#Preview {
    ScaleList(scales: .sample)
}

// MARK: - Private Components

extension ScaleList {

    private struct ScaleRow: View {

        // MARK: - Properties

        @Environment(\.store) private var store

        let scale: Api.Scale

        private var isCorrector: Bool { store.user?.login == scale.correctorName }
        private var projectId: Int { scale.teams?.projectId ?? -1 }
        private var projectName: String {
            store.user?.projectsUsers.first(where: { $0.project.id == projectId })?.project.name ?? "\(projectId)"
        }

        // MARK: - Body

        var body: some View {
            HStack(spacing: 16) {
                Image(systemName: "person.badge.clock")
                    .foregroundStyle(.night)
                    .font(.headline)
                    .imageScale(.large)

                VStack(alignment: .leading, spacing: 2) {
                    Text(
                        isCorrector
                            ? "Vous corrigez \(scale.teamName) sur \(projectName)."
                            : "Vous êtes corrigé par \(scale.correctorName) sur \(projectName)."
                    )
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)

                    Text(scale.beginAt, format: .dateTime.day().month().year().hour().minute())
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 8)
        }
    }

}
