//
//  FeedController.swift
//  Haggle
//
//  Created by Austin Chan on 12/30/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit

class FeedController: ItemController {
    override func dataSource() -> String {
        return "http://spikebackend.elasticbeanstalk.com/items/public"
    }
}
