//
//  FeedLinkCard.swift
//  Haggle
//
//  Created by Austin Chan on 12/31/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit

class FeedLinkCard: UITableViewCell {
    @IBOutlet weak var region: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var providerArea: UIView!
    
    @IBOutlet weak var imageMargin: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var snapBehavior: UISnapBehavior!
    var _originalY: CGFloat!
    
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
        region.layer.cornerRadius = 3
        region.layer.shadowColor = UIColor(white: 131/255.0, alpha: 1.0).CGColor
        region.layer.shadowRadius = 2
        region.layer.shadowOpacity = 0.27
        
        providerArea.layer.cornerRadius = 3
        
        let gesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        gesture.delegate = self
        self.addGestureRecognizer(gesture)
        
        animator = UIDynamicAnimator(referenceView: self)
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func render(post: Post) {
        animator.removeAllBehaviors()

        Utils.delay(0, closure: {
            var offset = CGRectOffset(self.region.bounds, 0, 4)
            self.region.layer.shadowPath = UIBezierPath(rect: offset).CGPath
        })
        
        titleLabel.text = post.title
        
        let providerImage = providerArea.viewWithTag(1) as UIImageView!
        let providerTitle = providerArea.viewWithTag(2) as UILabel!
        let providerDisplay = providerArea.viewWithTag(3) as UILabel!
        providerTitle.text = post.urlTitle
        providerDisplay.text = post.providerDisplay
        
        if let favicon = post.favicon {
            Utils.downloadImage(NSURL(string: favicon)!, handler: { image, error in
                if error == nil {
                    providerImage.image = image

                }
            })
            
            imageWidth.constant = 24
            imageMargin.constant = 8
        } else {
            
            imageWidth.constant = 0
            imageMargin.constant = 4
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let translation = (gestureRecognizer as UIPanGestureRecognizer).translationInView(self)
        
        if abs(translation.x) > abs(translation.y) {
            return true
        }
        
        return false
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.locationInView(contentView)
        let regionLocation = recognizer.locationInView(region)
        
        if recognizer.state == UIGestureRecognizerState.Began {
            animator.removeAllBehaviors()
            
            _originalY = location.y
            let offset = UIOffsetMake(regionLocation.x - CGRectGetMidX(region.bounds), regionLocation.y - CGRectGetMidY(region.bounds));
            attachmentBehavior = UIAttachmentBehavior(item: region, offsetFromCenter: offset, attachedToAnchor: location)
            
            animator.addBehavior(attachmentBehavior)
        } else if recognizer.state == UIGestureRecognizerState.Changed {
            attachmentBehavior.anchorPoint = location

        } else if recognizer.state == UIGestureRecognizerState.Ended {
            animator.removeAllBehaviors()
            
            snapBehavior = UISnapBehavior(item: region, snapToPoint: contentView.center)
            snapBehavior.damping = 1.0
            animator.addBehavior(snapBehavior)
            
//            if recognizer.translationInView(self).y > 100 {
//                dismissAlert()
//            }
        }
    }
}
