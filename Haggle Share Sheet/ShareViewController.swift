//
//  ShareViewController.swift
//  Haggle Share Sheet
//
//  Created by Austin Chan on 12/19/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit
import Social

@objc(ShareViewController)

class ShareViewController: UIViewController {

    var darken: UIView!
    var sheet: UIView!
    
    /*
    |--------------------------------------------------------------------------
    | INITIALIZATION
    |--------------------------------------------------------------------------
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    /*
    |--------------------------------------------------------------------------
    | RENDERING
    |--------------------------------------------------------------------------
    */

    func render() {
        renderDarken()
        
        /* SHEET */
        renderSheet()
        animateComponents(true)
    }
    
    func renderDarken() {
        darken = UIView(frame: CGRectMake(0, 0, 0, 0))
        darken.backgroundColor = UIColor(white: 0.1, alpha: 1)
        darken.alpha = 0
        darken.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(darken)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[darken]-0-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["darken": darken]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[darken]-0-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["darken": darken]))
    }
    
    func renderSheet() {
        /* GENERATE SHEET */
        sheet = UIView(frame: CGRectMake(0, 0, 278, 0))
        sheet.backgroundColor = UIColor(white: 239/255.0, alpha: 0.88)
        sheet.layer.cornerRadius = 5
        sheet.transform = CGAffineTransformMakeTranslation(0, view.frame.size.height);
        sheet.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(sheet)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[sheet(278)]", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["sheet": sheet]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sheet(278)]", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["sheet": sheet]))
        view.addConstraint(NSLayoutConstraint(item: sheet, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: sheet, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))

        /* ADD TITLE TO SHEET */
        let navLabel: UILabel = UILabel(frame: CGRectZero)
        navLabel.font = UIFont.boldSystemFontOfSize(28)
        navLabel.textColor = UIColor(white: 117/255.0, alpha: 1)
        navLabel.text = "spark"
        navLabel.textAlignment = NSTextAlignment.Center
        navLabel.sizeToFit()
        navLabel.frame.origin.y = 14
        navLabel.center.x = sheet.frame.width / 2
        sheet.addSubview(navLabel)
        
        /* THIN LINE */
        let thinLine = UIView(frame: CGRectMake(0, 48, sheet.frame.width, 1))
        thinLine.backgroundColor = UIColor(white: 189/255.0, alpha: 1)
        sheet.addSubview(thinLine)
        
        /* TOP LINE */
        let topLine = UIView(frame: CGRectMake(0, 0, sheet.frame.width, 4))
        topLine.backgroundColor = UIColor.redColor()
        sheet.addSubview(topLine)
        
        /* CANCEL BUTTON */
        let cancel = UIButton()
        cancel.setTitle("Cancel", forState: UIControlState.Normal)
        cancel.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        cancel.setTitleColor(UIColor(white: 185/255.0, alpha: 1), forState: UIControlState.Normal)
        cancel.frame = CGRectMake(0, 2, 88, 44)
        cancel.addTarget(self, action: "cancelTapped", forControlEvents: UIControlEvents.TouchUpInside)
        sheet.addSubview(cancel)
        
        let next = UIButton()
        next.setTitle("Next", forState: UIControlState.Normal)
        next.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        next.backgroundColor = UIColor(red: 214/255.0, green: 97/255.0, blue: 98/255.0, alpha: 1)
        next.frame = CGRectMake(sheet.frame.width - 100 - 5, 5, 100, 40)
        sheet.addSubview(next)

    }
    
    /*
    |--------------------------------------------------------------------------
    | ANIMATING
    |--------------------------------------------------------------------------
    */

    func animateComponents(enter: Bool) {
        if enter {
            /* FADE IN DARKEN */
            UIView.animateWithDuration(0.4, animations: {
                self.darken.alpha = 0.82
            })
            
            /* SLIDE UP SHEET */
            UIView.animateWithDuration(0.63, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.allZeros, animations: {
                self.sheet.transform = CGAffineTransformIdentity
            }, completion: nil)
        } else {
            /* FADE OUT DARKEN AND COMPLETE SHARE EXTENSION */
            UIView.animateWithDuration(0.4, animations: {
                self.darken.alpha = 0
            }, completion: { (_) in
                self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
            })
            
            /* SLIDE DOWN SHEET */
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.allZeros, animations: {
                self.sheet.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
                }, completion: nil)
        }
    }
    
    /*
    |--------------------------------------------------------------------------
    | HANDLERS
    |--------------------------------------------------------------------------
    */

    func cancelTapped() {
        animateComponents(false)
    }

}
