/**
*  SwiftUISnappingScrollView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal extension Axis {
    var set: Axis.Set {
        switch self {
        case .horizontal: return .horizontal
        case .vertical: return .vertical
        }
    }
}
