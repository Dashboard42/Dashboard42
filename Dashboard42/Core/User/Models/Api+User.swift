//
//  Api+User.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 07/05/2024.
//

import Foundation

extension Api {

    /// The `User` structure is a data model for representing a user in the application.
    struct User: Decodable, Identifiable {
        let id: Int
        let email: String
        let login: String
        let phone: String
        let displayname: String
        let image: Avatar
        let correctionPoint: Int
        let poolMonth: String
        let poolYear: String
        let location: String?
        let wallet: Int
        let cursusUsers: [Cursus]
        let projectsUsers: [Projects]
        let achievements: [Achievements]
        let patroned: [Patronages]
        let patroning: [Patronages]
        let campusUsers: [Campus]

        var mainCursus: Cursus? {
            let studentCursus = cursusUsers.first(where: { $0.cursus.slug == "42cursus" })
            let piscineCursus = cursusUsers.first(where: { $0.cursus.slug == "c-piscine" })

            return studentCursus != nil ? studentCursus : piscineCursus
        }

        var mainCampus: Campus? { campusUsers.first(where: \.isPrimary) }

        var postCC: Bool {
            let lastProject = projectsUsers.first(where: { $0.project.slug == "ft_transcendence" })
            let lastExam = projectsUsers.first(where: { $0.project.slug == "exam-rank-06" })

            return lastProject?.validated == true && lastExam?.validated == true
        }

        var entryDate: String {
            let defaultEntryDate = "\(poolYear)-01-01"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"

            guard let monthDate = dateFormatter.date(from: poolMonth) else { return defaultEntryDate }

            let calendar = Calendar.current
            let year = Int(poolYear) ?? 1

            guard let date = calendar.date(bySetting: .year, value: year, of: monthDate) else {
                return defaultEntryDate
            }

            dateFormatter.dateFormat = "yyyy-MM-dd"

            return dateFormatter.string(from: date)
        }

        // MARK: - Achievements

        /// The `Achievements` structure is used to represent a user's achievements or accomplishments.
        struct Achievements: Decodable, Identifiable {
            let id: Int
            let name: String
            let description: String
            let kind: String
        }

        // MARK: - Avatar

        /// The `Avatar` structure is used to represent the profile image of a user in the application.
        struct Avatar: Decodable {
            let link: String
        }

        // MARK: - Campus

        /// The `Campus` structure is used to represent information specific to a campus associated with a user in the application.
        struct Campus: Decodable, Identifiable {
            let id: Int
            let campusId: Int
            let isPrimary: Bool
        }

        // MARK: - Cursus

        /// The `Cursus` structure is designed to represent an academic cursus in which a user is or has been enrolled.
        struct Cursus: Decodable, Identifiable {
            let id: Int
            let grade: String?
            let level: Double
            let skills: [Skills]
            let cursusId: Int
            let hasCoalition: Bool
            let cursus: Details

            /// The structure representing the skills in a curriculum.
            struct Skills: Decodable, Identifiable {
                let id: Int
                let name: String
                let level: Double
            }

            /// The structure representing the details of a curriculum.
            struct Details: Decodable, Identifiable {
                let id: Int
                let name: String
                let slug: String
            }
        }

        // MARK: - Projects

        /// The `Projects` structure represents a specific project in which a user has participated or is currently participating.
        struct Projects: Decodable, Identifiable {
            let id: Int
            let finalMark: Int?
            let status: String
            let validated: Bool?
            let currentTeamId: Int?
            let project: Details
            let cursusIds: [Int]
            let markedAt: Date?
            let marked: Bool
            let retriableAt: Date?

            var markedAtFormatted: String {
                guard let markedAt = markedAt else { return "En cours" }

                let formatStyle = Date.FormatStyle.dateTime.year().month(.wide)

                return markedAt.formatted(formatStyle)
            }

            /// The structure representing the details of a project.
            struct Details: Codable, Identifiable, Hashable {
                let id: Int
                let name: String
                let slug: String
                let parentId: Int?
            }

            private enum CodingKeys: String, CodingKey {
                case id, finalMark, status, currentTeamId, project, cursusIds, markedAt, marked, retriableAt
                case validated = "validated?"
            }
        }

        // MARK: - Patronages

        /// The `Patronages` structure is designed to represent a mentoring or patronage relationship.
        struct Patronages: Decodable, Identifiable {
            let id: Int
            let userId: Int
            let godfatherId: Int
            let ongoing: Bool
        }

    }
}
