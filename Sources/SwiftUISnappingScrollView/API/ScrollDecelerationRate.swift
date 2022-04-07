/**
*  SwiftUISnappingScrollView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

/// A floating-point value that determines the rate of deceleration after
/// the user ends dragging in a scrolling view.
public enum ScrollDecelerationRate: Hashable, CaseIterable {
    
    /// The default deceleration rate.
    case normal
    
    /// A fast deceleration rate.
    case fast
}
