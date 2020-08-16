import SwiftUI

public struct LoadingView: View {
    @State var isAnimating: Bool = true

    public init() { }

    public var body: some View {
        VStack {
            ActivityIndicator(isAnimating: $isAnimating, style: .large)
            Text("common_ui_loading", bundle: .module)
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding(6)
        .fixedSize()
    }
}

#if DEBUG
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
#endif
