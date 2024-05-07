//
//  Api+OAuthEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

extension Api {
    
    /// Defines various specific endpoints used for OAuth operations, such as user and application authentication, and access token management.
    enum OAuthEndpoints: Endpoint {
        /// Used to obtain initial authorisation from the user.
        case authorize
        
        /// Used to obtain a user access token from an authorisation code obtained after the user has granted authorisation.
        case fetchUserAccessToken(code: String)
        
        /// Used to obtain an access token at application level, generally used for operations that do not involve a specific user.
        case fetchApplicationAccessToken
        
        /// Used to refresh a user's access token with a refresh token, allowing the user's session to be extended without the need to re-authenticate.
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
