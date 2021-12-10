import SwiftUI

// https://stackoverflow.com/a/60855853/4791194
struct ScrollingHelper: UIViewRepresentable {
    let proxy: ScrollingProxy // reference type

    func makeUIView(context: Context) -> UIView {
        UIView() // managed by SwiftUI, no overloads
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // この時点ではスクロールビューが取得できないことがあるので、遅延実行する
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            proxy.catchScrollView(for: uiView) // here UIView is in view hierarchy
        }
    }
}
