//
//  Api+Event.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

extension Api {

    /// Represents data relating to an event.
    struct Event: Decodable, Identifiable {
        let id: Int
        let name: String
        let description: String
        let location: String
        let kind: String
        let maxPeople: Int?
        let nbrSubscribers: Int
        let beginAt: Date
        let endAt: Date

        var isInFuture: Bool { beginAt > .now }
        var beginAtFormatted: String { beginAt.formatted(.dateTime.year().month(.wide)) }

        var numberOfSubscribers: String {
            guard let maxPeople = maxPeople else { return nbrSubscribers.formatted() }
            return "\(nbrSubscribers) / \(maxPeople)"
        }

        var hasWaitlist: Bool {
            guard let maxPeople = maxPeople else { return false }
            return nbrSubscribers > maxPeople
        }
    }

}
