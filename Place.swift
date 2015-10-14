//
//  Place.swift
//  Foodie
//
//  Created by Justine Breuch on 8/31/15.
//  Copyright (c) 2015 Justine Breuch. All rights reserved.
//
//
import Foundation
import Parse

private
    let foursquare_client_id="XPVBDQQX3N4FUYXXLN52XCTT1GKPITP0LCYLTZ0YDNBZMLG1"
    let foursquare_client_secret="CCNVMMJG21Y4HCIFSVJGS4BPZGKLTCMUBCUYWVG4JYLWR0TZ"
    let instagram_access_token = "11905781.47733f8.af1a1a2e06fb4c90b6c6804612fc495d"

struct Place {
    
    let id: String
    let name: String
    let instagram_id: String
    
    private let pfPlace: PFObject
    

    func getData() -> NSArray {
        var datas = [NSData]()
        
        if let url = NSURL(string: "https://api.instagram.com/v1/locations/622119/media/recent?access_token=11905781.47733f8.af1a1a2e06fb4c90b6c6804612fc495d") {
            
            if let contents = NSData(contentsOfURL: url) {
                
                // Create another error optional
                var jsonerror:NSError?
                
                if let json: AnyObject = (try? NSJSONSerialization.JSONObjectWithData(contents, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary) {
                    
                    let instas = json["data"] as! NSArray
                    
                    for insta in instas {
                        
                        let pictures = insta["images"] as! NSDictionary!
                        let standard_res = pictures["standard_resolution"] as! NSDictionary!
                        
                        let url = NSURL(string: standard_res["url"] as! String!)
                        let data = NSData(contentsOfURL: url!)
                        
                        if data != nil {
                            datas.append(data!)
                        }
                        
                    }
                    
                } else {
                    print(jsonerror)
                }
            }
        } else {
            print("URL FAILED")
        }
        return datas
    }

}

func pfPlaceToPlace(place: PFObject) -> Place {
    return Place(id: place.objectId!, name: place.objectForKey("name") as! String, instagram_id: place.objectForKey("instagram_id") as! String, pfPlace: place)
}


func fetchAllPlaces(callback: ([Place]) -> ()) {
    
    // version needs to be yyyymmdd format
    let version = "20150705"
    
    // latitude and longitude
    let ll = "40.0522776,-75.2913171"
    
    //  standard base
    let url = NSURL(string: "https://api.foursquare.com/v2/venues/explore?ll=\(ll)&section=food&openNow=1&client_id=\(foursquare_client_id)&client_secret=\(foursquare_client_secret)&v=\(version)")
    
    if let data = NSData(contentsOfURL: url!) {
    
        let jsonError: NSError?
        
        if let json: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary {
            
            let response = json["response"] as! NSDictionary
            let groups = response["groups"] as! NSArray
            let recommended = groups[0] as! NSDictionary
            let items = recommended["items"] as! NSArray
            
            let item = items[0] as! NSDictionary
//            for item in items {
            
                // venue is one restaurant
                let venue: NSDictionary = (item["venue"] as? NSDictionary)!
                var checkpoint: String = venue["id"] as! String

                var query = PFQuery(className:"Place")
                query.whereKey("foursquare_id", equalTo: "\(checkpoint)")
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    
                    if error == nil {
                        // The find succeeded.
                        print("Retrieved \(objects!.count) places.")
                        
                        
                        if (objects!.count == 0) {
                            // save new entries
                            print("creating new object")
                            var place = PFObject(className:"Place")
                            
                            place["foursquare_id"] = venue["id"]
                            
                            place["name"] = venue["name"]
                            print(venue["name"])
                            
                            if (venue["url"] != nil) {
                                place["url"] = venue["url"]
                            }
                            
                            if (venue["rating"] != nil) {
                                place["rating"] = venue["rating"]
                            }
                            
                            if (venue["contact"] != nil) {
                                let contact = venue["contact"] as! NSDictionary
                                if (contact["phone"] != nil && contact["formattedPhone"] != nil) {
                                    place["phone"] = contact["phone"]
                                    place["formatted_phone"] = contact["formattedPhone"]
                                }
                                
                            }
                            
                            if (venue["location"] != nil) {
                                let location = venue["location"] as! NSDictionary
                                
                                if (location["formattedAddress"] != nil) {
                                    let address:Array<String> = (location["formattedAddress"] as? Array<String>)!
                                    place["formatted_address"] = address.joinWithSeparator(" ") as String
                                    
                                }
                                
                            }
                            
                            place["instagram_id"] = getInstagramId(checkpoint)
                            
                            place.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    print("Success!")
                                } else {
                                    print("There was a problem!")
                                }
                            }
                            
                        }
                        // HAD ELSE HERE
                
                            
                        // Do something with the found objects
                        print("Looking in Parse")
                        
                        // We are getting back an array of PFObjects if objects isn't nil
                        
                        if let pfPlaces = objects as? [PFObject] {
                            
                            // print func 
                            
                            for object in pfPlaces {
                                print(object["name"])
                            }
                            
                            // $0 means pfPlaces
                            let places = pfPlaces.map({pfPlaceToPlace($0)})
                            print("before callback")
                            callback(places)
                        
                        }
                        
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                        
                    }
                    
                }
//            }
        }
    }
}

func getInstagramId(checkpoint:String) -> String? {
    
    //  standard base
    let url = NSURL(string: "https://api.instagram.com/v1/locations/search?foursquare_v2_id=\(checkpoint)&access_token=\(instagram_access_token)")
    
    if let data = NSData(contentsOfURL: url!) {
    
        // Create another error optional
        var jsonerror:NSError?

        if let json: AnyObject! = (try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary) {
            
            let data = json["data"] as! NSArray
            let info = data[0] as! NSDictionary
            return info["id"] as! String?
        }
    }
    return ""
}



