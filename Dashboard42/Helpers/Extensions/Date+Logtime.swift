//
//  Date+Logtime.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 11/05/2024.
//

import Foundation

extension Date {

    /// Representing the current month and year.
    static var currentMonthDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale.current

        return dateFormatter.string(from: .now).capitalized
    }

    /// Returns the total logging time for the current month, from a list of logging times provided.
    /// - Parameter logtime: An array containing objects of type `Api.Logtime`.
    /// - Returns: The total logging time for the current month, in hours.
    static func currentMonthLogtime(_ logtime: [Api.Logtime]) -> Double {
        logtime.first(where: { $0.fullmonth == currentMonthDate })?.total ?? 0
    }

    /// Retrieves the number of working days in a given month.
    /// - Parameter dateStr: A string representing the month and year in "yyyy-MM" format.
    /// - Returns: The number of working days in the month specified.
    static func getNumberOfDaysToWorkPerMonth(_ dateStr: String) -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"

        guard let date = dateFormatter.date(from: dateStr) else { return 0.0 }

        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: date)!
        var count = 0.0
        var currentDate = interval.start

        while currentDate < interval.end {
            if !calendar.isDateInWeekend(currentDate) {
                count += 1
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return count
    }

}
