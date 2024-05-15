//
//  ProfileView+UserInformations.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

extension ProfileView {

    struct UserInformations: View {

        // MARK: - Properties

        let user: Api.User

        // MARK: - Body

        var body: some View {
            List {
                Section("Général") {
                    HorizontalRow(title: "Nom", value: user.displayname)
                    HorizontalRow(title: "Email", value: user.email)
                    HorizontalRow(title: "Numéro de téléphone", value: user.phone)
                }

                Section("Cursus") {
                    HorizontalRow(title: "Grade", value: user.mainCursus?.grade ?? "Indéfinie")
                    HorizontalRow(title: "Niveau", value: user.mainCursus?.level.formatted() ?? "Indéfinie")
                    HorizontalRow(title: "Points de correction", value: user.correctionPoint.formatted())
                    HorizontalRow(title: "Wallets", value: user.wallet.formatted())
                    HorizontalRow(title: "Promotion", value: "\(user.poolMonth.capitalized) \(user.poolYear)")
                }
            }
            .navigationTitle("Informations")
        }
    }

}

// MARK: - Previews

#Preview {
    ProfileView.UserInformations(user: .sample)
}

// MARK: - Private Components

extension ProfileView.UserInformations {

    private struct HorizontalRow: View {

        // MARK: - Properties

        let title: String
        let value: String

        // MARK: - Body

        var body: some View {
            HStack {
                Text(title)
                    .foregroundStyle(.primary)
                    .padding(.trailing, 10)

                Spacer()

                Text(value)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.vertical, 4)
        }
    }

}
