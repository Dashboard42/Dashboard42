//
//  AuthService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/08/2024.
//

import Foundation

final class AuthService: Sendable {

    private let network: Network

    init(network: Network) {
        self.network = network
    }

    func signIn(using url: URL) async throws {
        let queryItems: [URLQueryItem]?
        let userTokens: AuthUser

        queryItems = URLComponents(string: url.absoluteString)?.queryItems

        guard let code = queryItems?.first(where: { $0.name == "code" })?.value else {
            throw Dashboard42Errors.unknow(NSError())
        }

        userTokens = try await self.network.request(for: AuthEndpoints.fetchUserAccessToken(code: code).request)
        print(userTokens)
    }

    func logout() {
    }

}
