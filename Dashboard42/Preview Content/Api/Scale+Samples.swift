//
//  Scale+Samples.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import Foundation

// MARK: - Scale Sample

extension Api.Scale {
    static let sample = Api.Scale(
        id: 6_085_486,
        scaleId: 29531,
        beginAt: .now,
        correcteds: nil,
        corrector: nil,
        scale: .sample,
        teams: .sample
    )
}

// MARK: - Scale Samples

extension [Api.Scale] {
    static let sample: [Api.Scale] = [.sample]
}

// MARK: - Scale Extensions

extension Api.Scale.User {
    static let sample = Api.Scale.User(id: 92127, login: "mmosca")
}

extension [Api.Scale.User] {
    static let sample: [Api.Scale.User] = [
        .sample,
        .init(id: 94131, login: "abucia"),
    ]
}

extension Api.Scale.Details {
    static let sample = Api.Scale.Details(id: 28445, correctionNumber: 3, duration: 900)
}

extension Api.Scale.Team {
    static let sample = Api.Scale.Team(
        id: 4_839_596,
        name: "mmosca's group",
        projectId: 2007,
        status: "waiting_for_correction",
        users: .sample,
        locked: true,
        validated: nil,
        closed: true,
        lockedAt: .now,
        closedAt: .now
    )
}

extension Api.Scale.Team.User {
    static let sample = Api.Scale.Team.User(id: 92127, login: "mmosca", leader: true)
}

extension [Api.Scale.Team.User] {
    static let sample: [Api.Scale.Team.User] = [
        .sample,
        .init(id: 94131, login: "abucia", leader: false),
    ]
}
