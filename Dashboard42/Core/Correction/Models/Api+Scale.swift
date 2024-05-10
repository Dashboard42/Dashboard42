//
//  Api+Scale.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

extension Api {

    /// Represents data relating to a scale (evaluation).
    struct Scale: Codable, Identifiable {
        let id: Int
        let scaleId: Int
        let beginAt: Date
        let correcteds: CorrectedsType?
        let corrector: CorrectorType?
        let scale: Details
        let teams: Team?

        init(
            id: Int,
            scaleId: Int,
            beginAt: Date,
            correcteds: CorrectedsType?,
            corrector: CorrectorType?,
            scale: Details,
            teams: Team?
        ) {
            self.id = id
            self.scaleId = scaleId
            self.beginAt = beginAt
            self.correcteds = correcteds
            self.corrector = corrector
            self.scale = scale
            self.teams = teams
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.scaleId = try container.decode(Int.self, forKey: .scaleId)
            self.beginAt = try container.decode(Date.self, forKey: .beginAt)
            self.scale = try container.decode(Scale.Details.self, forKey: .scale)
            self.teams = try container.decodeIfPresent(Scale.Team.self, forKey: .teams)

            if let correctedString = try? container.decode(String.self, forKey: .correcteds) {
                self.correcteds = .string(correctedString)
            }
            else if let userList = try? container.decode([Scale.User].self, forKey: .correcteds) {
                self.correcteds = .userList(userList)
            }
            else {
                self.correcteds = nil
            }

            if let correctorString = try? container.decode(String.self, forKey: .corrector) {
                self.corrector = .string(correctorString)
            }
            else if let user = try? container.decode(Scale.User.self, forKey: .corrector) {
                self.corrector = .user(user)
            }
            else {
                self.corrector = nil
            }
        }

        // MARK: - Types

        enum CorrectedsType: Codable {
            case string(String)
            case userList([Scale.User])
        }

        enum CorrectorType: Codable {
            case string(String)
            case user(Scale.User)
        }

        struct User: Codable, Identifiable {
            let id: Int
            let login: String
        }

        struct Details: Codable, Identifiable {
            let id: Int
            let correctionNumber: Int
            let duration: Int
        }

        struct Team: Codable, Identifiable {
            let id: Int
            let name: String
            let projectId: Int
            let status: String
            let users: [Self.User]
            let locked: Bool
            let validated: Bool?
            let closed: Bool
            let lockedAt: Date?
            let closedAt: Date?

            struct User: Codable, Identifiable {
                let id: Int
                let login: String
                let leader: Bool
            }

            private enum CodingKeys: String, CodingKey {
                case id, name, projectId, status, users, lockedAt, closedAt
                case locked = "locked?"
                case validated = "validated?"
                case closed = "closed?"
            }
        }
    }

}
