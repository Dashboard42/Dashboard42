//
//  Api+Logtime.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 11/05/2024.
//

import Foundation

extension Api {

    typealias LogtimeResult = [String: String]

    /// The `Logtime` structure is a data model for representing the logtime of a user.
    struct Logtime: Decodable, Identifiable {
        let month: String
        let total: Double
        let details: LogtimeResult
        let numberOfDaysToWork: Double

        var id = UUID()

        var fullmonth: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM"
            dateFormatter.locale = Locale.current

            guard let date = dateFormatter.date(from: month) else { return "Indéfinie" }

            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: date).capitalized
        }
    }

}
