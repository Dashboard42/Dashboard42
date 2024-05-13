//
//  Exam+Samples.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

// MARK: - Exam Sample

extension Api.Exam {
    static let sample = Api.Exam(
        id: 15631,
        beginAt: .now,
        endAt: .init(timeIntervalSinceNow: 10800),
        location: "Z2",
        maxPeople: 60,
        nbrSubscribers: 5,
        name: "Exam",
        projects: .sample
    )
}

// MARK: - Exam Samples

extension [Api.Exam] {
    static let sample: [Api.Exam] = [.sample]
}

// MARK: - Exam Project Sample

extension Api.Exam.Projects {
    static let sample = Api.Exam.Projects(id: 1320, name: "Exam rank 02", slug: "exam-rank-02")
}

// MARK: - Exam Project Samples

extension [Api.Exam.Projects] {
    static let sample: [Api.Exam.Projects] = [
        .sample,
        .init(id: 1321, name: "Exam rank 03", slug: "exam-rank-03"),
        .init(id: 1322, name: "Exam rank 04", slug: "exam-rank-04"),
        .init(id: 1323, name: "Exam rank 05", slug: "exam-rank-05"),
        .init(id: 1324, name: "Exam rank 06", slug: "exam-rank-06"),
    ]
}
