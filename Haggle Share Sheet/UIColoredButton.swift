//
//  UIColoredButton.swift
//  Haggle
//
//  Created by Austin Chan on 12/20/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit

class UIColoredButton: UIButton {
    var baseColor: UIColor?
    var highlightColor: UIColor?
    
    override var highlighted: Bool {
        didSet {
            if oldValue != highlighted {
                if self.highlighted {
                    UIView.animateWithDuration(0.05, animations: {
                        self.backgroundColor = self.highlightColor
                    })
                } else {
                    UIView.animateWithDuration(0.2, animations: {
                        self.backgroundColor = self.baseColor
                    })
                }
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init() {
        super.init()
    }
    
    convenience init(baseColor: UIColor, highlightColor: UIColor) {
        self.init()
        self.backgroundColor = baseColor
        self.baseColor = baseColor
        self.highlightColor = highlightColor
    }
}