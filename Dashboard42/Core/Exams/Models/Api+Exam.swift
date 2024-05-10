//
//  Api+Exam.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

extension Api {

    /// Represents data relating to an exam.
    struct Exam: Decodable, Identifiable {
        let id: Int
        let beginAt: Date
        let endAt: Date
        let location: String
        let maxPeople: Int?
        let nbrSubscribers: Int
        let name: String
        let projects: [Exam.Projects]

        var numberOfSubscribers: String {
            guard let maxPeople = maxPeople else { return nbrSubscribers.formatted() }
            return "\(nbrSubscribers) / \(maxPeople)"
        }

        /// Represents a project specific to an exam.
        struct Projects: Decodable, Identifiable {
            let id: Int
            let name: String
            let slug: String
        }
    }

}
