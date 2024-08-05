//
//  HTTPTypes+HTTPRequest.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/08/2024.
//

import Foundation
import HTTPTypes

extension HTTPRequest {

    init(method: HTTPRequest.Method, path: String) {
        self.init(method: method, scheme: "https", authority: "api.intra.42.fr", path: path)
    }

}
