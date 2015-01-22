//
//  ViewController.swift
//  StarBadgeView
//
//  Created by Cem Olcay on 26/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let star = StarBadgeView (frame: CGRect (x: 0, y: 30, width: 100, height: 100), color: UIColor.blueColor())
        setCenterX(star)
        addTextToBadge(star)

        star.addShadow(CGSize (width: 5, height: 5), radius: 1, color: UIColor.blackColor(), opacity: 0.3)
        view.addSubview(star)
        
        let s = StarBadgeView (frame: CGRect (x: 0, y: 150, width: 150, height: 150), color: UIColor.redColor())
        setCenterX(s)
        addTextToBadge(s)
        s.rotationAngle = 0
        view.addSubview(s)
    }
    
    func badgeStuff () {
        
    }
    
    func addTextToBadge (badge: StarBadgeView) {
        let smallFont = UIFont (name: "HelveticaNeue", size: 15)!
        let bigFont = UIFont (name: "HelveticaNeue-Medium", size: 20)!
        
        let smallText = "100 TL"
        let bigText = "20 TL"
        
        badge.addAttributedTextLine(BadgeLabelLine(text: "Text", font: UIFont.boldSystemFontOfSize(13), color: UIColor.whiteColor(), strike: true))
        badge.addAttributedTextLine(BadgeLabelLine(text: smallText, font: smallFont, color: UIColor.whiteColor(), strike: true))
        badge.addAttributedTextLine(BadgeLabelLine(text: bigText, font: bigFont, color: UIColor.whiteColor()))
    }
    
    func setCenterX (v: UIView) {
        v.center = CGPoint (x: view.center.x, y: v.center.y)
    }
    
    func below (v: UIView, offset: CGFloat) -> CGFloat {
        return v.frame.origin.y + v.frame.size.height + offset
    }
}

