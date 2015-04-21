//
//  ViewController.swift
//  DDSliderSample
//
//  Created by 端 闻 on 19/4/15.
//  Copyright (c) 2015年 monk-studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 1, green: 0.4, blue: 0, alpha: 1)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didChangeValue(sender: DDSlider) {
        println("current progress is \(sender.progress)")
    }

}

