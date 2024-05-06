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

    let isPresented: Bool
    let error: Api.Errors?
    let actions: (() -> Void)?

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .alert(isPresented: .constant(isPresented), error: error) { error in
                Button("Annuler", role: .cancel) {}

                Button("OK") {
                    actions?()
                    dismiss()
                }
            } message: { error in
                if let failureReason = error.failureReason {
                    Text(failureReason)
                }
            }

    }

}

// MARK: - Extensions

extension View {

    /// Presents an alert when an error occurs in the application.
    /// - Parameters:
    ///   - isPresented: Boolean used to determine whether an error has occurred during the execution of a process.
    ///   - error: An ErrorType value indicating the type of error.
    ///   - actions: Actions to be triggered when the button in the error alert is validated.
    /// - Returns: A view with a new error alert.
    func handleError(isPresented: Bool, error: Api.Errors?, actions: (() -> Void)? = nil) -> some View {
        modifier(HandleErrorsViewModifier(isPresented: isPresented, error: error, actions: actions))
    }

}
