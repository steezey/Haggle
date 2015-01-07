//
//  Comment.swift
//  Haggle
//
//  Created by Austin Chan on 1/6/15.
//  Copyright (c) 2015 Caffio. All rights reserved.
//

import Foundation

struct Comment {
    var id: Int!
    var content: String
    
    init(obj: [String:AnyObject]) {
        id = obj["id"] as Int!
        content = obj["content"] as String!
    }
    
    static func create(objs: [[String:AnyObject]]) -> [Comment] {
        var results = [Comment]()
        for obj in objs {
            results.append(Comment(obj: obj))
        }
        return results
    }
}