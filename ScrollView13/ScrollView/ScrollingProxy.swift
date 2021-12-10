import SwiftUI

// https://stackoverflow.com/a/60855853/4791194
class ScrollingProxy {
    enum Action {
        case end
        case top
        case point(point: CGPoint)
    }

    private var scrollView: UIScrollView?

    func catchScrollView(for view: UIView) {
        if scrollView == nil {
            scrollView = view.enclosingScrollView()
        }
    }

    func scrollTo(_ action: Action, animated: Bool) {
        if let scroller = scrollView {
            var rect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
            switch action {
            case .end:
                rect.origin.y = scroller.contentSize.height +
                scroller.contentInset.bottom + scroller.contentInset.top - 1
            case let .point(point):
                rect.origin.y = point.y
            default: {
                // default goes to top
            }()
            }
            scroller.scrollRectToVisible(rect, animated: animated)
        }
    }
}

extension UIView {
    func enclosingScrollView() -> UIScrollView? {
        var next: UIView? = self
        repeat {
            next = next?.superview
            if let scrollview = next as? UIScrollView {
                return scrollview
            }
        } while next != nil
        return nil
    }
}
