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

    /// Applies an animation effect to "slide" a view from its initial position when it appears.
    /// This method encapsulates the use of a custom view modifier, `SlideInViewModifier`, which allows you to specify the height of the line, the duration of the animation, and a delay before the animation starts.
    /// - Parameters:
    ///   - rowHeight: Specifies the initial height at which the view will begin to "slide". This value can be used to animate the view from a specific position off-screen or inside a container.
    ///   - duration: The duration of the animation, expressed in seconds. This controls how quickly the view enters its final state on screen.
    ///   - delay: A delay, expressed in seconds, before the animation starts. This is used to delay the start of the animation until after the view is loaded or becomes visible.
    /// - Returns: Returns the view on which the method is applied, modified to include the specified drag animation.
    func slideIn(rowHeight: CGFloat, duration: TimeInterval, delay: CGFloat) -> some View {
        modifier(SlideInViewModifier(rowHeight: rowHeight, duration: duration, delay: delay))
    }

}
