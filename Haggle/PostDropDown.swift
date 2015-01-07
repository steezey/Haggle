//
//  PostDropDown.swift
//  Haggle
//
//  Created by Austin Chan on 1/2/15.
//  Copyright (c) 2015 Caffio. All rights reserved.
//

import UIKit

class PostDropDown: UIView {

    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var linkButton: UIButton!
    
    var parent: ItemController!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepare()
    }
    
    func prepare() {
        self.backgroundColor = UIColor(white: 33/255.0, alpha: 0.87)
        self.clipsToBounds = true
        
        textButton.setTitle("\u{e600}", forState: UIControlState.Normal)
        photoButton.setTitle("\u{e609}", forState: UIControlState.Normal)
        musicButton.setTitle("\u{e607}", forState: UIControlState.Normal)
        linkButton.setTitle("\u{e60d}", forState: UIControlState.Normal)
    }

    @IBAction func testTapped(sender: AnyObject) {
        parent.triggerNewTextPost()
    }
}
