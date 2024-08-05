//
//  QueryItems.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/08/2024.
//

import Foundation

func joinedQueryItemsToPath(path: String, queryItems: [String: String]) -> String {
    let queryItemsJoined = queryItems.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
    return path + "?\(queryItemsJoined)"
}
