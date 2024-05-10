//
//  Api+EventEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

extension Api {

    /// Manages different API routes (endpoints) linked to events.
    enum EventEndpoints: Endpoint {
        case fetchCampusEvents(campusId: Int, cursusId: Int)
        case fetchUserEvents(userId: Int)
        case fetchEventUserId(userId: Int, eventId: Int)
        case updateUserEvent(userId: Int, eventId: Int)
        case deleteUserEvent(eventUserId: Int)

        var host: String { "api.intra.42.fr" }
        var authorization: Api.EndpointAuthorizationType { .user }

        var path: String {
            switch self {
            case .fetchCampusEvents(let campusId, let cursusId):
                "/v2/campus/\(campusId)/cursus/\(cursusId)/events"
            case .fetchUserEvents(let userId):
                "/v2/users/\(userId)/events"
            case .fetchEventUserId(let userId, _):
                "/v2/users/\(userId)/events_users"
            case .updateUserEvent:
                "/v2/events_users"
            case .deleteUserEvent(let eventUserId):
                "/v2/events_users/\(eventUserId)"
            }
        }

        var queryItems: [String: String]? {
            switch self {
            case .fetchCampusEvents:
                ["filter[future]": "true", "sort": "begin_at", "page[size]": "100"]
            case .fetchUserEvents:
                ["sort": "-begin_at", "page[size]": "100"]
            case .fetchEventUserId(_, let eventId):
                ["filter[event_id]": "\(eventId)"]
            case .updateUserEvent(let userId, let eventId):
                ["events_user[event_id]": "\(eventId)", "events_user[user_id]": "\(userId)"]
            case .deleteUserEvent:
                [:]
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
