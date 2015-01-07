//
//  FeedController.swift
//  Haggle
//
//  Created by Austin Chan on 12/30/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit

class FeedController: ItemController {
    
    lazy var _textStub: FeedTextCard = NSBundle.mainBundle().loadNibNamed("FeedTextCard", owner: self, options: nil).first as FeedTextCard!
    lazy var _linkStub: FeedLinkCard = NSBundle.mainBundle().loadNibNamed("FeedLinkCard", owner: self, options: nil).first as FeedLinkCard!
    
    override func renderEntriesTable() {
        super.renderEntriesTable()
        
        entriesTable.registerNib(UINib(nibName: "FeedTextCard", bundle: nil), forCellReuseIdentifier: "FeedTextCard")
        entriesTable.registerNib(UINib(nibName: "FeedLinkCard", bundle: nil), forCellReuseIdentifier: "FeedLinkCard")
    }
    
    override func dataSource() -> String {
        return "http://spurt.elasticbeanstalk.com/posts/public"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = entries[indexPath.row] as Post
        let kind = post.kind
        
        var cell: UITableViewCell!
        if kind == "text" {
            var textCell = entriesTable.dequeueReusableCellWithIdentifier("FeedTextCard") as FeedTextCard
            textCell.render(post)
            cell = textCell
        } else if kind == "link" {
            var linkCell = entriesTable.dequeueReusableCellWithIdentifier("FeedLinkCard") as FeedLinkCard
            linkCell.render(post)
            cell = linkCell
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = entries[indexPath.row] as Post
        
        let fullPost = NSBundle.mainBundle().loadNibNamed("FullPostView", owner: self, options: nil).first as FullPostView
        let opener = navigationController?.tabBarController?.view as UIView!
        fullPost.parent = self
        fullPost.setTranslatesAutoresizingMaskIntoConstraints(true)
        fullPost.frame = opener.bounds
        opener.addSubview(fullPost)

        fullPost.render(post)
    }
    
    override func heightForId(post: Post) -> CGFloat {
        let kind = post.kind
        
        var contentView = UIView()
        if kind == "text" {
            
            _textStub.render(post)
            contentView = _textStub.contentView
            
        } else if kind == "link" {
            _linkStub.render(post)
            contentView = _linkStub.contentView
        }

        contentView.snp_makeConstraints { make in
            make.width.equalTo(Utils.screenSize.width)
            return
        }
        contentView.setNeedsUpdateConstraints()
        contentView.setNeedsLayout()
        contentView.updateConstraintsIfNeeded()
        contentView.layoutIfNeeded()
        
        return contentView.frame.height
    }
}
