//
//  Place.swift
//  Foodie
//
//  Created by Justine Breuch on 8/30/15.
//  Copyright (c) 2015 Justine Breuch. All rights reserved.
//

import Foundation

struct Place {
    var name: String?
    var foursquare_id: String?
    var instagram_id: String?
    var phone: String?
    var formatted_phone: String?
    var url: String?
    var rating: Double?
    
    init(json: NSDictionary) {
        
    }
}
