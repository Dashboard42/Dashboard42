//
//  Api+OAuthEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

extension Api {

    /// Manages different API routes (endpoints) linked to oauth.
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
                "/oauth/authorize"
            case .fetchUserAccessToken:
                "/oauth/token"
            case .fetchApplicationAccessToken:
                "/oauth/token"
            case .updateUserAccessToken:
                "/oauth/token"
            }
        }

        var queryItems: [String: String]? {
            switch self {
            case .authorize:
                [
                    "client_id": Constants.Api.clientId,
                    "redirect_uri": Constants.Api.redirectUri,
                    "response_type": "code",
                    "scope": "public+projects+profile",
                ]
            case .fetchUserAccessToken(let code):
                [
                    "grant_type": "authorization_code",
                    "client_id": Constants.Api.clientId,
                    "client_secret": Constants.Api.clientSecret,
                    "code": code,
                    "redirect_uri": Constants.Api.redirectUri,
                ]
            case .fetchApplicationAccessToken:
                [
                    "grant_type": "client_credentials",
                    "client_id": Constants.Api.clientId,
                    "client_secret": Constants.Api.clientSecret,
                    "scope": "public+projects+profile",
                ]
            case .updateUserAccessToken(let refreshToken):
                [
                    "grant_type": "refresh_token",
                    "client_id": Constants.Api.clientId,
                    "client_secret": Constants.Api.clientSecret,
                    "refresh_token": refreshToken,
                    "redirect_uri": Constants.Api.redirectUri,
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
