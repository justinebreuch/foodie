//
//  CardView.swift
//  Foodie
//
//  Created by Justine Breuch on 9/2/15.
//  Copyright (c) 2015 Justine Breuch. All rights reserved.
//

import UIKit
import Foundation

class CardView: UIView {
    
    // these will appear on the app as elements
    private let nameLabel: UILabel = UILabel()
    private let picturesScrollView: UIScrollView = UIScrollView()
    
    // these get set when you pass it in
    var name: String? {
        didSet {
            if let name = name {
                
                // element from the top
                nameLabel.text = name
            }
        }
    }
    
    var picturesScroll: UIScrollView? {
        didSet {
            if let picturesScroll = picturesScroll {
        
                // element from the top
                picturesScrollView.backgroundColor = UIColor.orangeColor()
                picturesScrollView.directionalLockEnabled = true
                
            }
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    
    private func initialize() {
        println("called initialize CardView")
        
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(nameLabel)
        
        picturesScroll?.frame = self.bounds
        picturesScroll?.contentSize.width = self.bounds.size.width
        picturesScroll?.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight

        if (picturesScroll != nil) {
            println("picturesScroll is not nil at initialize")
            addSubview(picturesScroll!)
        }
        
        backgroundColor = UIColor.redColor()
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        
//        //Constraints for ImageView
//        addConstraint(NSLayoutConstraint(item: picturesScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: picturesScrollView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: picturesScrollView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: picturesScrollView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
//
//        //Constraints for Label
//        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: picturesScrollView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 10))
//        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -10))
//        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        
        
    }

}
