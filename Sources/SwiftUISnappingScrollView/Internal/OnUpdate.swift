/**
*  SwiftUISnappingScrollView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import Combine
import SwiftUI

internal extension View {
    @ViewBuilder @inlinable func onUpdate<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> some View
    where V : Equatable
    {
        if #available(iOS 14.0, *) {
            onChange(of: value, perform: action)
        } else {
            onReceive(Just(value), perform: action)
        }
    }
}
