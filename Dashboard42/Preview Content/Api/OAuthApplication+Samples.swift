//
//  OAuthApplication+Samples.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 08/05/2024.
//

import Foundation

extension Api.OAuthApplication {
    static let sample = Api.OAuthApplication(accessToken: UUID().uuidString)
}

extension [Api.OAuthApplication] {
    static let sample = [
        Api.OAuthApplication(accessToken: UUID().uuidString),
        Api.OAuthApplication(accessToken: UUID().uuidString),
        Api.OAuthApplication(accessToken: UUID().uuidString),
    ]
}
