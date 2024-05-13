//
//  EventService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

/// Manages interactions with an API concerning event-related operations.
final class EventService {

    /// Retrieves all events associated with a specific user.
    /// - Parameter userId: The user identifier for which to retrieve events.
    /// - Returns: Returns an array of `Api.Event` objects, which are decoded event templates.
    func fetchUserEvents(userId: Int) async throws -> [Api.Event] {
        let endpoint = Api.EventEndpoints.fetchUserEvents(userId: userId)
        return try await Api.shared.fetch(endpoint, type: [Api.Event].self)
    }

    /// Retrieves events for a specific campus.
    /// - Parameters:
    ///   - campusId: The campus ID.
    ///   - cursusId: The cursus identifier.
    /// - Returns: Returns an array of `Api.Event` objects, which are decoded event templates.
    func fetchCampusEvents(campusId: Int, cursusId: Int) async throws -> [Api.Event] {
        let endpoint = Api.EventEndpoints.fetchCampusEvents(campusId: campusId, cursusId: cursusId)
        return try await Api.shared.fetch(endpoint, type: [Api.Event].self)
    }

    /// Updates a user's participation in a given event.
    /// - Parameters:
    ///   - userId: The user identifier.
    ///   - eventId: The event identifier.
    func updateUserEvent(userId: Int, eventId: Int) async throws {
        let endpoint = Api.EventEndpoints.updateUserEvent(userId: userId, eventId: eventId)
        try await Api.shared.post(endpoint)
    }

    /// Removes a user's participation in a specific event.
    /// - Parameters:
    ///   - userId: The user identifier.
    ///   - eventId: The event identifier.
    func deleteUserEvent(userId: Int, eventId: Int) async throws {
        var endpoint = Api.EventEndpoints.fetchEventUserId(userId: userId, eventId: eventId)
        let eventUserId = try await Api.shared.fetch(endpoint, type: [Api.EventUser].self)

        guard let eventUserId = eventUserId.first?.id else { return }

        endpoint = Api.EventEndpoints.deleteUserEvent(eventUserId: eventUserId)
        try await Api.shared.delete(endpoint)
    }

}
