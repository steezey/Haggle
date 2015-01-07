//
//  NewPostView.swift
//  Haggle
//
//  Created by Austin Chan on 12/30/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit
import Snappy
import Alamofire

class NewPostView: UIView, UITextViewDelegate {
    
    var post: Post!
    var parent: ItemController!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var concealingBar: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sheet: UIView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var titlePlaceholder: UILabel!
    @IBOutlet weak var providerInfoView: UIView!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var contentPlaceholder: UILabel!
    @IBOutlet weak var inner: UIView!
    @IBOutlet weak var boardStrip: UIView!

    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageMargin: NSLayoutConstraint!
    @IBOutlet weak var providerMargin: NSLayoutConstraint!

    var blur: UIVisualEffectView!
    var loadingController = UIAlertController(title: "Posting...", message: "", preferredStyle: UIAlertControllerStyle.Alert)

    let linkSource = "http://spurt.elasticbeanstalk.com/link-posts/publish"
    let textSource = "http://spurt.elasticbeanstalk.com/text-posts/create-and-publish"

    var type: String!

    func unprepare() {
        self.endEditing(true)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func close(sender: UIButton) {
        unprepare()
        
        animateOut()
    }
    
    @IBAction func post(sender: UIButton) {
        unprepare()
        
        let title = titleTextView.text
        let description = contentView.text
        
        if title == "" || countElements(description) > 300 {
            return
        }
        
        parent.presentViewController(loadingController, animated: true, completion: nil)
        
        if type == "text" {
            var parameters = ["uuid":Utils.uuid, "title":title, "description":description]
            Alamofire.request(.POST, self.textSource, parameters: parameters)
                .responseJSON { (a, r, b, e) in
                    println(b)
//                    self.parent.receivePostedId(id, type: type)
                    self.parent.dismissViewControllerAnimated(true, completion: nil)
                    self.animateOut()
                }
        } else if type == "link" {
            let id = post.id as NSNumber

            var parameters = ["uuid":Utils.uuid, "id":id, "title":title, "description":description]
            Alamofire.request(.POST, self.linkSource, parameters: parameters)
                .responseJSON { (a, r, b, e) in
                    self.parent.receivePostedId(id, type: self.type)
                    self.parent.dismissViewControllerAnimated(true, completion: nil)
                    self.animateOut()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(Utils.screenSize.width, Utils.screenSize.height)
    }
    
    func prepareView() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        closeButton.setTitle("\u{e606}", forState: UIControlState.Normal)
        
        sheet.layer.cornerRadius = 3
        titleTextView.delegate = self
        titleTextView.textContainerInset = UIEdgeInsetsMake(18, 12, 14, 10)
        
        contentView.textContainerInset = UIEdgeInsetsMake(14, 12, 5, 12)
        contentView.delegate = self
        
        blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blur.frame = self.bounds
        blur.alpha = 0
        self.addSubview(blur)
        self.sendSubviewToBack(blur)
        
        inner.snp_makeConstraints { make in
            make.width.equalTo(Utils.screenSize.width)
            make.height.equalTo(Utils.screenSize.height)
            return
        }

//        concealingBar.backgroundColor = UIColor(white: 105/255.0, alpha: 0.97)
//        concealingBar.layer.shadowColor = UIColor(white: 132/255.0, alpha: 0.23).CGColor
//        concealingBar.layer.shadowOffset = CGSizeMake(0, 3)
//        concealingBar.layer.shadowOpacity = 0.3
//        concealingBar.layer.shadowRadius = 3
        
        animateIn()
    }
    
    func animateIn() {
        self.titleTextView.becomeFirstResponder()
        self.backgroundColor = UIColor.clearColor()
        self.concealingBar.alpha = 0
        UIView.animateWithDuration(0.4, animations: {
            self.backgroundColor = UIColor(white: 82/255.0, alpha: 1)
            self.blur.alpha = 1
            self.concealingBar.alpha = 1
        }, completion: { (_) in
            
        })
        
        sheet.transform = CGAffineTransformMakeTranslation(0, Utils.screenSize.height)
        UIView.animateWithDuration(0.65, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.allZeros, animations: {
            self.sheet.transform = CGAffineTransformIdentity
        }, completion: { _ in

        })
    }
    
    func animateOut() {
        concealingBar.alpha = 1
        UIView.animateWithDuration(0.37, delay: 0.1, options: UIViewAnimationOptions.allZeros, animations: {
            self.backgroundColor = UIColor.clearColor()
            self.blur.alpha = 0
            self.concealingBar.alpha = 0
        }, completion: { _ in
            
        })

        UIView.animateWithDuration(0.52, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.allZeros, animations: {
            self.sheet.transform = CGAffineTransformMakeTranslation(0, Utils.screenSize.height)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    func renderLinkPost(post: Post, parent: ItemController) {
        type = "link"
        self.parent = parent
        self.post = post
        
        /* Provider Info */
        let providerTitle = providerInfoView.viewWithTag(1) as UILabel
        let providerImage = providerInfoView.viewWithTag(2) as UIImageView
        let providerDisplay = providerInfoView.viewWithTag(3) as UILabel
        providerTitle.text = post.urlTitle as String!
        
        if let favicon = post.favicon {
            Utils.downloadImage(NSURL(string: favicon)!, handler: { image, error in
                providerImage.image = image
                providerImage.alpha = 0
                UIView.animateWithDuration(0.27, animations: {
                    providerImage.alpha = 1
                })
            })
        } else {
            
            imageWidth.constant = 0
            imageMargin.constant = -2
        }

        providerDisplay.text = post.providerDisplay as String!
        
        render()
    }
    
    func renderTextPost(parent: ItemController) {
        type = "text"
        self.parent = parent

        providerInfoView.removeFromSuperview()
        
        titleTextView.snp_makeConstraints { make in
            make.bottom.equalTo(self.boardStrip.snp_top)
            return
        }
//        providerInfoView.snp_makeConstraints { make in
//            make.height.equalTo(0)
//            return
//        }
//        providerMargin.constant = 0
//        providerInfoView.hidden = true
        
        render()
    }
    
    func render() {
        sheet.snp_makeConstraints { make in
            make.width.equalTo(Utils.screenSize.width - 16)
            return
        }
        
        self.invalidateIntrinsicContentSize()
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView == titleTextView {
            if textView.text == "" {
                titlePlaceholder.alpha = 1
            } else {
                titlePlaceholder.alpha = 0
            }
            
        } else if textView == contentView {
            if textView.text == "" {
                contentPlaceholder.alpha = 1
            } else {
                contentPlaceholder.alpha = 0
            }
        }
        
        counter.text = String(300 - countElements(textView.text))
    }
    
    func keyboardShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        inner.snp_remakeConstraints { make in
            make.height.equalTo(Utils.screenSize.height - keyboardFrame.height)
            make.width.equalTo(Utils.screenSize.width)
            return
        }
    }
    
    func keyboardHide(notification: NSNotification) {
        inner.snp_remakeConstraints { make in
            make.height.equalTo(Utils.screenSize.height)
            make.width.equalTo(Utils.screenSize.width)
            return
        }
    }
    
}