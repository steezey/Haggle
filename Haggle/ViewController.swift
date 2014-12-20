//
//  ViewController.swift
//  Haggle
//
//  Created by Austin Chan on 12/19/14.
//  Copyright (c) 2014 Caffio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        render()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    func render() {
        /* WHITE BACKGROUND */
        view.backgroundColor = UIColor.whiteColor()
        
        /* MIDDLE NAVIGATION TITLE */
        let navLabel: UILabel = UILabel(frame: CGRectZero)
        navLabel.font = UIFont.boldSystemFontOfSize(28)
        navLabel.textColor = UIColor.whiteColor()
        navLabel.text = "spark"
        navLabel.textAlignment = NSTextAlignment.Center
        navLabel.sizeToFit()
        navigationItem.titleView = navLabel
        
        println(self.view.frame.size)
    }
}

