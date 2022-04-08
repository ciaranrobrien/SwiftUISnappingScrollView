/**
*  SwiftUISnappingScrollView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct UIScrollViewBridge: UIViewRepresentable {
    var decelerationRate: UIScrollView.DecelerationRate
    var delegate: UIScrollViewDelegate
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.parentScrollView() {
                scrollView.decelerationRate = decelerationRate
                scrollView.delegate = delegate
                
                //Prevent SwiftUI from reverting deceleration rate
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    scrollView.decelerationRate = decelerationRate
                }
            }
        }
    }
}


private extension UIView {
    func parentScrollView() -> UIScrollView? {
        if let scrollView = self as? UIScrollView {
            return scrollView
        }
        
        if let superview = superview {
            for subview in superview.subviews {
                if subview != self, let scrollView = subview as? UIScrollView {
                    return scrollView
                }
            }
            
            if let scrollView = superview.parentScrollView() {
                return scrollView
            }
        }
        
        return nil
    }
}
