//
//  Api+Endpoint.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

extension Api {
    
    /// Defines an interface for configuring the details required to construct a network request URL within the `Api` class.
    /// Objects conforming to this protocol provide all the information required to configure the components of a URL, including host, path, request parameters and authorisation type.
    protocol Endpoint {
        /// Host address for the URL. This represents the root of the domain to which requests will be sent.
        var host: String { get }
        
        /// The type of authorisation required to access the endpoint.
        /// This type determines how authorisation is managed, for example, using specific application or user tokens.
        var authorization: EndpointAuthorizationType { get }
        
        /// The specific API path for the endpoint. This path is appended to the host to form the full URL of the request.
        var path: String { get }
        
        /// Dictionary of keys and values that will be transformed into request components for the URL.
        /// These elements are used to provide additional parameters to the HTTP request.
        var queryItems: [String: String]? { get }
        
        /// The full URL using the `host`, `path`, and `queryItems` properties.
        /// Returns `nil` if the URL cannot be constructed correctly.
        var url: URL? { get }
    }
    
    /// Specifies the types of authorisation that may be required to access different endpoints in an application.
    /// This distinction makes it possible to manage different types of access, such as that reserved for authenticated users or that dedicated to applications.
    enum EndpointAuthorizationType: Encodable {
        /// Indicates that the endpoint requires authorisation at user level.
        /// This involves the use of user-specific access tokens, which validate the user's identity and privileges for the current request.
        case user
        
        /// Means that the endpoint requires authorisation at application level.
        /// This type of authorisation uses tokens which are generally less specific to an individual user and are used to authenticate the application itself to the service.
        case application
    }

}
