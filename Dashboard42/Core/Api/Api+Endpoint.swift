//
//  Api+Endpoint.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

extension Api {
    
    /// A type that can make a request to the API.
    protocol Endpoint {
        /// The domain of the API.
        var host: String { get }
        
        /// The type of authorization required for the request.
        var authorization: EndpointAuthorizationType { get }
        
        /// The API path on which to submit the request.
        var path: String { get }
        
        /// The query options.
        var queryItems: [String: String]? { get }
        
        /// The final URL is the access point to the API on which to make the request.
        var url: URL? { get }
    }
    
    /// An object representing the different authorization types for the API request.
    enum EndpointAuthorizationType: Encodable {
        case user
        case application
    }
    
}
