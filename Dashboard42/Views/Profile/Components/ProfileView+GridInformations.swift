//
//  ProfileView+GridInformations.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

extension ProfileView {

    struct GridInformations: View {

        // MARK: - Properties

        let location: String?
        let grade: String?
        let poolYear: String

        // MARK: - Body

        var body: some View {
            HStack {
                GridInformationsItem(title: "Emplacement", value: location != nil ? "\(location!.uppercased())" : "Indéfinie")
                GridInformationsItem(title: "Grade", value: grade != nil ? "\(grade!)" : "Indéfinie")
                GridInformationsItem(title: "Promotion", value: "\(poolYear)")
            }
        }
    }

}

// MARK: - Previews

#Preview {
    ProfileView.GridInformations(location: "Z1R1P1", grade: "Member", poolYear: "2021")
}

// MARK: - Private Components

extension ProfileView.GridInformations {

    fileprivate struct GridInformationsItem: View {

        // MARK: - Properties

        let title: LocalizedStringResource
        let value: LocalizedStringResource

        // MARK: - Body

        var body: some View {
            VStack(spacing: 8) {
                Text(title)
                    .foregroundStyle(.secondary)
                    .font(.footnote)

                Text(value)
                    .foregroundStyle(.primary)
                    .font(.system(.body, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
        }
    }

}
