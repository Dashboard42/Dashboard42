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
        let accessToken: String
    }

}
