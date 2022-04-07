/**
*  SwiftUISnappingScrollView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal extension EdgeInsets {
    func negated() -> EdgeInsets {
        var insets = self
        insets.negate()
        return insets
    }
}
