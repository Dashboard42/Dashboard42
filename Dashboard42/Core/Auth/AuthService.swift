//
//  AuthService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

/// Manages the user authentication process.
final class AuthService {

    /// Manages the process of logging in a user using a URL that contains an OAuth authentication code.
    /// This function extracts the authorisation code from the URL, then uses it to obtain both a user access token and an application access token using the corresponding OAuth endpoints.
    /// - Parameter url: The URL containing the authorisation code returned after the user has authorised the application.
    func signIn(using url: URL) async throws {
        let queryItems = URLComponents(string: url.absoluteString)?.queryItems

        guard let code = queryItems?.first(where: { $0.name == "code" })?.value else {
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
        KeychainManager.shared.clear()
        UserDefaults.standard.removeObject(forKey: Constants.AppStorage.userIsConnected)
    }

}
