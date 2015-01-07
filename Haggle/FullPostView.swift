//
//  FullPostView.swift
//  Haggle
//
//  Created by Austin Chan on 1/6/15.
//  Copyright (c) 2015 Caffio. All rights reserved.
//

import UIKit

class FullPostView: UIView, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var ellipseButton: UIButton!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var bar: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var minitext: UILabel!
    @IBOutlet weak var grayArea: UIView!
    @IBOutlet weak var scroll: UITableView!
    @IBOutlet weak var grayInner: UIView!
    @IBOutlet weak var fixed: UIView!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    
    
    @IBOutlet var previewArea: UIView!
    @IBOutlet weak var previewFavicon: UIImageView!
    @IBOutlet weak var previewProvider: UILabel!
    @IBOutlet weak var previewTitle: UILabel!
    @IBOutlet weak var previewDate: UILabel!
    @IBOutlet weak var previewWeb: UIWebView!
    @IBOutlet weak var previewInner: UIView!

    @IBOutlet weak var previewWebHeight: NSLayoutConstraint!
    
    var parent: UIViewController!
    
    var thinBorder: CALayer!
    var thickBorder: CALayer!
    var previewBorder: CALayer!
    var commentBorder: CALayer!
    
    var post: Post!
    var grayHeight: CGFloat!
    var commentsOn: Bool = true
    
    var expandedNewComment: Bool = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        prepare()
    }
    
    @IBAction func close(sender: UIButton) {
        removeFromSuperview()
    }

    func prepare() {
        
        scroll.registerNib(UINib(nibName: "NewComment", bundle: nil), forCellReuseIdentifier: "NewComment")
        scroll.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        
        let topView = UIView(frame: CGRectMake(0, -300, Utils.screenSize.width, 300))
        topView.backgroundColor = UIColor(white: 243/255.0, alpha: 1)
        topView.userInteractionEnabled = false
        scroll.addSubview(topView)

        UIView.setAnimationsEnabled(false)
        
        heartButton.setTitle("\u{e60c}", forState: UIControlState.Normal)
        ellipseButton.setTitle("\u{e60a}", forState: UIControlState.Normal)
        bookmarkButton.setTitle("\u{e60b}", forState: UIControlState.Normal)
        xButton.setTitle("\u{e606}", forState: UIControlState.Normal)
        
        scroll.snp_makeConstraints { make in
            make.width.equalTo(Utils.screenSize.width)
            make.height.equalTo(Utils.screenSize.height)
            return
        }
        grayInner.snp_makeConstraints { make in
            make.width.equalTo(Utils.screenSize.width)
            return
        }
        previewInner.snp_makeConstraints { make in
            make.width.equalTo(Utils.screenSize.width)
            return
        }
        
        previewButton.setTitle("\u{e608}", forState: UIControlState.Normal)
        commentsButton.setTitle("\u{e602}", forState: UIControlState.Normal)
        
        previewButton.setTitleColor(UIColor(white: 216/255.0, alpha: 1), forState: UIControlState.Normal)
        commentsButton.setTitleColor(UIColor(white: 216/255.0, alpha: 1), forState: UIControlState.Normal)
        previewButton.setTitleColor(UIColor(white: 84/255.0, alpha: 1), forState: UIControlState.Selected)
        commentsButton.setTitleColor(UIColor(white: 84/255.0, alpha: 1), forState: UIControlState.Selected)
        previewButton.selected = true

        UIView.setAnimationsEnabled(true)
    }
    
    func makeThinBorder(button: UIButton) -> CALayer {
        var thinBorder = CALayer()
        thinBorder.frame = CGRectMake(0, button.frame.size.height - 1, button.frame.size.width, 1)
        thinBorder.backgroundColor = UIColor(white: 172/255.0, alpha: 1).CGColor
        return thinBorder
    }
    
    func makeThickBorder(button: UIButton) -> CALayer {
        var thickBorder = CALayer()
        thickBorder.frame = CGRectMake(0, button.frame.size.height - 2, button.frame.size.width, 2)
        thickBorder.backgroundColor = UIColor(white: 34/255.0, alpha: 1).CGColor
        return thickBorder
    }
    
    func render(post: Post) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)

        UIView.setAnimationsEnabled(false)
        
        self.post = post
        title.text = post.title
        
        let mini = post.description
        if mini != "" {
            minitext.text = mini
        } else {
            minitext.removeFromSuperview()
            title.snp_makeConstraints { make in
                make.bottom.equalTo(self.grayInner.snp_bottom).offset(-18)
                return
            }
        }

        layoutIfNeeded()
        
        var height = grayInner.frame.height + (post.kind == "link" ? 74 : 0)
        grayHeight = height
        
        scroll.tableHeaderView?.frame.size.height = height
        scroll.tableHeaderView = scroll.tableHeaderView

        if post.kind == "link" {
            commentsOn = false
            scrollViewDidScroll(scroll)
            
            //add button borders
            previewBorder = makeThickBorder(previewButton)
            commentBorder = makeThinBorder(commentsButton)
            previewButton.layer.addSublayer(previewBorder)
            commentsButton.layer.addSublayer(commentBorder)
            
            renderPreview()

        } else if post.kind == "text" {
            fixed.removeFromSuperview()
            scroll.tableFooterView = UIView()
            previewArea.removeFromSuperview()
            previewArea = nil
        }
        
        scroll.reloadData()

        UIView.setAnimationsEnabled(true)
    }
    
    func renderPreview() {
        previewProvider.text = post.providerDisplay.uppercaseString
        previewTitle.text = post.urlTitle
        
        if let favicon = post.favicon {
            Utils.downloadImage(NSURL(string: favicon)!, handler: { image, error in
                if error == nil {
                    self.previewFavicon.image = image
                }
            })
        } else {
            previewFavicon.snp_makeConstraints { make in
                make.left.equalTo(self.previewArea.snp_left).offset(18)
                return
            }
        }
        
        if let published = post.published {
            let date = NSDate(timeIntervalSince1970: published/1000)
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            previewDate.text = formatter.stringFromDate(date).uppercaseString
        } else {
            previewDate.removeFromSuperview()
        }
        
        let alphaPath = NSBundle.mainBundle().pathForResource("readerA", ofType: "html")!
        let alphaString = String(contentsOfFile: alphaPath, encoding: NSUTF8StringEncoding, error: nil)!
        let omegaPath = NSBundle.mainBundle().pathForResource("readerO", ofType: "html")!
        let omegaString = String(contentsOfFile: omegaPath, encoding: NSUTF8StringEncoding, error: nil)!
        
        previewWeb.loadHTMLString(alphaString + post.content + omegaString, baseURL: NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath))

        previewWeb.delegate = self
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let frame = webView.scrollView.contentSize
        previewWebHeight.constant = frame.height

        layoutIfNeeded()
    
        previewArea.frame.size.height = previewInner.frame.height
        scroll.tableFooterView = scroll.tableFooterView
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL.scheme == "preview" {
            if request.URL.resourceSpecifier!.hasPrefix("imgloaded") {
                Utils.delay(1, closure: {
                    self.webViewDidFinishLoad(webView)
                })
            }
            
            return false
        }
        
        if navigationType == UIWebViewNavigationType.LinkClicked {

        }
        
        return true
    }

    @IBAction func previewTapped(sender: AnyObject) {
        previewButton.selected = true
        previewBorder.removeFromSuperlayer()
        previewBorder = makeThickBorder(previewButton)
        previewButton.layer.addSublayer(previewBorder)
        
        commentsButton.selected = false
        commentBorder.removeFromSuperlayer()
        commentBorder = makeThinBorder(commentsButton)
        commentsButton.layer.addSublayer(commentBorder)
        
        toggleComments(false)
    }
    
    @IBAction func commentsTapped(sender: AnyObject) {
        previewButton.selected = false
        previewBorder.removeFromSuperlayer()
        previewBorder = makeThinBorder(previewButton)
        previewButton.layer.addSublayer(previewBorder)

        commentsButton.selected = true
        commentBorder.removeFromSuperlayer()
        commentBorder = makeThickBorder(commentsButton)
        commentsButton.layer.addSublayer(commentBorder)
        
        toggleComments(true)
    }
    
    func toggleComments(on: Bool) {
        commentsOn = on
        
        if commentsOn {
            scroll.tableFooterView = UIView()
        } else {
            scroll.tableFooterView = previewArea
        }
        
        scroll.reloadData()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if post != nil && post.kind == "link" {
            let y = grayHeight - scrollView.contentOffset.y - 74
            fixed.frame.origin.y = max(y, 74 - 20)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if post == nil {
            return 0
        }

        if commentsOn {
            return 1 + post.comments.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && !expandedNewComment {
            let newComment = scroll.cellForRowAtIndexPath(indexPath) as NewComment!
            expandedNewComment = true
            scroll.beginUpdates()
            scroll.endUpdates()
            
            newComment.expand()
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            if !expandedNewComment {
                return 84
            } else {
                return 204
            }
        }
        
        return 100
    }
    
    func postNewComment(string: String) {
        var info: [String:AnyObject] = ["id": post.id, "content": string]
        var comment = Comment(obj: info)

        post.comments.insert(comment, atIndex: 0)
        expandedNewComment = false
        scroll.beginUpdates()
        scroll.endUpdates()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell = scroll.dequeueReusableCellWithIdentifier("NewComment") as NewComment!
            cell.parent = self
            return cell
        } else {
            return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "A")
        }
    }
    
    func keyboardShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        scroll.snp_remakeConstraints { make in
            make.height.equalTo(Utils.screenSize.height - keyboardFrame.height)
            make.width.equalTo(Utils.screenSize.width)
            return
        }
        scrollViewDidScroll(scroll)
    }
    
    func keyboardHide(notification: NSNotification) {
        scroll.snp_remakeConstraints { make in
            make.height.equalTo(Utils.screenSize.height)
            make.width.equalTo(Utils.screenSize.width)
            return
        }
    }
}