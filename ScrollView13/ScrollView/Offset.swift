import SwiftUI

struct Offset {
    let offset: CGFloat
    let maxOffset: CGFloat

    var type: OffsetType {
        if offset == 0 {
            return .top
        } else if offset == maxOffset {
            return .bottom
        } else {
            return .middle
        }
    }
}
