import SwiftUI

extension View {
    /// `animation(_:value:)` that stays still when the user turned on Reduce Motion.
    func motion(_ animation: Animation, value: some Equatable) -> some View {
        modifier(ReducibleAnimation(animation: animation, value: value))
    }
}

private struct ReducibleAnimation<Value: Equatable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reducesMotion
    let animation: Animation
    let value: Value

    func body(content: Content) -> some View {
        content.animation(reducesMotion ? nil : animation, value: value)
    }
}
