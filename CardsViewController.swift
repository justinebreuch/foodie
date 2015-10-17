//
//  CardsViewController.swift
//  Foodie
//
//  Created by Justine Breuch on 9/2/15.
//  Copyright (c) 2015 Justine Breuch. All rights reserved.
//

import UIKit
import Bolts
import Parse

// protocol lets frontcard and backcard call functions defined in the swipeview protokol from the CardsViewController

class CardsViewController: UIViewController, SwipeViewDelegate {
    
    private
    let foursquare_client_id="XPVBDQQX3N4FUYXXLN52XCTT1GKPITP0LCYLTZ0YDNBZMLG1"
    let foursquare_client_secret="CCNVMMJG21Y4HCIFSVJGS4BPZGKLTCMUBCUYWVG4JYLWR0TZ"
    let instagram_access_token = "11905781.47733f8.af1a1a2e06fb4c90b6c6804612fc495d"
    
    struct Card {
        let cardView: CardView
        let swipeView: SwipeView
        let place: Place
        
        // add user at a later time
    }
    
    let frontCardTopMargin: CGFloat = 0
    let backCardTopMargin: CGFloat = 10
    
    @IBOutlet weak var cardStackView: UIView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var oneStarImage: UIImageView!
    @IBOutlet weak var twoStarImage: UIImageView!
    @IBOutlet weak var threeStarImage: UIImageView!
    @IBOutlet weak var fourStarImage: UIImageView!
    @IBOutlet weak var fiveStarImage: UIImageView!
    
    var backCard: Card?
    var frontCard: Card?
    
    var places: [Place]?
    var placesInfo = [Place]()
    
//    private var current_place: Place?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        // this function is in Place.swift
        fetchAllPlaces({
            
            returnedPlaces in
            
            // self.places refers to var places: [Places]? set above
            self.places = returnedPlaces
            
            // UNCOMMENT for swipeview
            if let card = self.popCard() {
                self.frontCard = card
                self.cardStackView.addSubview(self.frontCard!.swipeView)
            
            }
            
            if let card = self.popCard() {
                self.backCard = card
                self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
                self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
        
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createCardFrame(topMargin:CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    private func createCard(place: Place) -> Card {
        
        let swipeView = SwipeView(frame: createCardFrame(0))
        let cardView = CardView(frame: CGRect(x: 0, y: 0, width: swipeView.bounds.width, height: swipeView.bounds.height))

        restaurantNameLabel.text = place.name.uppercaseString
        
        oneStarImage.image = UIImage(contentsOfFile: "empty_rating")
        twoStarImage.image = UIImage(contentsOfFile: "empty_rating")
        threeStarImage.image = UIImage(contentsOfFile: "empty_rating")
        fourStarImage.image = UIImage(contentsOfFile: "empty_rating")
        fiveStarImage.image = UIImage(contentsOfFile: "empty_rating")

        print("place.name is " + place.name)
        cardView.setScrollView(place.getData())
        
        placesInfo.append(place)
        
        print(placesInfo.last)
        
        swipeView.delegate = self
        swipeView.innerView = cardView
        
        
        return Card(cardView: cardView, swipeView: swipeView, place: place)
    }
    
    private func popCard() -> Card? {
        
        if places != nil && places?.count > 0 {
            return createCard(places!.removeLast())
        }
        return nil
    }
    
    private func updateRestaurantInfo() {
        placesInfo.removeLast()
        restaurantNameLabel.text = placesInfo.last!.name.uppercaseString
        
    }
    
    
    // Mark: SwipeViewDelegate
    
    func swipedLeft() {
        
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            updateRestaurantInfo()
        }
    }
    
    func swipedRight() {

        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            updateRestaurantInfo()
        }
    }


}
