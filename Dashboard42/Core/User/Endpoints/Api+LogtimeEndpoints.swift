//
//  Api+LogtimeEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 11/05/2024.
//

import Foundation

extension Api {

    /// Manages different API routes (endpoints) linked to user logtime.
    enum LogtimeEndpoints: Endpoint {
        case fetchLogtime(login: String, entryDate: String)

        var host: String { "api.intra.42.fr" }
        var authorization: Api.EndpointAuthorizationType { .application }

        var path: String {
            switch self {
            case .fetchLogtime(let login, _):
                "/v2/users/\(login)/locations_stats"
            }
        }

        var queryItems: [String: String]? {
            switch self {
            case .fetchLogtime(let login, let entryDate):
                ["begin_at": entryDate]
            }
        }

        var url: URL? {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = host
            urlComponents.path = path

            var requestQueryItems = [URLQueryItem]()

            queryItems?.forEach { item in
                requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
            }

            urlComponents.queryItems = requestQueryItems

            return urlComponents.url
        }
    }

}
