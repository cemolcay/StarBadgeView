//
//  StarBadgeView.swift
//  StarBadgeView
//
//  Created by Cem Olcay on 26/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import UIKit

struct BadgeLabelLine {
    var text: String
    var font: UIFont
    var color: UIColor
    var strike: Bool
    
    init (text: String, font: UIFont, color: UIColor, strike: Bool = false) {
        self.text = text
        self.font = font
        self.color = color
        self.strike = strike
    }
    
    func count () -> Int {
        return countElements(text)
    }
}

class StarBadgeView: UIView {
    
    private var badgeLayer: CAShapeLayer!
    var color: UIColor!
    
    var rotationAngle: CGFloat = 25 {
        didSet{
            self.setRotation(rotationAngle)
        }
    }
    
    override var frame: CGRect {
        didSet {
            if let badge = badgeLayer {
                badgeLayer.removeFromSuperlayer()
                badgeLayer = nil
                setupBadgeLabel()
                
                badgeLabel.frame = frame
            }
        }
    }
    
    
    
    // MARK: Label
    
    var badgeLabel: UILabel!
    
    var text: String? {
        didSet {
            badgeLabel.text = text
        }
    }
    
    var font: UIFont? {
        didSet {
            badgeLabel.font = font
        }
    }
    
    var textColor: UIColor? {
        didSet {
            badgeLabel.textColor = textColor
        }
    }
    
    var attributedText: NSAttributedString? {
        didSet {
            badgeLabel.attributedText = attributedText
        }
    }
    
    func addAttributedTextLine (line: BadgeLabelLine) {
        
        var string = badgeLabel.text == nil ? "" : badgeLabel.text! + "\n"
        let newString = string + line.text
        let range = NSRange(location: countElements(string), length: line.count())
        var att: NSMutableAttributedString?
        
        if let a = badgeLabel.attributedText {
            att = NSMutableAttributedString (attributedString: a)
            att?.appendAttributedString(NSAttributedString (string: "\n" + line.text))
        } else {
            att = NSMutableAttributedString (string: newString)
        }
        
        att!.addAttribute(NSFontAttributeName, value: line.font, range: range)
        att!.addAttribute(NSForegroundColorAttributeName, value: line.color, range: range)
        
        if line.strike {
            att!.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: range)
            att!.addAttribute(NSStrikethroughColorAttributeName, value: line.color, range: range)
        }
        
        badgeLabel.attributedText = NSAttributedString (attributedString: att!)
    }
    
    
    
    // MARK: Lifecyle
    
    init (frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        
        self.color = color
        setupBadgeLabel()

        badgeLabel = UILabel (frame: frame)
        badgeLabel.textAlignment = NSTextAlignment.Center
        badgeLabel.numberOfLines = 0
        addSubview(badgeLabel)
        
        setRotation(rotationAngle)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    // MARK: BadgeLayer
    
    func setupBadgeLabel () {
        let star             = CAShapeLayer ()
        star.frame           = layer.frame

        let path             = UIBezierPath ()
        let offset           = CGPointMake(frame.width/2, frame.height/2)
        
        let r1               = frame.size.width/2
        let r2               = r1 - 20
        
        let npoints: CGFloat = self.frame.width
        let TWOPI: CGFloat   = CGFloat(M_PI * 2)
        
        for (var n: CGFloat = 0; n < npoints; n+=4) {
            let x1 = offset.x + sin((TWOPI/npoints) * n) * r2
            let y1 = offset.y + cos((TWOPI/npoints) * n) * r2
            
            if n==0 {
                path.moveToPoint(CGPoint (x: x1, y: y1))
            } else {
                path.addLineToPoint(CGPoint (x: x1, y: y1))
            }
            
            let x2 = offset.x + sin((TWOPI/npoints) * n+1) * r1
            let y2 = offset.y + cos((TWOPI/npoints) * n+1) * r1
            
            path.addLineToPoint(CGPoint (x: x2, y: y2))
            
            let x3 = offset.x + sin((TWOPI/npoints) * n+2) * r2
            let y3 = offset.y + cos((TWOPI/npoints) * n+2) * r2
            
            path.addLineToPoint(CGPoint (x: x3, y: y3))
        }
        path.closePath()

        star.path = path.CGPath
        star.fillColor = self.color.CGColor
        
        badgeLayer = star
        layer.insertSublayer(badgeLayer, atIndex: 0)
    }
    
    func rotateBadgeAnimation () -> CABasicAnimation {
        let anim = CABasicAnimation (keyPath: "transform.rotation")
        anim.fromValue = degreesToRadians(0)
        anim.toValue =  degreesToRadians(360)
        
        anim.duration = 10
        anim.repeatCount = Float.infinity
        
        return anim
    }
    
    func scaleBadgeAnimation () -> CABasicAnimation {
        let anim = CABasicAnimation (keyPath: "transform.scale")
        anim.fromValue = 0.95
        anim.toValue = 1.05
        
        anim.duration = 1
        anim.repeatCount = Float.infinity
        anim.autoreverses = true
        
        return anim
    }
    
    func addShadow (offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float) {
        badgeLayer.shadowOffset = offset
        badgeLayer.shadowRadius = radius
        badgeLayer.shadowColor = color.CGColor
        badgeLayer.shadowOpacity = opacity
    }
    
    
    
    // MARK: Animations
    
    func rotateBadge () {
        let anim = rotateBadgeAnimation()
        badgeLayer.addAnimation(anim, forKey: "rotateBadge")
    }
    
    func scaleBadge () {
        let anim = scaleBadgeAnimation()
        badgeLayer.addAnimation(anim, forKey: "scaleBadge")
    }
    
    func animateBadge () {
        let rot = rotateBadgeAnimation()
        let sc = scaleBadgeAnimation()
        
        let anim = CAAnimationGroup ()
        anim.animations = [rot, sc]
        anim.duration = 10
        anim.repeatCount = Float.infinity
        
        badgeLayer.addAnimation(anim, forKey: "animateBadge")
    }
    
    
    
    // MARK: Helpers
    
    func degreesToRadians (angle: CGFloat) -> CGFloat {
        return (CGFloat (M_PI) * angle) / 180.0
    }
    
    func setRotation (x: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(x), 0.0, 0.0, 1.0)
        
        self.layer.transform = transform
    }
}
