//
//  Api.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation
import OSLog

/// Encapsulates the network request management logic for an application.
/// It provides methods for performing various HTTP requests such as GET, POST, UPDATE, and DELETE.
/// It also manages the decoding of responses, the automatic resumption of requests in the event of specific errors, and the management of network errors.
final class Api {

    // MARK: - Properties

    /// Singleton instance of the `Api` class, allowing global and unique access to its functionality.
    static let shared = Api()

    private var failedQueryAttemps = 0
    private let decoder = JSONDecoder()
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

    /// Makes HTTP GET requests and retrieving decoded data in a specified type that conforms to the `Decodable` protocol.
    /// - Parameters:
    ///   - endpoint: An `Endpoint` structure or object which encapsulates the details of the URL and authorisation type.
    ///   - type: The `Decodable` type of data model expected in response. This is used to specify the type of data you want to obtain after decoding.
    /// - Returns: Returns an instance of type `T`, decoded from the HTTP response data.
    func fetch<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws -> T {
        try await request(endpoint: endpoint, methodType: "GET", type: type)
    }

    /// Makes HTTP POST requests with no direct management of response data, apart from error handling and request validation.
    /// - Parameter endpoint: An `Endpoint` structure or object which encapsulates the details of the URL and authorisation type.
    func post(_ endpoint: Endpoint) async throws {
        try await request(endpoint: endpoint, methodType: "POST")
    }

    /// Makes HTTP POST requests and retrieving decoded data in a specified type that conforms to the `Decodable` protocol.
    /// - Parameters:
    ///   - endpoint: An `Endpoint` structure or object which encapsulates the details of the URL and authorisation type.
    ///   - type: The `Decodable` type of data model expected in response. This is used to specify the type of data you want to obtain after decoding.
    /// - Returns: Returns an instance of type `T`, decoded from the HTTP response data.
    func post<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws -> T {
        try await request(endpoint: endpoint, methodType: "POST", type: type)
    }

    /// Makes HTTP UPDATE requests with no direct management of response data, apart from error handling and request validation.
    /// - Parameter endpoint: An `Endpoint` structure or object which encapsulates the details of the URL and authorisation type.
    func update(_ endpoint: Endpoint) async throws {
        try await request(endpoint: endpoint, methodType: "UPDATE")
    }

    /// Makes HTTP DELETE requests with no direct management of response data, apart from error handling and request validation.
    /// - Parameter endpoint: An `Endpoint` structure or object which encapsulates the details of the URL and authorisation type.
    func delete(_ endpoint: Endpoint) async throws {
        try await request(endpoint: endpoint, methodType: "DELETE")
    }

    // MARK: - Private Methods

    /// Makes asynchronous HTTP requests to a specified endpoint and decodes the response into a specified `Decodable` type.
    /// It also automatically handles retries in the event of specific errors such as access problems or rate limiting.
    /// - Parameters:
    ///   - endpoint: An `Endpoint` structure or object which encapsulates the details of the URL and authorisation type.
    ///   - methodType: The HTTP method to be used for the request, for example "GET", "POST", etc.
    ///   - type: The `Decodable` type of data model expected in response. This is used to specify the type of data you want to obtain after decoding.
    /// - Returns: Returns an instance of type `T`, decoded from the HTTP response data.
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

    /// Makes asynchronous HTTP requests to a specified endpoint. It also automatically handles retries in the event of specific errors such as access problems or rate limiting.
    /// - Parameters:
    ///   - endpoint: An `Endpoint` structure or object which encapsulates the details of the URL and authorisation type.
    ///   - methodType: The HTTP method to be used for the request, for example "GET", "POST", etc.
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

    /// Creates and configures an instance of `URLRequest` based on the parameters supplied.
    /// It is used to prepare a network request with appropriate authentication information.
    /// - Parameters:
    ///   - url: The target URL for the HTTP request.
    ///   - methodType: The HTTP method to be used for the request, for example "GET", "POST", etc.
    ///   - authorization: The type of authorisation required for the endpoint.
    /// - Returns: A configured instance of `URLRequest` ready to be used to execute a network request.
    private func buildRequest(url: URL, methodType: String, authorization: EndpointAuthorizationType) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = methodType

        if let token = authorization == .application
            ? Constants.Api.applicationAccessToken : Constants.Api.userAccessToken
        {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    /// Analyses and manages HTTP responses received after network requests have been sent, taking specific actions based on the HTTP status code returned.
    /// It also manages attempts to recover access tokens in the event of an authentication error.
    /// - Parameters:
    ///   - request: The HTTP request that was sent, used for detailed logs and error handling.
    ///   - response: The response received from the server. This response must be an instance of `HTTPURLResponse` in order to process HTTP status codes.
    ///   - authorization: Type of authorisation used for the initial request, important for managing access tokens.
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
                guard let refreshToken = Constants.Api.userRefreshToken else { throw Errors.invalidAccessToken }
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
