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
        /// The user's unique identifier.
        let id: Int

        /// The user's email address.
        let email: String

        /// The user's login name.
        let login: String

        /// The user's telephone number.
        let phone: String

        /// The name displayed for the user.
        let displayname: String

        /// The structure representing the user's avatar.
        let image: Avatar

        /// Correction points awarded to the user.
        let correctionPoint: Int

        /// The month of integration of the user.
        let poolMonth: String

        /// The year of integration of the user.
        let poolYear: String

        /// The user's current location.
        let location: String?

        /// The user's virtual points wallet.
        let wallet: Int

        /// A list of courses taken by the user.
        let cursusUsers: [Cursus]

        /// A list of projects completed or in progress by the user.
        let projectsUsers: [Projects]

        /// Achievements or badges obtained by the user.
        let achievements: [Achievements]

        /// List of mentoring relationships in which the user is a mentee.
        let patroned: [Patronages]

        /// List of mentoring relationships where the user is a mentor.
        let patroning: [Patronages]

        /// List of campuses associated with the user.
        let campusUsers: [Campus]

        /// Returns the user's main course.
        var mainCursus: Cursus? {
            let studentCursus = cursusUsers.first(where: { $0.cursus.slug == "42cursus" })
            let piscineCursus = cursusUsers.first(where: { $0.cursus.slug == "c-piscine" })

            return studentCursus != nil ? studentCursus : piscineCursus
        }

        /// Returns the user's main campus.
        var mainCampus: Campus? { campusUsers.first(where: \.isPrimary) }

        /// Indicates whether the user has validated key projects, such as "ft-transcendence" and "exam-rank-06".9
        var postCC: Bool {
            let lastProject = projectsUsers.first(where: { $0.project.slug == "ft_transcendence" })
            let lastExam = projectsUsers.first(where: { $0.project.slug == "exam-rank-06" })

            return lastProject?.validated == true && lastExam?.validated == true
        }

        /// Calculates the user's entry date by formatting the month and year of integration.
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
            /// The unique identifier of the achievement, used to distinguish each `Achievements` from the others.
            let id: Int

            /// The name of the achievement, which briefly describes what the user has done.
            let name: String

            /// A more detailed description of the achievement, providing additional information on what the achievement means or what it took to achieve it.
            let description: String

            /// A classification or type of achievement, which can be used to group or categorise achievements into similar or related types.
            let kind: String
        }

        // MARK: - Avatar

        /// The `Avatar` structure is used to represent the profile image of a user in the application.
        struct Avatar: Decodable {
            /// The URL in the form of a character string that points to the avatar image on a server.
            let link: String
        }

        // MARK: - Campus

        /// The `Campus` structure is used to represent information specific to a campus associated with a user in the application.
        struct Campus: Decodable, Identifiable {
            /// An identifier to conform to the `Identifiable` protocol.
            let id: Int

            /// The unique identifier for the campus.
            let campusId: Int

            /// A Boolean indicator that signifies whether the campus is the main campus for the user.
            let isPrimary: Bool
        }

        // MARK: - Cursus

        /// The `Courses` structure is designed to represent an academic course in which a user is or has been enrolled.
        struct Cursus: Decodable, Identifiable {
            /// An identifier to conform to the `Identifiable` protocol.
            let id: Int

            /// The grade reached in the course.
            let grade: String?

            /// The user's level of skill or progress in the course.
            let level: Double

            /// A list of skills acquired or assessed as part of the course.
            let skills: [Skills]

            /// The course identifier.
            let cursusId: Int

            /// Indicates whether the curriculum is associated with coalitions or collaborative groups.
            let hasCoalition: Bool

            /// Additional details about the curriculum.
            let cursus: Details

            /// The structure representing the skills in a curriculum.
            struct Skills: Decodable, Identifiable {
                /// Unique skill identifier.
                let id: Int

                /// The name of the skill, describing the skill acquired or assessed.
                let name: String

                /// The level achieved in this skill.
                let level: Double
            }

            /// The structure representing the details of a curriculum.
            struct Details: Decodable, Identifiable {
                /// The unique identifier for these details.
                let id: Int

                /// The full name of the course, used for display or references.
                let name: String

                /// A simplified version of the name.
                let slug: String
            }
        }

        // MARK: - Projects

        /// The `Projects` structure represents a specific project in which a user has participated or is currently participating.
        struct Projects: Decodable, Identifiable {
            /// The unique project identifier.
            let id: Int

            /// The final grade awarded to the project.
            let finalMark: Int?

            /// The current status of the project, such as "in progress", "completed", etc.
            let status: String

            /// Indicates whether the project has been validated, i.e. recognised as successful.
            let validated: Bool?

            /// The ID of the current team working on the project, useful for group projects.
            let currentTeamId: Int?

            /// Additional information about the project, encapsulated in a `Details` structure.
            let project: Details

            /// The identifiers of the courses with which this project is associated.
            let cursusIds: [Int]

            /// The date on which the project was last assessed.
            let markedAt: Date?

            /// Indicates whether the project has been marked for assessment.
            let marked: Bool

            /// The date by which the project may be resubmitted for assessment, if applicable.
            let retriableAt: Date?

            /// Formats the `markedAt` date into a user-readable representation. If `markedAt` is `nil`, returns "In progress".
            var markedAtFormatted: String {
                guard let markedAt = markedAt else { return "En cours" }

                let formatStyle = Date.FormatStyle.dateTime.year().month(.wide)

                return markedAt.formatted(formatStyle)
            }

            /// The structure representing the details of a project.
            struct Details: Codable, Identifiable, Hashable {
                /// The unique identifier of the project details.
                let id: Int

                /// The name of the project.
                let name: String

                /// A simplified identifier typically used in URLs or technical references.
                let slug: String

                /// The identifier of the parent project, if the project is a sub-part of a larger project.
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
            /// The unique identifier of the patronage relationship.
            let id: Int

            /// The identifier of the user who is the beneficiary of the patronage relationship (the sponsee).
            let userId: Int

            /// The identifier of the user acting as mentor or sponsor in the patronage relationship.
            let godfatherId: Int

            /// A Boolean indicator indicating whether the patronage relationship is still active.
            let ongoing: Bool
        }

    }
}
