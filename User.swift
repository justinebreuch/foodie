//
//  User.swift
//  Foodie
//
//  Created by Justine Breuch on 8/31/15.
//  Copyright (c) 2015 Justine Breuch. All rights reserved.
//

import Foundation
import Parse

struct User {
    let id: String
    private let pfUser: PFUser
}

func pfUserToUser(user: PFUser) -> User {
    return User(id: user.objectId!, pfUser: user)
}

//func currentUser() -> User? {
//    if let user = PFUser.currentUser() {
//        return pfUserToUser(user)
//    }
//    return nil
//}

//
//func saveSkip(user: User) {
//    let skip = PFObject(className: "Action")
//    skip.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
//    skip.setObject(place.id, forKey: "toPlace")
//    skip.setObject("skipped", forKey: "type")
//    skip.saveInBackgroundWithBlock(nil)
//}
//
//func saveLike(user: User) {
//    
//    PFQuery(className: "Action")
//        .whereKey("byUser", equalTo: user.id)
//        // set after you make Place.swift
//        .whereKey("toPlace", equalTo: PFUser.currentUser().objectId)
//        .whereKey("type", equalTo: "liked")
//        .getFirstObjectInBackgroundWithBlock({
//            object, error in
//            
//            var matched = false
//            
//            if object != nil {
//                matched = true
//                object.setObject("matched", forKey: "type")
//                object.saveInBackgroundWithBlock(nil)
//            }
//            
//            let match = PFObject(className: "Action")
//            match.setObject(PFUser.currentUser().objectId, forKey: "byUser")
//            match.setObject(user.id, forKey: "toUser")
//            match.setObject(matched ? "matched" : "liked", forKey: "type")
//            match.saveInBackgroundWithBlock(nil)
//            
//        })
//}
