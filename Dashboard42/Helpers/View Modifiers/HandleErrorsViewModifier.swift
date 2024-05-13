//
//  HandleErrorsViewModifier.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

struct HandleErrorsViewModifier: ViewModifier {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss

    let error: Api.Errors?
    let actions: (() -> Void)?

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .alert(isPresented: .constant(error != nil), error: error) { error in
                Button("Annuler", role: .cancel) {}

                Button("OK") {
                    actions?()
                    dismiss()
                }
            } message: { error in
                Text(error.failureReason ?? "Une erreur s'est produite. Merci de réessayer plus tard.")
            }

    }

}

// MARK: - Extensions

extension View {

    /// Simplifies the process of adding error handling to a view, enabling the presentation of alerts based on specific errors and the execution of customised actions when these errors are handled.
    /// - Parameters:
    ///   - error: Error which is used to determine whether an alert should be presented and to provide the contents of the alert.
    ///   - actions: A closure executed when the user presses the "OK" button on the alert.
    /// - Returns: Returns a modified view with the `HandleErrorsViewModifier` modifier applied, configured with the `error` and `actions` parameters supplied.
    func handleError(error: Api.Errors?, actions: (() -> Void)? = nil) -> some View {
        modifier(HandleErrorsViewModifier(error: error, actions: actions))
    }

}
