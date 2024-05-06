//
//  AuthService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

final class AuthService {

    func signIn(using url: URL) async throws {
        let queryItems: [URLQueryItem]? = URLComponents(string: url.absoluteString)?.queryItems

        guard let code: String = queryItems?.first(where: { $0.name == "code" })?.value else {
            throw Api.Errors.invalidUrl
        }

        let userToken = try await Api.shared.post(
            Api.OAuthEndpoints.fetchUserAccessToken(code: code),
            type: Api.OAuthUser.self
        )
        let applicationToken = try await Api.shared.post(
            Api.OAuthEndpoints.fetchApplicationAccessToken,
            type: Api.OAuthApplication.self
        )

        Constants.Api.userAccessToken = userToken.accessToken
        Constants.Api.userRefreshToken = userToken.refreshToken
        Constants.Api.applicationAccessToken = applicationToken.accessToken
    }

    func logout() {
    }

}
