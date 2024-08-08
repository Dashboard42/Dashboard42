//
//  AuthEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/08/2024.
//

import Foundation
import HTTPTypes

enum AuthEndpoints {
    case authorize
    case fetchUserAccessToken(code: String)
    case fetchApplicationAccessToken
    case updateUserAccessToken(refreshToken: String)

    private var method: HTTPRequest.Method {
        return .post
    }

    private var queryItems: [String: String] {
        switch self {
        case .authorize:
            return [
                "client_id": Constant.clientId, "redirect_uri": Constant.redirectUri, "response_type": "code",
                "scope": "public+projects+profile",
            ]
        case .fetchUserAccessToken(let code):
            return [
                "grant_type": "authorization_code", "client_id": Constant.clientId,
                "client_secret": Constant.clientSecret, "code": code, "redirect_uri": Constant.redirectUri,
            ]
        case .fetchApplicationAccessToken:
            return [
                "grant_type": "client_credentials", "client_id": Constant.clientId,
                "client_secret": Constant.clientSecret, "scope": "public+projects+profile",
            ]
        case .updateUserAccessToken(let refreshToken):
            return [
                "grant_type": "refresh_token", "client_id": Constant.clientId, "client_secret": Constant.clientSecret,
                "refresh_token": refreshToken, "redirect_uri": Constant.redirectUri,
            ]
        }
    }

    private var path: String {
        switch self {
        case .authorize:
            return "/oauth/authorize"
        case .fetchUserAccessToken, .fetchApplicationAccessToken, .updateUserAccessToken:
            return "/oauth/token"
        }
    }

    var request: HTTPRequest {
        .init(method: self.method, path: joinedQueryItemsToPath(path: self.path, queryItems: self.queryItems))
    }
}
