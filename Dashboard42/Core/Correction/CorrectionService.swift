//
//  CorrectionService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

/// Manages interactions with an API concerning correction-related operations.
final class CorrectionService {

    /// Fetches the historical data of correction points for a specific user.
    /// - Parameter userId: The ID of the user whose correction points history is to be fetched.
    /// - Returns: Returns an array of `Api.CorrectionPointHistorics`, which are decoded correction points historical data.
    func fetchCorrectionPointHistorics(userId: Int) async throws -> [Api.CorrectionPointHistorics] {
        let endpoint = Api.CorrectionEndpoints.fetchCorrectionPointHistorics(userId: userId)
        return try await Api.shared.fetch(endpoint, type: [Api.CorrectionPointHistorics].self)
    }

    /// Retrieves the scale data related to the user, which might include details of grading scales used for corrections.
    /// - Returns: Returns an array of `Api.Scale`, representing scale data.
    func fetchUserScales() async throws -> [Api.Scale] {
        let endpoint = Api.CorrectionEndpoints.fetchUserScales
        return try await Api.shared.fetch(endpoint, type: [Api.Scale].self)
    }

    /// Fetches available slots for a user to sign up for corrections.
    /// - Returns: Returns an array of `Api.Slot`, which represents different time slots available for corrections.
    func fetchUserSlots() async throws -> [Api.Slot] {
        let endpoint = Api.CorrectionEndpoints.fetchUserSlots
        return try await Api.shared.fetch(endpoint, type: [Api.Slot].self)
    }

    /// Creates a new slot for user corrections within specified time boundaries.
    /// - Parameters:
    ///   - userId: The ID of the user for whom the slot is being created.
    ///   - beginAt: Start date and time of the slot.
    ///   - endAt: End date and time of the slot.
    func createUserSlot(userId: Int, beginAt: Date, endAt: Date) async throws {
        let endpoint = Api.CorrectionEndpoints.createUserSlot(userId: userId, beginAt: beginAt, endAt: endAt)
        try await Api.shared.post(endpoint)
    }

    /// Deletes a specific slot assigned to a user for corrections.
    /// - Parameter slotId: The ID of the slot to be deleted.
    func deleteUserSlot(slotId: Int) async throws {
        let endpoint = Api.CorrectionEndpoints.deleteUserSlot(slotId: slotId)
        try await Api.shared.delete(endpoint)
    }

}
