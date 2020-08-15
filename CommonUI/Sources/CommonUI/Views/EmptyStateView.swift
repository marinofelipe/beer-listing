import SwiftUI

public enum EmptyStateViewState: Equatable {
    case offline
    case genericError
    case customError(message: String)

    var text: String? {
        switch self {
        case let .customError(message):
            return message
        default:
            return nil
        }
    }

    var localizedStringKey: LocalizedStringKey? {
        switch self {
        case .offline:
            return LocalizedStringKey("common_ui_offline_error")
        case .genericError:
            return LocalizedStringKey("common_ui_generic_error")
        default:
            return nil
        }
    }
}

public struct EmptyStateView: View {
    let state: EmptyStateViewState
    let onRetry: () -> Void

    public init(
        state: EmptyStateViewState,
        onRetry: @escaping () -> Void
    ) {
        self.state = state
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack {
            if state == .offline {
                Image(systemName: "wifi.slash")
            }

            text()
                .font(.headline)
                .foregroundColor(.black)
                .padding(6)

            Button(action: {
                withAnimation(
                    .interactiveSpring(
                        response: 0.44,
                        dampingFraction: 0.63,
                        blendDuration: 0.67
                    )
                ) {
                    onRetry()
                }
            }, label: {
                Text("common_ui_reload", bundle: .module)
            })
            .padding(8)
            .background(Color.blue)
            .font(.callout)
            .foregroundColor(.white)
            .squircleCornerRadius(8, borderColor: .blue)
        }
        .fixedSize()
    }

    private func text() -> Text {
        if let localizedStringKey = state.localizedStringKey {
            return Text(localizedStringKey, bundle: .module)
        } else if let text = state.text {
            return Text(text)
        }
        return Text("")
    }
}

#if DEBUG
struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmptyStateView(state: .offline, onRetry: { })

            EmptyStateView(state: .genericError, onRetry: { })

            EmptyStateView(state: .customError(message: "Another error"), onRetry: { })
        }
    }
}
#endif
