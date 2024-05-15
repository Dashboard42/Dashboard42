//
//  Api+CorrectionEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

extension Api {

    /// Manages different API routes (endpoints) linked to corrections.
    enum CorrectionEndpoints: Endpoint {
        case fetchCorrectionPointHistorics(userId: Int)
        case fetchUserScales
        case fetchUserSlots
        case createUserSlot(userId: Int, beginAt: Date, endAt: Date)
        case deleteUserSlot(slotId: Int)

        var host: String { "api.intra.42.fr" }
        var authorization: Api.EndpointAuthorizationType { .user }

        var path: String {
            switch self {
            case .fetchCorrectionPointHistorics(let userId):
                "/v2/users/\(userId)/correction_point_historics"
            case .fetchUserScales:
                "/v2/me/scale_teams"
            case .fetchUserSlots:
                "/v2/me/slots"
            case .createUserSlot:
                "/v2/slots"
            case .deleteUserSlot(let slotId):
                "/v2/slots/\(slotId)"
            }
        }

        var queryItems: [String: String]? {
            switch self {
            case .fetchCorrectionPointHistorics:
                ["sort": "-created_at"]
            case .fetchUserScales:
                ["sort": "-begin_at", "page[size]": "100"]
            case .fetchUserSlots:
                ["filter[future]": "true", "sort": "-begin_at", "page[size]": "100"]
            case .createUserSlot(let userId, let beginAt, let endAt):
                ["slot[user_id]": "\(userId)", "slot[begin_at]": "\(beginAt)", "slot[end_at]": "\(endAt)"]
            case .deleteUserSlot:
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
