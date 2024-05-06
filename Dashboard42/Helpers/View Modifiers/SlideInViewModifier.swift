//
//  SlideInViewModifier.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

struct SlideInViewModifier: ViewModifier {

    // MARK: - Properties

    @State private var animated: Bool = false

    let rowHeight: CGFloat
    let duration: TimeInterval
    let delay: CGFloat

    private var offset: CGFloat { animated ? 0 : rowHeight * 0.5 }
    private var opacity: Double { animated ? 1 : 0 }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .offset(y: offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: duration).delay(delay)) {
                    animated = true
                }
            }
    }

}

// MARK: - Extensions

extension View {

    /// Applies an slideIn transition effect to the view.
    /// - Parameters:
    ///   - rowHeight: An CGFloat value applied to the transition offset.
    ///   - duration: An TimeInterval value corresponding to the duration of the transition.
    ///   - delay: An CGFloat corresponding value has a delay applied to the transition.
    /// - Returns: A view with a new transition effect.
    func slideIn(rowHeight: CGFloat, duration: TimeInterval, delay: CGFloat) -> some View {
        modifier(SlideInViewModifier(rowHeight: rowHeight, duration: duration, delay: delay))
    }

}
