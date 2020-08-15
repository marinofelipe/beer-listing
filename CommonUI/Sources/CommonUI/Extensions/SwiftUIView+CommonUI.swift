import SwiftUI

public extension View {
    func applyIf<T: View>(_ condition: @autoclosure () -> Bool, apply: (Self) -> T) -> AnyView {
        condition() ? apply(self).erase() : self.erase()
    }

    func erase() -> AnyView {
        AnyView(self)
    }

    func squircleCornerRadius(_ cornerRadius: CGFloat, borderColor: Color) -> some View {
        self.modifier(SquircleCornerRadius(cornerRadius: cornerRadius, borderColor: borderColor))
    }
}
