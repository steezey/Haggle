//
//  Post.swift
//  Haggle
//
//  Created by Austin Chan on 1/4/15.
//  Copyright (c) 2015 Caffio. All rights reserved.
//

import Foundation

struct Post {
    var kind: String!
    var title: String!
    var id: Int!
    var description: String!
    var url: String!
    var urlTitle: String!
    var urlDescription: String!
    var providerDisplay: String!
    var providerName: String!
    var favicon: String?
    var published: Double?
    var comments: [Comment]
    var content: String!
    
    init(obj: [String:AnyObject]) {
        kind = obj["kind"] as String!
        
        title = obj["title"] as String!
        id = obj["id"] as Int!
        
        if kind == "link" {
            url = obj["url"] as String!
            description = obj["description"] as? String! ?? ""
            urlTitle = obj["url_title"] as? String ?? ""
            urlDescription = obj["url_description"] as? String ?? ""
            providerDisplay = obj["provider_display"] as? String ?? ""
            providerName = obj["provider_name"] as? String ?? ""
            favicon = obj["favicon_url"] as? String
            content = obj["url_content"] as? String ?? ""
            
            if let pub = obj["url_published"] as? NSString {
                published = pub.doubleValue
            }
        } else if kind == "text" {
            description = obj["content"] as String!
        }
        
        let coms = obj["comments"] as [[String:AnyObject]]

        comments = Comment.create(coms)
    }
    
    static func create(objs: [[String:AnyObject]]) -> [Post] {
        var results = [Post]()
        for obj in objs {
            results.append(Post(obj: obj))
        }
        return results
    }
}