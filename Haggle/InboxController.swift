//
//  InboxController.swift
//  Haggle
//
//  Created by Austin Chan on 12/30/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit
import Dollar

class InboxController: ItemController {
    override func dataSource() -> String {
        return "http://spurt.elasticbeanstalk.com/posts/inbox?uuid=" + Utils.uuid
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = entries[indexPath.row] as Post
        
        let newPost = NSBundle.mainBundle().loadNibNamed("NewPost", owner: self, options: nil).first as NewPostView
        
        let opener = navigationController?.tabBarController?.view as UIView!
        newPost.frame = opener.bounds
        opener.addSubview(newPost)
        
        newPost.renderLinkPost(post, parent: self)
    }
    
    override func receivePostedId(number: NSNumber, type: String) {
        super.receivePostedId(number, type: type)
        
        var index = $.findIndex(entries, iterator: {
            $0.id as NSNumber == number
        })
        
        if index != nil {
            Utils.delay(0.5, {
                self.entries.removeAtIndex(index!)
                self.entriesTable.deleteRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
            })
        }
    }
    
    override func renderEntriesTable() {
        super.renderEntriesTable()
        entriesTable.registerClass(EntryCell.self, forCellReuseIdentifier: "EntryCell")
    }
}
