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
    
//    // these will appear on the app as elements
//    private let nameLabel: UILabel = UILabel()
//    
//    // these get set when you pass it in
//    var name: String? {
//        didSet {
//            if let name = name {
//                
//                // element from the top
//                nameLabel.text = name
//            }
//        }
//    }
// 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    
    private func initialize() {
        
        layer.borderWidth = 0.5
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
    }
    
    func setScrollView(datas: NSArray) {
        
        var scrollViewContentSize:CGFloat = 0
        
        var instaScrollView: UIScrollView!
        var glanceOfPlaceImageView: UIImageView!
        
        instaScrollView = UIScrollView(frame: self.bounds)
        
        for data in datas {
        
            glanceOfPlaceImageView = UIImageView(image: UIImage(data: data as! NSData))
            glanceOfPlaceImageView.frame.size.height = 400
            glanceOfPlaceImageView.frame.size.width = instaScrollView.bounds.width
            glanceOfPlaceImageView.frame.origin.y = scrollViewContentSize
            
            scrollViewContentSize += glanceOfPlaceImageView.bounds.height

            instaScrollView.addSubview(glanceOfPlaceImageView)
            print("added image")

        }
        
        instaScrollView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        instaScrollView.contentSize.width = self.bounds.size.width
        instaScrollView.backgroundColor = UIColor.purpleColor()
        instaScrollView.directionalLockEnabled = true
        instaScrollView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        instaScrollView.contentSize.height = scrollViewContentSize
        
        addSubview(instaScrollView)
        
    }

}
