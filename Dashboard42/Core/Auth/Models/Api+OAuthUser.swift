//
//  Api+OAuthUser.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

extension Api {

    /// Capture and manage the access and refresh tokens obtained during user authentication via OAuth.
    struct OAuthUser: Decodable {
        let accessToken: String
        let refreshToken: String
    }

}
