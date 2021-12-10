import SwiftUI

// https://medium.com/@maxnatchanon/swiftui-how-to-get-content-offset-from-scrollview-5ce1f84603ec
struct TrackableScrollView<Content>: View where Content: View {
    let axes: Axis.Set
    let showIndicators: Bool
    @Binding var contentOffset: CGFloat
    @Binding var contentMaxOffset: CGFloat
    let offsetChanged: (Offset) -> Void
    let content: Content

    var body: some View {
        GeometryReader { outsideProxy in
            ScrollView(self.axes, showsIndicators: self.showIndicators) {
                ZStack(alignment: self.axes == .vertical ? .top : .leading) {
                    GeometryReader { insideProxy in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: [
                                calculateContentOffset(fromOutsideProxy: outsideProxy, insideProxy: insideProxy),
                                calculateContentMaxOffset(fromOutsideProxy: outsideProxy, insideProxy: insideProxy)
                            ])
                    }
                    VStack(spacing: 0) {
                        self.content
                    }
                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                contentOffset = value[0]
                contentMaxOffset = value[1]
                let offset = Offset(offset: contentOffset, maxOffset: contentMaxOffset)
                offsetChanged(offset)
            }
        }
    }

    init(
        _ axes: Axis.Set = .vertical,
        showIndicators: Bool = true,
        contentOffset: Binding<CGFloat>,
        contentMaxOffset: Binding<CGFloat>,
        offsetChanged: @escaping (Offset) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showIndicators = showIndicators
        _contentOffset = contentOffset
        _contentMaxOffset = contentMaxOffset
        self.offsetChanged = offsetChanged
        self.content = content()
    }

    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        if axes == .vertical {
            return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
        } else {
            return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
        }
    }

    private func calculateContentMaxOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        if axes == .vertical {
            return insideProxy.frame(in: .global).height - outsideProxy.frame(in: .global).height
        } else {
            return insideProxy.frame(in: .global).width - outsideProxy.frame(in: .global).width
        }
    }
}
