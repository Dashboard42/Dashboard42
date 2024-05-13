//
//  UserService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 08/05/2024.
//

import Foundation

/// Encapsulates functionality for interacting with user-related APIs.
final class UserService {

    /// Retrieves the information of the connected user using the endpoint dedicated for this purpose.
    /// - Returns: An instance of `Api.User` representing the logged-in user.
    func fetchUser() async throws -> Api.User {
        let endpoint = Api.UserEndpoints.fetchConnectedUser
        return try await Api.shared.fetch(endpoint, type: Api.User.self)
    }

    /// Retrieves information about a specific user using its identifier.
    /// - Parameter id: The unique identifier of the user to be retrieved.
    /// - Returns: An instance of `Api.User` representing the user being searched for.
    func fetchUser(id: Int) async throws -> Api.User {
        let endpoint = Api.UserEndpoints.fetchUserById(id: id)
        return try await Api.shared.fetch(endpoint, type: Api.User.self)
    }

    /// Retrieves information about a user based on their username (login).
    /// - Parameter login: The username of the individual to retrieve.
    /// - Returns: An instance of `Api.User` representing the searched user.
    func fetchUser(login: String) async throws -> Api.User {
        let endpoint = Api.UserEndpoints.fetchUserByLogin(login: login)
        return try await Api.shared.fetch(endpoint, type: Api.User.self)
    }

    /// Retrieves log time data for a given user at a given date.
    /// - Parameters:
    ///   - login: The login (username) for which to retrieve log time data.
    ///   - entryDate: The date for which to retrieve the log time data.
    /// - Returns: A list of logging times for the specified user on the specified date.
    func fetchLogtime(for login: String, entryDate: String) async throws -> [Api.Logtime] {
        let endpoint = Api.LogtimeEndpoints.fetchLogtime(login: login, entryDate: entryDate)
        let logtimes = try await Api.shared.fetch(endpoint, type: Api.LogtimeResult.self)

        return convertLogtimeResultToLogtime(result: logtimes)
    }

    // MARK: - Private methods

    /// Converts an API log time result into a list of log times with additional information.
    /// - Parameter result: The result of logging time for the API to be converted.
    /// - Returns: A list of logging times with additional information.
    private func convertLogtimeResultToLogtime(result: Api.LogtimeResult) -> [Api.Logtime] {
        var monthData = [Api.Logtime]()
        var monthlyData = [String: Double]()

        for (date, time) in result {
            let components = date.split(separator: "-")
            let yearMonth = "\(components[0])-\(components[1])"

            let timeComponents = time.components(separatedBy: ":")
            let hours = Double(timeComponents[0]) ?? 0.0
            let minutes = Double(timeComponents[1]) ?? 0.0
            let seconds = Double(timeComponents[2].components(separatedBy: ".").first ?? "0.0") ?? 0.0

            let totalHours = hours + minutes / 60.0 + seconds / 3600.0
            monthlyData[yearMonth, default: 0.0] += totalHours
        }

        monthData = monthlyData.map { month, totalHours in
            let logtime = result.filter { $0.key.contains(month) }
            let numberOfDaysToWork = Date.getNumberOfDaysToWorkPerMonth(month)

            return Api.Logtime(
                month: month,
                total: totalHours,
                details: logtime,
                numberOfDaysToWork: numberOfDaysToWork
            )
        }

        monthData.sort(by: { $0.month > $1.month })

        return monthData
    }

}
