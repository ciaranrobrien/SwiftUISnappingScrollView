/**
*  SwiftUISnappingScrollView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public extension View {
    
    /// Sets the scroll snapping anchor rect for this view.
    ///
    /// A parent `SnappingScrollView` will prefer to end scrolling
    /// outside, or on an edge, of the anchor rect defined by the source.
    ///
    /// Avoid setting the scroll snapping anchor rect on a child of a lazy
    /// view, such as a `LazyHGrid`, `LazyVGrid`, `LazyHStack`
    /// or `LazyVStack`.
    ///
    /// - Parameters:
    ///   - source: The source of the anchor rect.
    func scrollSnappingAnchor(_ source: Anchor<CGRect>.Source?) -> some View {
        anchorPreference(key: AnchorsKey.self, value: source ?? .bounds) {
            source != nil ? [$0] : []
        }
    }
}


public extension View {
    
    /// Adds an action to perform when this view's bounds moves into or
    /// out of the visible frame.
    ///
    /// You can use `onVisible` when the view is a child of a
    /// `SnappingScrollView`.
    ///
    /// `onVisible` is called on the main thread. Avoid performing
    /// long-running tasks on the main thread. If you need to perform a
    /// long-running task in response to the visibility changing, you should
    /// dispatch to a background queue.
    ///
    /// - Parameters:
    ///   - padding: The padding around all edges of the view's bounds.
    ///   The default value for this parameter is `0`.
    ///   - action: A closure to run when the visibility changes.
    ///   - isVisible: The view's visibility.
    @inlinable func onVisible(padding length: CGFloat = 0, action: @escaping (_ isVisible: Bool) -> Void) -> some View {
        onVisible(padding: EdgeInsets(top: length, leading: length, bottom: length, trailing: length),
                  action: action)
    }
    
    /// Adds an action to perform when this view's bounds moves into or
    /// out of the visible frame.
    ///
    /// You can use `onVisible` when the view is a child of a
    /// `SnappingScrollView`.
    ///
    /// `onVisible` is called on the main thread. Avoid performing
    /// long-running tasks on the main thread. If you need to perform a
    /// long-running task in response to the visibility changing, you should
    /// dispatch to a background queue.
    ///
    /// - Parameters:
    ///   - padding: The padding around each edge of the view's bounds.
    ///   - action: A closure to run when the visibility changes.
    ///   - isVisible: The new value that failed the comparison check.
    func onVisible(padding insets: EdgeInsets, action: @escaping (_ isVisible: Bool) -> Void) -> some View {
        modifier(OnVisibleModifier(action: action, insets: insets))
    }
}
