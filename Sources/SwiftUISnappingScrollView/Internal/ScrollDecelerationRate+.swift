/**
*  SwiftUISnappingScrollView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal extension ScrollDecelerationRate {
    var rate: UIScrollView.DecelerationRate {
        switch self {
        case .normal: return .normal
        case .fast: return .fast
        }
    }
}
