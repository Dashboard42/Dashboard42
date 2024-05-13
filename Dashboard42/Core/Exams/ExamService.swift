//
//  ExamService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

/// Manages interactions with an API concerning exam-related operations.
final class ExamService {

    /// Retrieves the list of examinations scheduled for a specific campus.
    /// - Parameter campusId: The identifier of the campus for which the exams are to be retrieved.
    /// - Returns: Returns an array of `Api.Exam` objects, which are decoded exam templates.
    func fetchCampusExams(campusId: Int) async throws -> [Api.Exam] {
        let endpoint = Api.ExamEndpoints.fetchCampusExams(campusId: campusId)
        return try await Api.shared.fetch(endpoint, type: [Api.Exam].self)
    }

    /// Retrieves the list of exams in which a user is registered or which are relevant to them.
    /// - Parameter userId: The identifier of the user for whom the tests are to be retrieved.
    /// - Returns: Returns an array of `Api.Exam` objects, which are decoded exam templates.
    func fetchUserExams(userId: Int) async throws -> [Api.Exam] {
        let endpoint = Api.ExamEndpoints.fetchUserExams(userId: userId)
        return try await Api.shared.fetch(endpoint, type: [Api.Exam].self)
    }

}
