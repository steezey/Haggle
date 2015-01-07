//
//  NewComment.swift
//  Haggle
//
//  Created by Austin Chan on 1/6/15.
//  Copyright (c) 2015 Caffio. All rights reserved.
//

import UIKit

class NewComment: UITableViewCell {
    
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var stickyButton: UIButton!
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var labelText: UILabel!
    
    var parent: FullPostView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepare()
    }
    
    func prepare() {
        icon.setTitle("\u{e602}", forState: UIControlState.Normal)
        stickyButton.setTitle("\u{e602}", forState: UIControlState.Normal)
        stickyButton.backgroundColor = UIColor(red: 214/255.0, green: 97/255.0, blue: 98/255.0, alpha: 1.0)

        selectionStyle = UITableViewCellSelectionStyle.None
        
        partTwoHidden(true)
        partTwoAlpha(0)
    }
    
    @IBAction func done(sender: AnyObject) {
        self.partOneHidden(false)
        UIView.animateWithDuration(0.25, animations: {
            self.partTwoAlpha(0)
            self.partOneAlpha(1)
        }, completion: { _ in
            self.partTwoHidden(true)
        })
        
        parent.postNewComment(textArea.text)
    }

    func expand() {
        partTwoHidden(false)
        UIView.animateWithDuration(0.1, animations: {
            self.partOneAlpha(0)
        })
        
        UIView.animateWithDuration(0.25, animations: {
            self.partTwoAlpha(1)
        }, completion: { _ in
            self.partOneHidden(true)
        })
    }
    
    func partOneAlpha(alpha: CGFloat) {
        icon.alpha = alpha
        labelText.alpha = alpha
    }
    
    func partOneHidden(hidden: Bool) {
        icon.hidden = hidden
        labelText.hidden = hidden
    }
    
    func partTwoAlpha(alpha: CGFloat) {
        textArea.alpha = alpha
        stickyButton.alpha = alpha
    }
    
    func partTwoHidden(hidden: Bool) {
        textArea.hidden = hidden
        stickyButton.hidden = hidden
    }
}