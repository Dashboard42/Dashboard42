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
        /// The access token used to authenticate API requests on behalf of the user.
        let accessToken: String
        
        /// A token used to obtain a new access token once the current access token has expired.
        let refreshToken: String
    }

}
