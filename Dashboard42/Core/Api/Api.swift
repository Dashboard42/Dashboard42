//
//  Api.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation
import OSLog

/// An object that coordinates API-related tasks.
final class Api {

    // MARK: - Properties

    /// The shared singleton api object.
    static let shared = Api()

    /// The number of failed query attempts.
    private var failedQueryAttemps = 0

    /// An object used to decode the data received from the API.
    private let decoder = JSONDecoder()

    /// An object used to display the final status of the request in the console.
    private let logger = Logger(subsystem: "Dashboard42", category: "API")

    // MARK: - Initializers

    private init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
    }

    // MARK: - Public Methods

    /// A method for executing GET requests to the API and return received data.
    /// - Parameters:
    ///   - endpoint: The access point on which the request is made.
    ///   - type: The type corresponding to the object expected in return in the case of a valid request.
    /// - Returns: Returns data received from the API converted into a T-type object.
    func fetch<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws -> T {
        try await request(endpoint: endpoint, methodType: "GET", type: type)
    }

    /// A method for executing POST requests to the API.
    /// - Parameter endpoint: The access point on which the request is made.
    func post(_ endpoint: Endpoint) async throws {
        try await request(endpoint: endpoint, methodType: "POST")
    }

    /// A method for executing POST requests to the API.
    /// - Parameters:
    ///   - endpoint: The access point on which the request is made.
    ///   - type: The type corresponding to the object expected in return in the case of a valid request.
    /// - Returns: Returns data received from the API converted into a T-type object.
    func post<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws -> T {
        try await request(endpoint: endpoint, methodType: "POST", type: type)
    }

    /// A method for executing UPDATE requests to the API.
    /// - Parameter endpoint: The access point on which the request is made.
    func update(_ endpoint: Endpoint) async throws {
        try await request(endpoint: endpoint, methodType: "UPDATE")
    }

    /// A method for executing DELETE requests to the API.
    /// - Parameter endpoint: The access point on which the request is made.
    func delete(_ endpoint: Endpoint) async throws {
        try await request(endpoint: endpoint, methodType: "DELETE")
    }

    // MARK: - Private Methods

    private func request<T: Decodable>(endpoint: Endpoint, methodType: String, type: T.Type) async throws -> T {
        guard let url = endpoint.url else { throw Errors.invalidUrl }

        let request = buildRequest(url: url, methodType: methodType, authorization: endpoint.authorization)
        let (data, response) = try await URLSession.shared.data(for: request)

        do {
            try await handleURLResponse(request: request, response: response, authorization: endpoint.authorization)
        }
        catch Errors.invalidAccessToken {
            return try await self.request(endpoint: endpoint, methodType: methodType, type: T.self)
        }
        catch Errors.tooManyRequests {
            return try await self.request(endpoint: endpoint, methodType: methodType, type: T.self)
        }
        catch {
            throw error
        }

        return try decoder.decode(T.self, from: data)
    }

    private func request(endpoint: Endpoint, methodType: String) async throws {
        guard let url = endpoint.url else { throw Errors.invalidUrl }

        let request = buildRequest(url: url, methodType: methodType, authorization: endpoint.authorization)
        let (_, response) = try await URLSession.shared.data(for: request)

        do {
            try await handleURLResponse(request: request, response: response, authorization: endpoint.authorization)
        }
        catch Errors.invalidAccessToken {
            try await self.request(endpoint: endpoint, methodType: methodType)
        }
        catch Errors.tooManyRequests {
            try await self.request(endpoint: endpoint, methodType: methodType)
        }
        catch {
            throw error
        }
    }

    // MARK: - Private Helpers

    private func buildRequest(url: URL, methodType: String, authorization: EndpointAuthorizationType) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = methodType

        if let token = authorization == .application
            ? Constants.Api.APPLICATION_ACCESS_TOKEN : Constants.Api.USER_ACCESS_TOKEN
        {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func handleURLResponse(request: URLRequest, response: URLResponse, authorization: EndpointAuthorizationType)
        async throws
    {
        guard let response = response as? HTTPURLResponse else { throw Errors.invalidServerResponse }
        guard failedQueryAttemps <= 10 else { throw Errors.corruptAccessToken }

        let httpMethod = request.httpMethod ?? "Undefined"
        let statusCode = response.statusCode

        switch statusCode {
        case 200..<300:
            logger.info("✅ [\(statusCode)] [\(httpMethod)] \(request, privacy: .private) - Request successful.")
        case 401:
            failedQueryAttemps += 1
            logger.error("🛑 [\(statusCode)] [\(httpMethod)] \(request, privacy: .private) - Access token expired.")

            if authorization == .application {
                let endpoint = Api.OAuthEndpoints.fetchApplicationAccessToken
                let token = try await post(endpoint, type: Api.OAuthApplication.self)
                try KeychainManager.shared.save(account: .applicationAccessToken, data: token.accessToken)
            }
            else {
                guard let refreshToken = Constants.Api.USER_REFRESH_TOKEN else { throw Errors.invalidAccessToken }
                let endpoint = Api.OAuthEndpoints.updateUserAccessToken(refreshToken: refreshToken)
                let token = try await post(endpoint, type: Api.OAuthUser.self)
                try KeychainManager.shared.save(account: .userAccessToken, data: token.accessToken)
                try KeychainManager.shared.save(account: .userRefreshToken, data: token.refreshToken)
            }

            throw Errors.invalidAccessToken
        case 429:
            logger.error("🛑 [\(statusCode)] [\(httpMethod)] \(request, privacy: .private) - Too many requests.")
            try await Task.sleep(for: .seconds(1))
            throw Errors.tooManyRequests
        default:
            logger.error("🛑 [\(statusCode)] [\(httpMethod)] \(request, privacy: .private) - Invalid server response.")
            throw Errors.invalidServerResponse
        }
    }

}
