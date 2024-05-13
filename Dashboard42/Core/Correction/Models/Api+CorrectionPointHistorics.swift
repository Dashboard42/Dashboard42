//
//  Api+CorrectionPointHistorics.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 10/05/2024.
//

import Foundation

extension Api {

    /// Represents data relating to historical correction points.
    struct CorrectionPointHistorics: Decodable, Identifiable {
        let id: Int
        let scaleTeamId: Int?
        let total: Int
        let createdAt: Date
        let updatedAt: Date
    }

}
