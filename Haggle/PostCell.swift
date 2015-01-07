//
//  PostCell.swift
//  Haggle
//
//  Created by Austin Chan on 12/31/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    var card: UIView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    /*
    |--------------------------------------------------------------------------
    | RENDERING
    |--------------------------------------------------------------------------
    */
    
    func render(cardView: UIView) {
        
        if card != nil {
            card.removeFromSuperview()
        } else {
            /* BACKGROUND COLOR */
            self.backgroundColor = UIColor.clearColor()
            self.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        cardView.frame = contentView.bounds
        contentView.addSubview(cardView)
        card = cardView
        println(contentView.subviews.count)
        
//        contentView.setNeedsUpdateConstraints()
//        contentView.setNeedsLayout()
//        contentView.updateConstraintsIfNeeded()
//        contentView.layoutIfNeeded()
    }
}