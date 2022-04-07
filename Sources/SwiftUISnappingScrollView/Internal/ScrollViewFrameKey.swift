/**
*  SwiftUISnappingScrollView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal extension EnvironmentValues {
    var scrollViewFrame: CGRect? {
        get { self[ScrollViewFrameKey.self] }
        set { self[ScrollViewFrameKey.self] = newValue }
    }
}

private struct ScrollViewFrameKey: EnvironmentKey {
    static let defaultValue: CGRect? = nil
}
