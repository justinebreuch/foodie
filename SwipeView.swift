//
//  SwipeView.swift
//  Foodie
//
//  Created by Justine Breuch on 9/5/15.
//  Copyright (c) 2015 Justine Breuch. All rights reserved.
//

import Foundation
import UIKit

// must be defined inside the CardsViewController

protocol SwipeViewDelegate: class {
    func swipedLeft()
    func swipedRight()
}

class SwipeView: UIView {
    
    enum Direction {
        case None
        case Left
        case Right
    }
    
    var innerView: UIView? {
        
        // in CardsViewController we are going to set innerView. didSet checks if we actually asined an instance of cardview to innerview
        didSet {
            if let v = innerView {
                addSubview(v)
                v.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            }
        }
    }
    
    private var originalPoint: CGPoint?
    
    weak var delegate: SwipeViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        
        // change to clear
        self.backgroundColor = UIColor.purpleColor()
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragged:"))
        
    }
    
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        let distance = gestureRecognizer.translationInView(self)
        println("distance x: \(distance.x) y: \(distance.y)")
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.Began:
            originalPoint = center
        case UIGestureRecognizerState.Changed:
            let rotationPercentage = min(distance.x/(self.superview!.frame.width / 2), 1)
            let rotationAngle = (CGFloat(2 * M_PI / 16) * CGFloat(rotationPercentage))
            
            // gives radian to rotate item
            transform = CGAffineTransformMakeRotation(rotationAngle)
            
            center = CGPointMake(originalPoint!.x + distance.x, originalPoint!.y + distance.y)
        case UIGestureRecognizerState.Ended:
            
            if abs(distance.x) < frame.width / 4 {
                resetViewPositionAndTransformations()
            } else {
                swipe(distance.x > 0 ? Direction.Right : Direction.Left)
            }
            
        default:
            println("Default trigged for GestureRecognizer")
            break
        }
        
        center = CGPointMake(originalPoint!.x + distance.x, originalPoint!.y + distance.y)
    }
    
    func swipe(s: Direction) {
        if s == Direction.None {
            return
        }
        var parentWidth = superview!.frame.size.width
        if s == Direction.Left {
            parentWidth *= -1
        }
        
        UIView.animateWithDuration(0.2, animations: {
            self.center.x = self.frame.origin.x + parentWidth
            }, completion: {
                success in
                // call delegate function
                if let d = self.delegate {
                    s == .Right ? d.swipedRight() : d.swipedLeft()
                }
            
            })
        
    }
    
    // over the duration, it will update the view
    private func resetViewPositionAndTransformations() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.center = self.originalPoint!
            
            // reset rotate back to 0
            self.transform = CGAffineTransformMakeRotation(0)
        })
    }
}

