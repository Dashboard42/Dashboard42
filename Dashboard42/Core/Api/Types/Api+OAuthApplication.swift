//
//  Api+OAuthApplication.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

extension Api {
    
    /// An object representing the application's API access keys.
    struct OAuthApplication: Decodable {
        let accessToken: String
    }
    
}
