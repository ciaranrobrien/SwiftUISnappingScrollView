/**
*  SwiftUISnappingScrollView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct OnVisibleModifier: ViewModifier {
    @Environment(\.scrollViewFrame) private var scrollViewFrame
    @State private var isVisible: Bool? = nil
    
    var action: (Bool) -> Void
    var insets: EdgeInsets
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    let isVisible = scrollViewFrame?.intersects(geometry.frame(in: .global))
                    
                    Color.clear
                        .onAppear { onVisible(isVisible) }
                        .onUpdate(of: isVisible, perform: onVisible)
                }
                .padding(insets.negated())
                .hidden()
            )
    }
    
    private func onVisible(_ newValue: Bool?) {
        if let newValue = newValue, isVisible != newValue {
            isVisible = newValue
            action(newValue)
        }
    }
}
