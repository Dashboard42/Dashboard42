//
//  Api+Slot.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

extension Api {

    /// Represents data relating to a evaluation slot.
    struct Slot: Codable, Identifiable {
        let id: Int
        let beginAt: Date
        let endAt: Date
        let scaleTeam: TeamType?
        let user: User

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.beginAt = try container.decode(Date.self, forKey: .beginAt)
            self.endAt = try container.decode(Date.self, forKey: .endAt)
            self.user = try container.decode(User.self, forKey: .user)

            if let scaleTeamString = try? container.decode(String.self, forKey: .scaleTeam) {
                self.scaleTeam = .string(scaleTeamString)
            }
            else if let team = try? container.decode([ScaleTeam].self, forKey: .scaleTeam) {
                self.scaleTeam = .team(team)
            }
            else {
                self.scaleTeam = nil
            }
        }

        // MARK: - Types

        enum TeamType: Codable {
            case string(String)
            case team([ScaleTeam])
        }

        struct User: Codable, Identifiable {
            let id: Int
            let login: String
        }

        struct ScaleTeam: Codable, Identifiable {
            let id: Int
            let scaleId: Int
            let beginAt: Date
            let correcteds: [Slot.User]
            let corrector: Slot.User
        }
    }

}
