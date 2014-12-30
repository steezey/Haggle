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

    var entries = [[String:String]]()
    var entriesTable = UITableView(frame: CGRectZero, style: .Plain)
    var refreshControl = UIRefreshControl()
    var entryCellHeights = [Int:CGFloat]()
    
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
        title = "View"

        loadData(true)
        render()
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
        navLabel.textColor = UIColor.whiteColor()
        navLabel.text = "spark"
        navLabel.textAlignment = NSTextAlignment.Center
        navLabel.sizeToFit()
        navigationItem.titleView = navLabel
        
        /* ITEMS TABLE */
        renderEntriesTable()
        renderEntriesTableRefreshControl()
    }
    
    func renderEntriesTable() {
        entriesTable.frame = view.bounds
        entriesTable.backgroundColor = UIColor.clearColor()
        entriesTable.separatorStyle = UITableViewCellSeparatorStyle.None
        entriesTable.delegate = self
        entriesTable.dataSource = self
        entriesTable.registerClass(EntryCell.self, forCellReuseIdentifier: "EntryCell")
        entriesTable.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
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
        let item = entries[indexPath.row] as [String:AnyObject]
        
        cell.render(item["title"] as String!, providerDisplay: item["provider_display"] as String!, providerName: item["provider_name"] as String!, favicon: item["favicon_url"] as String!)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = entries[indexPath.row] as [String:AnyObject]
        let itemId = item["id"] as Int!
        
        var height: CGFloat
        if let savedHeight = entryCellHeights[itemId] {
            height = savedHeight
        } else {
            height = EntryCell.calculateHeight(item, width: Utils.screenSize.width)
            entryCellHeights[itemId] = height
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = entries[indexPath.row] as [String:AnyObject]
        let url = item["url"] as String!

        var vc = UIViewController()
        vc.view.backgroundColor = UIColor.whiteColor()
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, view.frame.width, 44 + 20))
        toolbar.setItems([UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "closeWebModal")], animated: false)
        vc.view.addSubview(toolbar)
        
        var webview = UIWebView(frame: CGRectMake(0, 44 + 20, view.frame.width, view.frame.height - 44 - 20))
        webview.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        vc.view.addSubview(webview)
        presentViewController(vc, animated: true, completion: nil)
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
            .responseJSON { (_, _, JSON, _) in
                let data = JSON as [[String:String]]
                self.entries = data
                self.entriesTable.reloadData()
                if synchronously {
                    self.hideLoading()
                }
        }
    }
}
