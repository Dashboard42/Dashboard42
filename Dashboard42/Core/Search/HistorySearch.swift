//
//  HistorySearch.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 15/05/2024.
//

import SwiftData
import SwiftUI

@Model
final class HistorySearch {

    // MARK: - Properties

    let login: String
    let email: String
    let image: String

    // MARK: - Initiliser

    init(login: String, email: String, image: String) {
        self.login = login
        self.email = email
        self.image = image
    }

}
