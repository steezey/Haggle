//
//  ShareViewController.swift
//  Haggle Share Sheet
//
//  Created by Austin Chan on 12/19/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit
import Social
import Alamofire

@objc(ShareViewController)

class ShareViewController: UIViewController, UITextViewDelegate {
    
    let saveSource = "http://spurt.elasticbeanstalk.com/items/create"
    
    var darken: UIView!
    var sheet: UIView!
    
    var tapGesture: UITapGestureRecognizer!
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    /*
    |--------------------------------------------------------------------------
    | INITIALIZATION
    |--------------------------------------------------------------------------
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        render()

        darkenScreen()
        submitEntry()
        
    }
    
    /*
    |--------------------------------------------------------------------------
    | RENDERING
    |--------------------------------------------------------------------------
    */

    func render() {
        renderDarken()
        renderSheet()
        
        makeTapGesture()
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
        let lrPadding: CGFloat = 14
        let tbPadding: CGFloat = 12
        let buttonPadding: CGFloat = 5
        let buttonSize: CGFloat = 26
        let middlePadding: CGFloat = 7
        
        var label = UILabel(frame: CGRectMake(lrPadding, tbPadding, 0, 0))
        label.text = "Saved to Inbox!"
        label.textColor = UIColor(rgba: "#6D6D6D")
        label.font = UIFont(name: "AkzidenzGroteskBQ-Bold", size: 16)
        label.sizeToFit()
        label.frame.size.height = buttonSize
        
        var sheetWidth = lrPadding * 2 + label.frame.width + middlePadding + buttonPadding + buttonSize * 2
        var sheetHeight = tbPadding * 2 + buttonSize
        sheet = UIView(frame: CGRectMake(0, 0, sheetWidth, sheetHeight))
        sheet.backgroundColor = UIColor(white: 255/255.0, alpha: 0.85)
        sheet.layer.cornerRadius = 5
        sheet.transform = CGAffineTransformMakeScale(0, 0)
        sheet.addSubview(label)
        sheet.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(sheet)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[sheet(\(sheetWidth))]", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["sheet": sheet]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sheet(\(sheetHeight))]", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["sheet": sheet]))
        view.addConstraint(NSLayoutConstraint(item: sheet, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: sheet, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        
        var buttonFrame = CGRectMake(0, 0, buttonSize, buttonSize)
        let postButton = UIButton(frame: buttonFrame)
        postButton.frame.origin = CGPointMake(sheetWidth - lrPadding - buttonSize, tbPadding)
        postButton.layer.cornerRadius = 5
        postButton.backgroundColor = UIColor(red: 216/255.0, green: 96/255.0, blue: 96/255.0, alpha: 1)
        postButton.titleLabel?.font = UIFont(name: "icomoon", size: 16)
        postButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        postButton.setTitle("\u{e600}", forState: UIControlState.Normal)
        sheet.addSubview(postButton)

        let messageButton = UIButton(frame: buttonFrame)
        messageButton.frame.origin = CGPointMake(sheetWidth - lrPadding - buttonSize * 2 - buttonPadding, tbPadding)
        messageButton.layer.cornerRadius = 5
        messageButton.backgroundColor = UIColor(red: 216/255.0, green: 96/255.0, blue: 96/255.0, alpha: 1)
        messageButton.titleLabel?.font = UIFont(name: "icomoon", size: 16)
        messageButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        messageButton.setTitle("\u{e602}", forState: UIControlState.Normal)
        sheet.addSubview(messageButton)
        
    }
    
    func makeTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: "tapped")
        view.addGestureRecognizer(tapGesture)
    }
    
    func closeDelay() {
        delay(1.8, closure: {
            self.view.removeGestureRecognizer(self.tapGesture)
            self.animateOut()
        })
    }
    
    /*
    |--------------------------------------------------------------------------
    | ANIMATING
    |--------------------------------------------------------------------------
    */

    func darkenScreen() {
        /* FADE IN DARKEN */
        UIView.animateWithDuration(0.4, animations: {
            self.darken.alpha = 0.82
        })
    }
    
    func animateIn() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.allZeros, animations: {
            self.sheet.transform = CGAffineTransformMakeScale(1, 1)
        }, completion: nil)
        
        closeDelay()
    }
    
    func animateOut() {
        UIView.animateWithDuration(0.4, animations: {
            self.darken.alpha = 0
        }, completion: { (_) in
            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        })
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.allZeros, animations: {
            self.sheet.transform = CGAffineTransformMakeScale(0.01, 0.01)
        }, completion: { (_) in
            
        })
    }
    
    /*
    |--------------------------------------------------------------------------
    | HANDLERS
    |--------------------------------------------------------------------------
    */
    
    func tapped() {
        animateOut()
    }


    /*
    |--------------------------------------------------------------------------
    | DATA RETRIEVAL
    |--------------------------------------------------------------------------
    */
    
    func submitEntry() {
        var item: NSExtensionItem = self.extensionContext!.inputItems[0] as NSExtensionItem
        var itemProvider: NSItemProvider = item.attachments![0] as NSItemProvider

        if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            itemProvider.loadItemForTypeIdentifier("public.url", options: nil, completionHandler: {
                (urlItem, error) in
                var urlString = (urlItem as NSURL).absoluteString!
                var parameters = ["uuid":Utils.uuid, "url":urlString]
                Alamofire.request(.POST, self.saveSource, parameters: parameters)
                    .responseJSON { (a, r, b, e) in
                        self.animateIn()
                }
            })
        }
    }

}
