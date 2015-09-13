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

// protokol lets frontcard and backcard call functions defined in the swipeview protokol from the CardsViewController

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
    
    var backCard: Card?
    var frontCard: Card?
    
    var places: [Place]?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // this function is in Place.swift
        fetchAllPlaces({
            returnedPlaces in
            // self.places refers to var places: [Places]? set above
            self.places = returnedPlaces
            println(self.places)
            
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
        println("called createCard")
        
        let cardView = CardView()
        
        cardView.name = place.name
  
        place.getInstagramData( {
                returnedScrollView in
                println("I HAVE RETURNED SCROLL VIEW AND IT IS: ")
                println(returnedScrollView)
                cardView.picturesScroll = returnedScrollView
        })
        
        let swipeView = SwipeView(frame: createCardFrame(0))
        swipeView.delegate = self
        swipeView.innerView = cardView
        
        if cardView.picturesScroll != nil {
            println("before I create the Card, picturesScroll is not empty")
        }
        
        return Card(cardView: cardView, swipeView: swipeView, place: place)
    }
    
    private func popCard() -> Card? {
        if places != nil && places?.count > 0 {
            return createCard(places!.removeLast())
        }
        return nil
    }
    
    // Mark: SwipeViewDelegate
    
    func swipedLeft() {
        println("left")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
        }
    }
    
    func swipedRight() {
        println("right")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
        }
    }


}
