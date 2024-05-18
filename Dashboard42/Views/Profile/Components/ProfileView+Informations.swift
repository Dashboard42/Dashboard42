//
//  ProfileView+Informations.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

extension ProfileView {

    struct Informations: View {

        // MARK: - Properties

        let name: String
        let email: String
        let isPostCommonCore: Bool
        let cursus: Api.User.Cursus?

        // MARK: - Body

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(name)
                            .foregroundStyle(.primary)
                            .font(.system(.title2, weight: .bold))

                        Spacer()

                        if isPostCommonCore {
                            Image(systemName: "checkmark.seal.fill")
                                .imageScale(.small)
                                .padding(.vertical, 4)
                                .foregroundStyle(.night)
                        }
                    }

                    Text(email)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }

                ProgressView(
                    value: cursus?.level != nil ? (cursus!.level > 21 ? 21 : cursus!.level) : 0.0,
                    total: 21
                ) {
                    HStack {
                        Image(systemName: "trophy")
                            .imageScale(.small)
                            .font(.subheadline)
                            .fontWeight(.medium)

                        Text("Niveau - \(cursus?.level.formatted() ?? "0")")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(cursus?.cursus.name ?? "N/A")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
                .tint(.night)
            }
        }
    }

}

// MARK: - Previews

#Preview {
    ProfileView.Informations(name: "Marc MOSCA", email: "mmosca@student.42lyon.fr", isPostCommonCore: true, cursus: nil)
}
