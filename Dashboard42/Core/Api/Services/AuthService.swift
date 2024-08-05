//
//  AuthService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/08/2024.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation

final class AuthService: Sendable {

    func signIn(using url: URL) async throws {
        let queryItems = URLComponents(string: url.absoluteString)?.queryItems

        guard let code = queryItems?.first(where: { $0.name == "code" })?.value else {
            throw NSError()
        }

        let userTokenRequest = AuthEndpoints.fetchUserAccessToken(code: code).request
        let (body, response) = try await URLSession.shared.upload(for: userTokenRequest, from: Data())

        guard response.status == .ok else {
            throw Dashboard42Errors.invalidNetworkResponse
        }

        do {
            let data = try JSONDecoder().decode(AuthUser.self, from: body)
            print(data)
        }
        catch let error {
            throw Dashboard42Errors.invalidNetworkDecodingResponse
        }
    }

    func logout() {
    }

}
