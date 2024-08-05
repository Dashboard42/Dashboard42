//
//  AuthUser.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/08/2024.
//

import Foundation

struct AuthUser {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: String
    let createdAt: Int
}

extension AuthUser: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope
        case createdAt = "created_at"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
        self.tokenType = try container.decode(String.self, forKey: .tokenType)
        self.expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        self.scope = try container.decode(String.self, forKey: .scope)
        self.createdAt = try container.decode(Int.self, forKey: .createdAt)
    }

    /// Encodes the user's authentication key into the given encoder.
    ///
    /// This function throws an error if any values are invalid for the given encoder’s format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.accessToken, forKey: .accessToken)
        try container.encode(self.refreshToken, forKey: .refreshToken)
        try container.encode(self.tokenType, forKey: .tokenType)
        try container.encode(self.expiresIn, forKey: .expiresIn)
        try container.encode(self.scope, forKey: .scope)
        try container.encode(self.createdAt, forKey: .createdAt)
    }
}
