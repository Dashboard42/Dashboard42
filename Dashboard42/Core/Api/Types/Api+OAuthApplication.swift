//
//  Api+OAuthApplication.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

extension Api {

    /// Defined to encapsulate data specific to an OAuth response for an application.
    struct OAuthApplication: Decodable {
        /// Contains the access token used to authenticate requests to an API.
        /// This token is essential for accessing resources that require authorisation at application level.
        let accessToken: String
    }

}
