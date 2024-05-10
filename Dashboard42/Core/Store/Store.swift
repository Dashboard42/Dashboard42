//
//  Store.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation
import Observation

@Observable
/// Centralised container for managing the state of the application.
final class Store {

    // MARK: - Properties

    var selection = AppScreen.home

    var user: Api.User?
    var userEvents = [Api.Event]()
    var userExams = [Api.Exam]()

    var campusEvents = [Api.Event]()
    var campusExams = [Api.Exam]()

    // MARK: Errors

    var error: Api.Errors?
    var errorAction: (() -> Void)?

    // MARK: Services

    let authService = AuthService()
    let eventService = EventService()
    let examService = ExamService()
    let userService = UserService()

}
