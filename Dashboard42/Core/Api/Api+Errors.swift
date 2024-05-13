//
//  Api+Errors.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

extension Api {

    /// Defines a series of custom errors that can occur when executing network requests in the application.
    enum Errors: LocalizedError {
        case invalidUrl
        case invalidAccessToken
        case tooManyRequests
        case corruptAccessToken
        case invalidServerResponse

        /// Provides a generic description for all errors, simply indicating that an error has occurred.
        var errorDescription: String? { "Une erreur est survenue" }

        /// Provides a specific explanation based on the type of error, detailing the nature of the problem to inform the user or developer more precisely.
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
