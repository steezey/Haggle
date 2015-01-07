//
//  ViewController.swift
//  Haggle
//
//  Created by Austin Chan on 12/19/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit
import Alamofire
import Dollar

class ItemController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var entries = [Post]()
    var entriesTable = UITableView(frame: CGRectZero, style: .Plain)
    var refreshControl = UIRefreshControl()
    var entryCache = [Int:CGFloat]()
    var addPostButton: UIButton!
    
    var dropDown: PostDropDown!
    
    /*
    |--------------------------------------------------------------------------
    | SUBCLASS
    |--------------------------------------------------------------------------
    */
    func dataSource() -> String {
        return ""
    }
    
    /*
    |--------------------------------------------------------------------------
    | INITIALIZATION
    |--------------------------------------------------------------------------
    */

    override func viewDidLoad() {
        super.viewDidLoad()

        render()
        loadData(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewDidLayoutSubviews() {
        refreshControl.superview?.sendSubviewToBack(refreshControl)
    }

    /*
    |--------------------------------------------------------------------------
    | RENDERING
    |--------------------------------------------------------------------------
    */

    func render() {
        /* VIEW GREY BACKGROUND */
        view.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1)
        
        /* MIDDLE NAVIGATION TITLE */
        let navLabel: UILabel = UILabel(frame: CGRectZero)
        navLabel.font = UIFont.boldSystemFontOfSize(28)
        navLabel.backgroundColor = UIColor.clearColor()
        navLabel.textColor = UIColor.whiteColor()
        navLabel.text = "spark"
        navLabel.textAlignment = NSTextAlignment.Center
        navLabel.sizeToFit()
        navigationItem.titleView = navLabel
        
        /* NEW POST BUTTON */
        let add = UIButton.buttonWithType(UIButtonType.System) as UIButton
        add.frame = CGRectMake(Utils.screenSize.width - 44, 0, 44, 44)
        add.titleLabel?.font = UIFont(name: "icomoon", size: 30)
        add.setTitle("\u{e606}", forState: UIControlState.Normal)
        add.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        add.transform = CGAffineTransformConcat(
            CGAffineTransformMakeRotation(CGFloat(M_PI_4)),
            CGAffineTransformMakeScale(0.82, 0.82)
        )
        add.tag = 110
        add.addTarget(self, action: "add", forControlEvents: UIControlEvents.TouchUpInside)
        addPostButton = add
        self.navigationController!.navigationBar.addSubview(add)
        
        /* ITEMS TABLE */
        renderEntriesTable()
        renderEntriesTableRefreshControl()
        
        /* RENDER DROPDOWN */
        dropDown = NSBundle.mainBundle().loadNibNamed("PostDropDown", owner: self, options: nil).first as PostDropDown!
        dropDown.parent = self
        dropDown.frame = CGRectMake(0, 0, Utils.screenSize.width, 64)
        view.addSubview(dropDown)
    }
    
    func add() {
        triggerNewTextPost()
//        if addPostButton.tag == 110 {
//            openDropDown()
//        } else {
//            closeDropDown(true)
//        }
    }
    
    func openDropDown() {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.53, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.allZeros, animations: {
            self.addPostButton.transform = CGAffineTransformIdentity
            return
        }, completion: nil)

        UIView.animateWithDuration(0.29, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 7.0, options: UIViewAnimationOptions.allZeros, animations: {
            self.dropDown.frame.size.height = 64 + 50
        }, completion: nil)
        
        killEntriesScroll()
        addPostButton.tag = 111
    }
    
    func closeDropDown(animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.29, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 7.0, options: UIViewAnimationOptions.allZeros, animations: {
                self.dropDown.frame.size.height = 64
            }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.53, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.allZeros, animations: {
                self.addPostButton.transform = CGAffineTransformConcat(
                    CGAffineTransformMakeRotation(CGFloat(M_PI_4)),
                    CGAffineTransformMakeScale(0.82, 0.82)
                )
                return
            }, completion: nil)
        } else {
            self.dropDown.frame.size.height = 64
            self.addPostButton.transform = CGAffineTransformConcat(
                CGAffineTransformMakeRotation(CGFloat(M_PI_4)),
                CGAffineTransformMakeScale(0.82, 0.82)
            )
        }
        
        addPostButton.tag = 110
    }
    
    override func viewDidDisappear(animated: Bool) {
        if addPostButton.tag == 111 {
            closeDropDown(false)
        }
    }
    
    func renderEntriesTable() {
        entriesTable.frame = view.bounds
        entriesTable.backgroundColor = UIColor.clearColor()
        entriesTable.separatorStyle = UITableViewCellSeparatorStyle.None
        entriesTable.delegate = self
        entriesTable.dataSource = self
        entriesTable.estimatedRowHeight = 68
        entriesTable.rowHeight = UITableViewAutomaticDimension
        
        entriesTable.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        view.addSubview(entriesTable)
    }
    
    func renderEntriesTableRefreshControl() {
        let controllerFix = UITableViewController()
        controllerFix.tableView = entriesTable
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        controllerFix.refreshControl = self.refreshControl;

        entriesTable.addSubview(refreshControl)
    }
    
    func refresh(sender: UIRefreshControl) {
        loadData(false)
        sender.endRefreshing()
    }
    
    /*
    |--------------------------------------------------------------------------
    | TABLE VIEW FUNCTIONS
    |--------------------------------------------------------------------------
    */

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = entriesTable.dequeueReusableCellWithIdentifier("EntryCell") as EntryCell
        let post = entries[indexPath.row] as Post
        
        cell.render(post.title, providerDisplay: post.providerDisplay, providerName: post.providerName, favicon: post.favicon)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return getHeightCache(indexPath)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == entriesTable && addPostButton.tag == 111 {
            closeDropDown(true)
        }
    }
    
    func triggerNewTextPost() {
        Utils.delay(0.8, closure: {
            self.closeDropDown(false)
        })

        let newPost = NSBundle.mainBundle().loadNibNamed("NewPost", owner: self, options: nil).first as NewPostView
        
        let opener = navigationController?.tabBarController?.view as UIView!
        newPost.setTranslatesAutoresizingMaskIntoConstraints(true)
        newPost.frame = opener.bounds
        opener.addSubview(newPost)
        newPost.layoutIfNeeded()
        
        newPost.renderTextPost(self)
    }
    
    func killEntriesScroll() {
        entriesTable.setContentOffset(entriesTable.contentOffset, animated: false)
    }
    
    func getHeightCache(indexPath: NSIndexPath) -> CGFloat {
        let post = entries[indexPath.row] as Post
        let postId = post.id
        
        if let cache = entryCache[postId] {
            return cache
        }
        
        let height = heightForId(post)
        entryCache[postId] = height
        return height
    }
    
    func heightForId(post: Post) -> CGFloat {
        return 100
    }
    
    func closeWebModal() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    |--------------------------------------------------------------------------
    | DATA LOADING FUNCTIONS
    |--------------------------------------------------------------------------
    */
    
    var loadingController = UIAlertController(title: "Loading Data...", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    func showLoading() {
        self.navigationController?.presentViewController(loadingController, animated: true, completion: nil)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func hideLoading() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func loadData(synchronously: Bool) {
        if synchronously {
            showLoading()
        }
        Alamofire.request(.GET, dataSource())
            .responseJSON { (_, _, JSON, error) in
                if error == nil {
                    let data = JSON as [[String:AnyObject]]
                    self.entries = Post.create(data)
                    if self.entries.count > 0 {
                        
                    } else {
                        
                    }
                    self.entriesTable.reloadData()
                    if synchronously {
                        self.hideLoading()
                    }
                }
        }
    }
    
    func receivePostedId(number: NSNumber, type: String) {  }
}

