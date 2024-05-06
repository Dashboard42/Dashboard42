//
//  Api+OAuthEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

extension Api {

    enum OAuthEndpoints: Endpoint {
        case authorize
        case fetchUserAccessToken(code: String)
        case fetchApplicationAccessToken
        case updateUserAccessToken(refreshToken: String)

        var host: String { "api.intra.42.fr" }
        var authorization: EndpointAuthorizationType { .user }

        var path: String {
            switch self {
            case .authorize:
                return "/oauth/authorize"
            case .fetchUserAccessToken:
                return "/oauth/token"
            case .fetchApplicationAccessToken:
                return "/oauth/token"
            case .updateUserAccessToken:
                return "/oauth/token"
            }
        }

        var queryItems: [String: String]? {
            switch self {
            case .authorize:
                return [
                    "client_id": "",
                    "redirect_uri": "",
                    "response_type": "code",
                    "scope": "public+projects+profile",
                ]
            case .fetchUserAccessToken(let code):
                return [
                    "grant_type": "authorization_code",
                    "client_id": "",
                    "client_secret": "",
                    "code": code,
                    "redirect_uri": "",
                ]
            case .fetchApplicationAccessToken:
                return [
                    "grant_type": "client_credentials",
                    "client_id": "",
                    "client_secret": "",
                    "scope": "public+projects+profile",
                ]
            case .updateUserAccessToken(let refreshToken):
                return [
                    "grant_type": "refresh_token",
                    "client_id": "",
                    "client_secret": "",
                    "refresh_token": refreshToken,
                    "redirect_uri": "",
                ]
            }
        }

        var url: URL? {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = host
            urlComponents.path = path

            var requestQueryItems = [URLQueryItem]()

            for item in queryItems ?? [:] {
                requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
            }
            urlComponents.queryItems = requestQueryItems

            return urlComponents.url
        }
    }

}
