//
//  Network.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/08/2024.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation
@preconcurrency import OSLog

final class Network: Sendable {

    private let session: URLSession
    private let decoder: JSONDecoder
    private let logger: Logger

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
        self.logger = Logger(subsystem: "fr.marcmosca.Dashboard42", category: "Network")
    }

    func request<T: Decodable>(for req: HTTPRequest) async throws -> T {
        let (data, response): (Data, HTTPResponse)

        (data, response) = try await self.session.upload(for: req, from: Data())

        do {
            try await self.handleHTTPResponse(request: req, response: response)
        }
        catch Dashboard42Errors.unauthorized, Dashboard42Errors.tooManyRequests {
            return try await self.request(for: req)
        }
        catch let error {
            throw error
        }

        return try self.decoder.decode(T.self, from: data)
    }

    func request(for req: HTTPRequest) async throws {
        let (_, response): (Data, HTTPResponse)

        (_, response) = try await self.session.upload(for: req, from: Data())

        do {
            try await self.handleHTTPResponse(request: req, response: response)
        }
        catch Dashboard42Errors.unauthorized, Dashboard42Errors.tooManyRequests {
            try await self.request(for: req)
        }
        catch let error {
            throw error
        }
    }

    private func handleHTTPResponse(request: HTTPRequest, response: HTTPResponse) async throws {
        let method: String
        let statusCode: Int
        let path: String

        method = request.method.rawValue.uppercased()
        statusCode = response.status.code
        path = request.path ?? "No path found for the request"

        switch response.status {
        case .ok, .created, .accepted:
            self.logger.info("✅ [\(statusCode)] [\(method)] \(path, privacy: .private).")
            return
        case .unauthorized:
            self.logger.error("🛑 [\(statusCode)] [\(method)] \(path, privacy: .private) - Unauthorized.")
            throw Dashboard42Errors.unauthorized
        case .tooManyRequests:
            self.logger.error("🛑 [\(statusCode)] [\(method)] \(path, privacy: .private) - Too Many Requests.")
            try await Task.sleep(for: .seconds(1))
            throw Dashboard42Errors.tooManyRequests
        default:
            self.logger.error("🛑 [\(statusCode)] [\(method)] \(path, privacy: .private) - Invalid Server Response.")
            throw Dashboard42Errors.invalidServerResponse
        }
    }

}
