//
//  OAuthUser+Samples.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 08/05/2024.
//

import Foundation

extension Api.OAuthUser {
    static let sample = Api.OAuthUser(accessToken: UUID().uuidString, refreshToken: UUID().uuidString)
}

extension [Api.OAuthUser] {
    static let sample = [
        Api.OAuthUser(accessToken: UUID().uuidString, refreshToken: UUID().uuidString),
        Api.OAuthUser(accessToken: UUID().uuidString, refreshToken: UUID().uuidString),
        Api.OAuthUser(accessToken: UUID().uuidString, refreshToken: UUID().uuidString),
    ]
}
