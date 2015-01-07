//
//  Utils.swift
//  Haggle
//
//  Created by Austin Chan on 12/19/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit

struct Utils {
    static var screenSize: CGSize = UIScreen.mainScreen().bounds.size
    
    static func lineHeightAttributedText(string: String, height: CGFloat) -> NSMutableAttributedString {
        var paragraphStyle = NSMutableParagraphStyle(); paragraphStyle.lineSpacing = height; paragraphStyle.maximumLineHeight = 0
        var attrString = NSMutableAttributedString(string: string);attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        return attrString
    }
    
    static var uuid: String {
        let userDefaults = NSUserDefaults(suiteName: "group.com.caffio.Haggle")!
        var uuid: String
        if userDefaults.objectForKey("uuid") == nil {
            uuid = NSUUID().UUIDString
            userDefaults.setObject(uuid, forKey: "uuid")
            userDefaults.synchronize()
        } else {
            uuid = userDefaults.objectForKey("uuid") as String!
        }
        
        return uuid
    }
    
    static func downloadImage(url: NSURL, handler: ((image: UIImage, NSError!) -> Void)) {
        var imageRequest: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(imageRequest,
            queue: NSOperationQueue.mainQueue(),
            completionHandler:{response, data, error in
                handler(image: UIImage(data: data)!, error)
        })
    }
    
    static func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    static func typeOfItem(item: [String:AnyObject]) -> String {
        if let url = item["url"] {
            return "link"
        }
        return "text"
    }
}