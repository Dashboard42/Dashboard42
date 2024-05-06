//
//  Api+Errors.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

extension Api {

    /// An object containing the various possible api network errors.
    enum Errors: LocalizedError {
        case invalidUrl
        case invalidAccessToken
        case tooManyRequests
        case corruptAccessToken
        case invalidServerResponse

        var errorDescription: String? { "Une erreur est survenue" }

        var failureReason: String {
            switch self {
            case .invalidUrl:
                "La création de l'URL à échoué. Merci de réessayer plus tard."
            case .invalidAccessToken:
                "La clé d'accès à l'API n'est plus valide. Merci de réessayer plus tard."
            case .tooManyRequests:
                "Le serveur reçoit trop de demande. Merci de réessayer plus tard."
            case .corruptAccessToken:
                "Les clés d'authentification ne sont plus valide. Merci de réessayer plus tard."
            case .invalidServerResponse:
                "Le serveur a renvoyer une mauvaise réponse. Merci de réessayer plus tard."
            }
        }
    }

}
