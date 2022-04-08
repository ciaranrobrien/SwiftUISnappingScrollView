/**
*  SwiftUISnappingScrollView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal extension View {
    @ViewBuilder @inlinable func ignoresSafeArea() -> some View {
        if #available(iOS 14.0, *) {
            ignoresSafeArea(.all, edges: .all)
        } else {
            edgesIgnoringSafeArea(.all)
        }
    }
}
