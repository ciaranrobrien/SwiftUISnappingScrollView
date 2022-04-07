/**
*  SwiftUISnappingScrollView
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal class SnappingScrollViewDelegate: NSObject, ObservableObject, UIScrollViewDelegate {
    var frames = [CGRect]()
    
    private var naturalInset: UIEdgeInsets? = nil
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        let initialOffset = scrollView.contentOffset
        scrollView.setContentOffset(.zero, animated: false)
        
        naturalInset = scrollView.contentInset
        scrollView.setContentOffset(initialOffset, animated: false)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if naturalInset == nil {
            scrollViewDidChangeAdjustedContentInset(scrollView)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        //Prevent large navigation title from interfering with target offset
        if (targetContentOffset.pointee.y <= -naturalInset!.top && velocity.y != 0) {
            return
        }
        
        var targetOffset = targetContentOffset.pointee
        
        let minX = -scrollView.contentInset.left
        let maxX = scrollView.contentSize.width + scrollView.contentInset.right - scrollView.frame.width
        let minY = -scrollView.contentInset.top
        let maxY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.frame.height
        
        let localFrames = frames.map { frame in
            CGRect(x: frame.minX + minX,
                   y: frame.minY + minY,
                   width: frame.width,
                   height: frame.height)
        }
        
        targetOffset.x = localFrames
            .reduce([PointRange(start: minX, end: maxX)]) { values, frame in
                values
                    .flatMap {
                        $0.excluding(PointRange(start: max(frame.minX, minX), end: min(frame.maxX, maxX)))
                    }
                    .reduce([]) {
                        $0.contains($1) ? $0 : $0 + [$1]
                    }
            }
            .sorted { $0.distance(to: targetOffset.x) < $1.distance(to: targetOffset.x) }
            .first?
            .resolving(targetOffset.y) ?? minX
        
        targetOffset.y = localFrames
            .reduce([PointRange(start: minY, end: maxY)]) { values, frame in
                values
                    .flatMap {
                        $0.excluding(PointRange(start: max(frame.minY, minY), end: min(frame.maxY, maxY)))
                    }
                    .reduce([]) {
                        $0.contains($1) ? $0 : $0 + [$1]
                    }
            }
            .sorted { $0.distance(to: targetOffset.y) < $1.distance(to: targetOffset.y) }
            .first?
            .resolving(targetOffset.y) ?? minY
        
        if (scrollView.contentOffset.x > targetOffset.x && velocity.x > 0)
            || (scrollView.contentOffset.x < targetOffset.x && velocity.x < 0)
            || (scrollView.contentOffset.y > targetOffset.y && velocity.y > 0)
            || (scrollView.contentOffset.y < targetOffset.y && velocity.y < 0)
        {
            //Fixes immediate jump to target offset
            targetContentOffset.pointee = scrollView.contentOffset
            scrollView.setContentOffset(targetOffset, animated: true)
        } else {
            targetContentOffset.pointee = targetOffset
        }
    }
}


private struct PointRange: Hashable {
    let start: CGFloat
    let end: CGFloat
    
    private func contains(_ point: CGFloat) -> Bool {
        (start...end).contains(point)
    }
    
    func distance(to point: CGFloat) -> CGFloat {
        if contains(point) {
            return 0
        } else {
            return min(abs(start - point), abs(end - point))
        }
    }
    
    func excluding(_ other: PointRange) -> [PointRange] {
        if other.start < start {
            if other.end <= end {
                if other.end <= start {
                    return [self]
                } else {
                    return [PointRange(start: other.end, end: end)]
                }
            } else {
                return []
            }
        } else {
            if other.end <= end {
                return [PointRange(start: start, end: other.start),
                        PointRange(start: other.end, end: end)]
            } else {
                if other.start > end {
                    return [self]
                } else {
                    return [PointRange(start: start, end: other.start)]
                }
            }
        }
    }
    
    func resolving(_ point: CGFloat) -> CGFloat {
        if contains(point) {
            return point
        } else {
            return abs(start - point) < abs(end - point) ? start : end
        }
    }
}
