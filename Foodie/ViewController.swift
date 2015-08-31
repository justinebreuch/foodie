//
//  ViewController.swift
//  Foodie
//
//  Created by Justine Breuch on 8/30/15.
//  Copyright (c) 2015 Justine Breuch. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var picturesScrollView: UIScrollView!
    
    
    private
    let foursquare_client_id="XPVBDQQX3N4FUYXXLN52XCTT1GKPITP0LCYLTZ0YDNBZMLG1"
    let foursquare_client_secret="CCNVMMJG21Y4HCIFSVJGS4BPZGKLTCMUBCUYWVG4JYLWR0TZ"
    let instagram_access_token = "11905781.47733f8.af1a1a2e06fb4c90b6c6804612fc495d"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        get_place()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func get_place() -> Void {
        // version needs to be yyyymmdd format
        var version = "20150705"
        
        // latitude and longitude
        var ll = "40.7,-74"
        
        //  standard base
        let url = NSURL(string: "https://api.foursquare.com/v2/venues/explore?ll=\(ll)&section=food&openNow=1&client_id=\(foursquare_client_id)&client_secret=\(foursquare_client_secret)&v=\(version)")
        
        var data = NSData(contentsOfURL: url!)
        
        let jsonError: NSError?
        
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            
            let response = json["response"] as! NSDictionary
            let groups = response["groups"] as! NSArray
            let recommended = groups[0] as! NSDictionary
            let items = recommended["items"] as! NSArray
            
            let item = items[0] as! NSDictionary
            
                // venue is one restaurant
                let venue: NSDictionary = (item["venue"] as? NSDictionary)!
                var checkpoint: String = venue["id"] as! String
                
                // check if it already exists
                var query = PFQuery(className:"Place")
                
                query.whereKey("foursquare_id", equalTo: "\(checkpoint)")
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        // The find succeeded.
                        println("Retrieved \(objects!.count) places.")
                        
                       
                        if (objects!.count == 0) {
                            // save new entries
                            println("creating new object")
                            var place = PFObject(className:"Place")
                            
                            place["foursquare_id"] = venue["id"]
                            
                            place["name"] = venue["name"]
                            
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
                                    place["formatted_address"] = join(" ", address) as String
                                    
                                }
                                
                            }
                            place["instagram_id"] = self.getInstagramId(checkpoint)
                            self.getInstagramData(place["instagram_id"] as! String)
                            
                            
                            place.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    println("Success!")
                                } else {
                                    println("There was a problem!")
                                }
                            }
                            
                        } else {
                            // Do something with the found objects
                            println("Looking in Parse")
                            if let objects = objects as? [PFObject] {
                                for object in objects {
                                    println(object["name"])
                                    self.nameLabel.text = object["name"] as? String
                                    self.getInstagramData(object["instagram_id"] as! String)
                                }
                            }
                        }
                        
                    } else {
                        // Log details of the failure
                        println("Error: \(error!) \(error!.userInfo!)")
                        
                    }
                }
            
        }

    }
    
    func getAPIdata() -> Void  {
        
        // version needs to be yyyymmdd format
        var version = "20150705"
        
        // latitude and longitude
        var ll = "40.7,-74"
        
        //  standard base
        let url = NSURL(string: "https://api.foursquare.com/v2/venues/explore?ll=\(ll)&section=food&openNow=1&client_id=\(foursquare_client_id)&client_secret=\(foursquare_client_secret)&v=\(version)")
        
        var data = NSData(contentsOfURL: url!)
        
        let jsonError: NSError?
        
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            
                let response = json["response"] as! NSDictionary
                let groups = response["groups"] as! NSArray
                let recommended = groups[0] as! NSDictionary
                let items = recommended["items"] as! NSArray
                
                for item in items {
                    // venue is one restaurant
                    let venue: NSDictionary = (item["venue"] as? NSDictionary)!
                    var checkpoint: String = venue["id"] as! String
                    
                    // check if it already exists
                    var query = PFQuery(className:"Place")
                    
                    query.whereKey("foursquare_id", equalTo: "\(checkpoint)")
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            // The find succeeded.
                            println("Retrieved \(objects!.count) places.")
                            
//                            // Do something with the found objects
//                            if let objects = objects as? [PFObject] {
//                                for object in objects {
//                                    println(object["name"])
//                                }
//                            }
                            if (objects!.count == 0) {
                                // save new entries
                                println("creating new object")
                                var place = PFObject(className:"Place")
                                
                                place["foursquare_id"] = venue["id"]
                                
                                place["name"] = venue["name"]
                                
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
                                        place["formatted_address"] = join(" ", address) as String
                                        
                                    }
                                    
                                }
                                place["instagram_id"] = self.getInstagramId(checkpoint)
                                
                                place.saveInBackgroundWithBlock {
                                    (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                        println("Success!")
                                    } else {
                                        println("There was a problem!")
                                    }
                                }
                                
                            }
                            
                        } else {
                            // Log details of the failure
                            println("Error: \(error!) \(error!.userInfo!)")
                            
                            
                        }
                    }
            }
        }
    }
    
    func getInstagramId(checkpoint:String) -> String? {
        
        //  standard base
        let url = NSURL(string: "https://api.instagram.com/v1/locations/search?foursquare_v2_id=\(checkpoint)&access_token=\(instagram_access_token)")
        
        var data = NSData(contentsOfURL: url!)
        
        // Create another error optional
        var jsonerror:NSError?
        
        if let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonerror) as? NSDictionary {
            
            let data = json["data"] as! NSArray
            let info = data[0] as! NSDictionary
            return info["id"] as! String?
        }
        
        return ""
    }
    
    func getInstagramData(instagram_id:String) -> Void {
        
        var glanceOfPlaceImageView: UIImageView!
        var scrollViewContentSize:CGFloat = 0
        
        picturesScrollView.backgroundColor = UIColor.orangeColor()
        picturesScrollView.frame = self.view.bounds

        
        if let url = NSURL(string: "https://api.instagram.com/v1/locations/\(instagram_id)/media/recent?access_token=\(instagram_access_token)") {
            
            var contents = NSData(contentsOfURL: url)
        
            // Create another error optional
            var jsonerror:NSError?
            
            if let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(contents!, options: NSJSONReadingOptions.MutableContainers, error: &jsonerror) as? NSDictionary {
                
                let instas = json["data"] as! NSArray
                
                for insta in instas {
                
                    let pictures = insta["images"] as! NSDictionary!
                    let standard_res = pictures["standard_resolution"] as! NSDictionary!
    
                    let url = NSURL(string: standard_res["url"] as! String!)
                    let data = NSData(contentsOfURL: url!)
                    
                    if data != nil {
                        
                        glanceOfPlaceImageView = UIImageView(image: UIImage(data:data!))
                        glanceOfPlaceImageView.frame.origin.y = scrollViewContentSize
                        scrollViewContentSize += glanceOfPlaceImageView.bounds.height
                        picturesScrollView.contentOffset.y = 20
                        picturesScrollView.addSubview(glanceOfPlaceImageView)
                        println(scrollViewContentSize)

                    }
                    picturesScrollView.contentSize.width = view.bounds.size.width
                    picturesScrollView.contentSize.height = scrollViewContentSize
                    picturesScrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                   
                    view.addSubview(picturesScrollView)
                    
                }
                
            }
        }
    }

}

