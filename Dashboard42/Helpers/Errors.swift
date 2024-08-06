//
//  Errors.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/08/2024.
//

import Foundation

enum Dashboard42Errors: Error {
    case configurationMissingKey
    case configurationInvalidValue

    case corruptAccessToken
    case tooManyRequests
    case unauthorized
    case invalidServerResponse

    case unknow(Error)
}
