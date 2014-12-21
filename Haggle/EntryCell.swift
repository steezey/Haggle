//
//  EntryCell.swift
//  Haggle
//
//  Created by Austin Chan on 12/19/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit

/*
|--------------------------------------------------------------------------
| CELL DIMENSIONS CALCULATIONS
|--------------------------------------------------------------------------
*/

func genTitleLabel(title: String, inCellWidth cellWidth: CGFloat) -> UILabel {
    let titleLabel = UILabel()
    let attrString = Utils.lineHeightAttributedText(title, height: 0)
    titleLabel.attributedText = attrString
    titleLabel.numberOfLines = 0
    titleLabel.lineBreakMode = .ByWordWrapping
    titleLabel.font = UIFont.boldSystemFontOfSize(21)
    titleLabel.frame = CGRectMake(0, 0, cellWidth - (lrMargin*2) - 25, CGFloat.max)
    titleLabel.sizeToFit()
    titleLabel.frame.origin = CGPointMake(lPadding, tpadding)
    return titleLabel
}

func genSourceLabel(source: String, inCellWidth cellWidth: CGFloat) -> UILabel {
    let sourceLabel = UILabel()
    sourceLabel.text = source
    sourceLabel.font = UIFont.boldSystemFontOfSize(12)
    sourceLabel.frame = CGRectMake(0, 0, cellWidth - (lrMargin*2) - 25, CGFloat.max)
    sourceLabel.textColor = UIColor(red: 185/255.0, green: 185/255.0, blue: 185/255.0, alpha: 1)
    sourceLabel.sizeToFit()
    return sourceLabel
}

let lrMargin: CGFloat = 13
let tbMargin: CGFloat = 4
let lPadding: CGFloat = 13
let tpadding: CGFloat = 29
let bpadding: CGFloat = 14
let middleSpacing: CGFloat = 27

class EntryCell: UITableViewCell {

    var card: UIView!
    
    /*
    |--------------------------------------------------------------------------
    | INITIALIZATION
    |--------------------------------------------------------------------------
    */
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    |--------------------------------------------------------------------------
    | CLASS FUNCTIONS
    |--------------------------------------------------------------------------
    */
    
    class func calculateHeight(item: [String:String], width: CGFloat) -> CGFloat {
        let title = item["title"] as String!
        let source = item["source"] as String!
        let titleHeight = genTitleLabel(title, inCellWidth: width).frame.size.height
        let sourceHeight = genSourceLabel(source, inCellWidth: width).frame.size.height
        return titleHeight + sourceHeight + (tpadding + bpadding) + middleSpacing + (tbMargin*2)
    }
    
    /*
    |--------------------------------------------------------------------------
    | RENDERING
    |--------------------------------------------------------------------------
    */

    func render(title: String, color: String, andSource source: String) {
        
        if card != nil {
            card.removeFromSuperview()
        } else {
        /* BACKGROUND COLOR */
            self.backgroundColor = UIColor.clearColor()
            self.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        /* CARD */
        card = UIView(frame: CGRectMake(lrMargin, tbMargin, frame.size.width - (lrMargin*2), 0))
        card.backgroundColor = UIColor.whiteColor()
        card.layer.cornerRadius = 2
        
        /* CARD TITLE */
        let titleLabel = genTitleLabel(title, inCellWidth: frame.size.width)
        card.addSubview(titleLabel)
        
        /* CARD SOURCE */
        let sourceLabel = genSourceLabel(source, inCellWidth: frame.size.width)
        sourceLabel.frame.origin = CGPointMake(lPadding, titleLabel.frame.size.height + titleLabel.frame.origin.y + middleSpacing)
        card.addSubview(sourceLabel)
        
        /* CARD FLARE */
        let flare = UIView(frame: CGRectMake(8, 0, 50, 5))
        flare.backgroundColor = UIColor(rgba: "#" + color)
        card.addSubview(flare)
        
        /* CARD HEIGHT */
        card.frame.size.height = titleLabel.frame.height + sourceLabel.frame.height + (tpadding + bpadding) + middleSpacing
        
        contentView.addSubview(card)
    }

}