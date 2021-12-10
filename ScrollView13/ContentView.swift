import SwiftUI

struct ContentView: View {
    private let scrollingProxy = ScrollingProxy() // proxy helper
    @State private var scrollViewContentOffset = CGFloat(0)
    @State private var scrollViewContentMaxOffset = CGFloat(0)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    self.scrollingProxy.scrollTo(.top, animated: true)
                }) {
                    Image(systemName: "arrow.up.to.line")
                        .padding(.horizontal)
                }
                Button(action: {
                    self.scrollingProxy.scrollTo(.end, animated: true)
                }) {
                    Image(systemName: "arrow.down.to.line")
                        .padding(.horizontal)
                }
                Button(action: {
                    self.scrollingProxy.scrollTo(.point(point: CGPoint(x: 0, y: 1000)), animated: true)
                }) {
                    Text("y=1000")
                }
            }
            Divider()

            TrackableScrollView(
                .vertical,
                showIndicators: true,
                contentOffset: $scrollViewContentOffset,
                contentMaxOffset: $scrollViewContentMaxOffset,
                offsetChanged: { offset in
                    print("offsetChanged: \(offset)")
                },
                content: {
                    ForEach(0 ..< 200) { i in
                        makeItem(index: i)
                            .listRowInsets(EdgeInsets())
                            .background(
                                ScrollingHelper(proxy: self.scrollingProxy) // injection
                            )
                    }
                }
            )

            Divider()
            HStack {
                Text("offset: \(Int(scrollViewContentOffset)), maxOffset: \(Int(scrollViewContentMaxOffset))")
            }
        }
    }
}

@ViewBuilder private func makeItem(index: Int) -> some View {
    VStack(spacing: 0) {
        Text("Item \(index)")
    }
    .frame(maxWidth: .infinity)
    .frame(height: 50)
    .overlay(Divider(), alignment: .top)
    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
