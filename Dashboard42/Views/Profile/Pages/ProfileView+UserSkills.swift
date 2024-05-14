//
//  ProfileView+UserSkills.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 14/05/2024.
//

import SwiftUI

extension ProfileView {

    struct UserSkills: View {

        // MARK: - Properties

        let skills: [Api.User.Cursus.Skills]

        // MARK: - Body

        var body: some View {
            VStack {
                if skills.isEmpty {
                    ContentUnavailableView(
                        "Aucune compétence trouvée",
                        systemImage: "list.bullet.clipboard",
                        description: Text("Validez un projet pour gagner des points de compétences.")
                    )
                }
                else {
                    List(skills) { skill in
                        HStack {
                            Text(skill.name)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            Text(skill.level.formatted())
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Compétences")
        }
    }

}

// MARK: - Previews

#Preview {
    ProfileView.UserSkills(skills: .sample)
}
