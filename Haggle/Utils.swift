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
    static var uuid: String = NSUUID().UUIDString
}