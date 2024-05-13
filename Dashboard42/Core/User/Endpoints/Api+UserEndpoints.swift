//
//  Api+UserEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 09/05/2024.
//

import Foundation

extension Api {

    /// Manages different API routes (endpoints) linked to users.
    enum UserEndpoints: Endpoint {
        case fetchConnectedUser
        case fetchUserById(id: Int)
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
