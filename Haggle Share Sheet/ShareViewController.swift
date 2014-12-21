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

class ShareViewController: UIViewController {

    var darken: UIView!
    var sheet: UIView!
    var next: UIButton!
    var spinner: UIActivityIndicatorView!
    var shareItem: Item!
    
    let defaultDim: CGFloat = 278
    
    /*
    |--------------------------------------------------------------------------
    | INITIALIZATION
    |--------------------------------------------------------------------------
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        
        fetchAndAnalyzeLink()
    }
    
    /*
    |--------------------------------------------------------------------------
    | RENDERING
    |--------------------------------------------------------------------------
    */

    func render() {
        renderDarken()
        renderSheet()

        animateComponents(true, withExitOnDone: false)
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
        sheet.backgroundColor = UIColor(white: 239/255.0, alpha: 0.85)
        sheet.layer.cornerRadius = 5
        sheet.transform = CGAffineTransformMakeTranslation(0, view.frame.size.height);
        sheet.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(sheet)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[sheet(278)]", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["sheet": sheet]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sheet(278)]", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["sheet": sheet]))
        view.addConstraint(NSLayoutConstraint(item: sheet, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: sheet, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))

        /* ADD TITLE TO SHEET */
        let titleLabel: UILabel = UILabel(frame: CGRectZero)
        titleLabel.font = UIFont.boldSystemFontOfSize(28)
        titleLabel.textColor = UIColor(white: 117/255.0, alpha: 1)
        titleLabel.text = "spark"
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.sizeToFit()
        titleLabel.frame.origin.y = 8
        titleLabel.center.x = sheet.frame.width / 2
        sheet.addSubview(titleLabel)
        
        /* THIN LINE */
        let thinLine = UIView(frame: CGRectMake(0, 48, sheet.frame.width, 1))
        thinLine.backgroundColor = UIColor(white: 189/255.0, alpha: 1)
        sheet.addSubview(thinLine)
        
        /* TOP LINE */
        let topLine = UIView(frame: CGRectMake(0, 0, sheet.frame.width, 4))
//        topLine.backgroundColor = UIColor.redColor()
        sheet.addSubview(topLine)
        
        /* CANCEL BUTTON */
        let cancel = UIButton()
        cancel.setTitle("Cancel", forState: UIControlState.Normal)
        cancel.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        cancel.setTitleColor(UIColor(white: 155/255.0, alpha: 1), forState: UIControlState.Normal)
        cancel.setTitleColor(UIColor(white: 203/255.0, alpha: 1), forState: UIControlState.Highlighted)
        cancel.frame = CGRectMake(0, 6, 84, 42)
        cancel.addTarget(self, action: "cancelTapped", forControlEvents: UIControlEvents.TouchUpInside)
        sheet.addSubview(cancel)
        
        let buttonWidth: CGFloat = 58
        let buttonHeight: CGFloat = 32
        
        /* NEXT BUTTON */
        next = UIColoredButton(baseColor: UIColor(red: 214/255.0, green: 97/255.0, blue: 98/255.0, alpha: 1), highlightColor: UIColor(red: 240/255.0, green: 198/255.0, blue: 199/255.0, alpha: 1))
        next.layer.cornerRadius = 4
        next.setTitle("Next", forState: UIControlState.Normal)
        next.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        next.backgroundColor = UIColor(red: 214/255.0, green: 97/255.0, blue: 98/255.0, alpha: 1)
        next.frame = CGRectMake(sheet.frame.width - buttonWidth - 8, 4 + (44 - buttonHeight)/2, buttonWidth, buttonHeight)
        next.alpha = 0.2
        next.addTarget(self, action: "nextTapped", forControlEvents: .TouchUpInside)
        next.enabled = false
        sheet.addSubview(next)
        
        /* SPINNER */
        spinner = UIActivityIndicatorView()
        spinner.center = CGPointMake(defaultDim/2, defaultDim/2)
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        sheet.addSubview(spinner)
        spinner.startAnimating()
    }
    
    /*
    |--------------------------------------------------------------------------
    | ANIMATING
    |--------------------------------------------------------------------------
    */

    func animateComponents(enter: Bool, withExitOnDone exitOnDone: Bool) {
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
                if exitOnDone {
                    self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
                }
            })
            
            /* SLIDE DOWN SHEET */
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.allZeros, animations: {
                self.sheet.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
                }, completion: nil)
        }
    }
    
    func enableNext() {
        next.enabled = true
        UIView.animateWithDuration(0.3, animations: {
            self.next.alpha = 1
        })
    }
    
    func showPreview() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        
        let lrPadding: CGFloat = 18
        let tbPadding: CGFloat = 12
        let bottomTitlePadding: CGFloat = 8
        let maxWidth: CGFloat = defaultDim - CGFloat(lrPadding * 2)
        let preview = UIView(frame: CGRectMake(0, 49, defaultDim, defaultDim - 49))
        sheet.addSubview(preview)
        
        let title = UILabel()
        title.attributedText = Utils.lineHeightAttributedText(shareItem.title, height: 0)
        title.font = UIFont.boldSystemFontOfSize(16)
        title.textColor = UIColor.blackColor()
        title.numberOfLines = 0
        title.lineBreakMode = NSLineBreakMode.ByWordWrapping
        title.frame = CGRectMake(lrPadding, tbPadding, maxWidth, 0)
        let titleSize = title.attributedText.boundingRectWithSize(CGSizeMake(title.frame.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        title.frame.size.height = titleSize.height
        preview.addSubview(title)
        
        let provider = UILabel()
        provider.text = shareItem.provider_display.uppercaseString
        provider.font = UIFont.boldSystemFontOfSize(12)
        provider.textColor = UIColor(white: 168/255.0, alpha: 1)
        provider.sizeToFit()
        provider.setTranslatesAutoresizingMaskIntoConstraints(false)
        preview.addSubview(provider)
        preview.addConstraint(NSLayoutConstraint(item: provider, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: title, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: bottomTitlePadding))
        preview.addConstraint(NSLayoutConstraint(item: provider, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: title, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))

        let maxContentHeight = (defaultDim - 49) - (provider.frame.height + title.frame.height + title.frame.origin.y + bottomTitlePadding + tbPadding)
        
        let content = UILabel()
        let contentText = shareItem.content.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
        content.attributedText = Utils.lineHeightAttributedText(contentText, height: 4)
        content.font = UIFont(name: "HoeflerText-Regular", size: 15)
        content.textColor = UIColor.blackColor()
        content.numberOfLines = 0
        content.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        content.setTranslatesAutoresizingMaskIntoConstraints(false)
        preview.addSubview(content)
        preview.addConstraint(NSLayoutConstraint(item: content, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: provider, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 2))
        preview.addConstraint(NSLayoutConstraint(item: content, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: provider, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        preview.addConstraint(NSLayoutConstraint(item: content, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: maxWidth))
        preview.addConstraint(NSLayoutConstraint(item: content, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: maxContentHeight))
    }
    
    /*
    |--------------------------------------------------------------------------
    | HANDLERS
    |--------------------------------------------------------------------------
    */

    func cancelTapped() {
        animateComponents(false, withExitOnDone: true)
    }
    
    
    
    func nextTapped() {
        animateComponents(false, withExitOnDone: false)
        submitEntry()
    }
    
    /*
    |--------------------------------------------------------------------------
    | DATA RETRIEVAL
    |--------------------------------------------------------------------------
    */
    
    func fetchAndAnalyzeLink() {
        var item: NSExtensionItem = self.extensionContext!.inputItems[0] as NSExtensionItem
        var itemProvider: NSItemProvider = item.attachments![0] as NSItemProvider
        
        if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            itemProvider.loadItemForTypeIdentifier("public.url", options: nil, completionHandler: {
                (urlItem, error) in
                var urlString = (urlItem as NSURL).absoluteString!
                self.analyzeLink(urlString)
            })
        }
    }
    
    func analyzeLink(link: String) {
        let parameters = ["url":link]
        Alamofire.request(.POST, "http://spikebackend.elasticbeanstalk.com/item", parameters: parameters)
            .responseJSON { (_, _, JSON, error) in
                if JSON == nil {
                    // extension request failed
                    self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
                } else {
                    let data = JSON as [String:String]
                    self.shareItem = Item(data: data)
                    
                    self.analysisDone()
                }
            }
    }
    
    func submitEntry() {
        var parameters = ["item_id":shareItem.id, "board_id":1]
        Alamofire.request(.POST, "http://spikebackend.elasticbeanstalk.com/entry", parameters: parameters)
            .responseJSON { (_, _, _, _) in
                self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        }
    }
    
    /*
    |--------------------------------------------------------------------------
    | STAGES
    |--------------------------------------------------------------------------
    */
    
    func analysisDone() {
        enableNext()
        showPreview()
    }

}
