//
//  Api+ExamEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

extension Api {

    /// Manages different API routes (endpoints) linked to exams.
    enum ExamEndpoints: Endpoint {
        case fetchCampusExams(campusId: Int)
        case fetchUserExams(userId: Int)

        var host: String { "api.intra.42.fr" }
        var authorization: Api.EndpointAuthorizationType { .application }

        var path: String {
            switch self {
            case .fetchCampusExams(let campusId):
                "/v2/campus/\(campusId)/exams"
            case .fetchUserExams(let userId):
                "/v2/users/\(userId)/exams"
            }
        }

        var queryItems: [String: String]? { ["filter[future]": "true", "sort": "-begin_at"] }

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
