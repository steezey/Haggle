//
//  Item.swift
//  Haggle
//
//  Created by Austin Chan on 12/20/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import Foundation

struct Item {
    let id: Int
    let title: String
    let content: String
    let provider_display: String

    init(data: [String:String]) {
        id = data["id"]!.toInt()!
        title = data["title"]!
        content = data["content"]!
        provider_display = data["provider_display"]!
    }
}