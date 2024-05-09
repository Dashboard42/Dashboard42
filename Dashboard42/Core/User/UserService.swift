//
//  UserService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 08/05/2024.
//

import Foundation

/// Encapsulates functionality for interacting with user-related APIs.
final class UserService {

    /// Retrieves the information of the connected user using the endpoint dedicated for this purpose.
    /// - Returns: An instance of `Api.User` representing the logged-in user.
    func fetchUser() async throws -> Api.User {
        let endpoint = Api.UserEndpoints.fetchConnectedUser
        return try await Api.shared.fetch(endpoint, type: Api.User.self)
    }

    /// Retrieves information about a specific user using its identifier.
    /// - Parameter id: The unique identifier of the user to be retrieved.
    /// - Returns: An instance of `Api.User` representing the user being searched for.
    func fetchUser(id: Int) async throws -> Api.User {
        let endpoint = Api.UserEndpoints.fetchUserById(id: id)
        return try await Api.shared.fetch(endpoint, type: Api.User.self)
    }

    /// Retrieves information about a user based on their username (login).
    /// - Parameter login: The username of the individual to retrieve.
    /// - Returns: An instance of `Api.User` representing the searched user.
    func fetchUser(login: String) async throws -> Api.User {
        let endpoint = Api.UserEndpoints.fetchUserByLogin(login: login)
        return try await Api.shared.fetch(endpoint, type: Api.User.self)
    }

}
