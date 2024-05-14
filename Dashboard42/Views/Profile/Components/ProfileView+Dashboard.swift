//
//  ProfileView+Dashboard.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

extension ProfileView {

    struct Dashboard: View {

        // MARK: - Properties

        let user: Api.User
        let isSearchedProfile: Bool

        // MARK: - Body

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Dashboard")
                    .foregroundStyle(.primary)
                    .font(.headline)

                List {
                    DashboardLink(image: "info.circle", title: "Informations") {
                        UserInformations(user: user)
                    }

                    DashboardLink(image: "briefcase", title: "Projets") {
                        UserProjects(projects: user.projectsUsers, cursus: user.cursusUsers)
                    }

                    if !isSearchedProfile {
                        DashboardLink(image: "calendar", title: "Événements") {
                            UserEvents()
                        }

                        DashboardLink(image: "clock", title: "Logtime") {
                            EmptyView()
                        }

                        DashboardLink(image: "scroll", title: "Corrections") {
                            EmptyView()
                        }
                    }

                    DashboardLink(image: "list.bullet.clipboard", title: "Compétences") {
                        UserSkills(skills: user.mainCursus?.skills ?? [])
                    }

                    DashboardLink(image: "graduationcap", title: "Accomplissements") {
                        UserAchievements(achievements: user.achievements)
                    }

                    DashboardLink(image: "person.2", title: "Parrainages") {
                        EmptyView()
                    }
                }
                .listStyle(.plain)
                .frame(minHeight: 70 * CGFloat(integerLiteral: isSearchedProfile ? 5 : 8))
            }
        }
    }

}

// MARK: - Private Components

extension ProfileView.Dashboard {

    fileprivate struct DashboardLink<T: View>: View {

        // MARK: - Properties

        let image: String
        let title: String
        let destination: () -> T

        // MARK: - Body

        var body: some View {
            NavigationLink(destination: destination) {
                HStack(spacing: 16) {
                    Image(systemName: image)
                        .foregroundStyle(.night)
                        .imageScale(.medium)
                        .font(.headline)
                        .frame(width: 48, height: 48)
                        .background(.thickMaterial)
                        .clipShape(.rect(cornerRadius: 8))

                    Text(title)
                        .foregroundStyle(.primary)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
            }
        }
    }

}
