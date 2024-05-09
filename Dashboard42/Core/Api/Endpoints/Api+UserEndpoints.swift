//
//  Api+UserEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 09/05/2024.
//

import Foundation

extension Api {

    /// Defines various specific endpoints used for User operations.
    enum UserEndpoints: Endpoint {
        /// Used to obtain the current connected user.
        case fetchConnectedUser

        /// Used to obtain a specific user with their id.
        case fetchUserById(id: Int)

        /// Used to obtain a specific user with their login.
        case fetchUserByLogin(login: String)

        var host: String { "api.intra.42.fr" }
        var authorization: EndpointAuthorizationType { .user }

        var path: String {
            switch self {
            case .fetchConnectedUser:
                "/v2/me"
            case .fetchUserById(let id):
                "/v2/users/\(id)"
            case .fetchUserByLogin(let login):
                "/v2/users/\(login)"
            }
        }

        var queryItems: [String: String]? { [:] }

        var url: URL? {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = host
            urlComponents.path = path
            urlComponents.queryItems = [URLQueryItem]()

            return urlComponents.url
        }
    }

}
