//
//  Api+OAuthUser.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

extension Api {

    /// An object representing a user's API access keys.
    struct OAuthUser: Decodable {
        let accessToken: String
        let refreshToken: String
    }

}
