//
//  Api+EventUser.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

extension Api {

    /// Represents data relating to an deleted event.
    struct EventUser: Decodable, Identifiable {
        let id: Int
        let eventId: Int
        let userId: Int
    }

}
