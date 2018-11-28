//
//  ViewController.swift
//  MTChat
//
//  Created by IT A on 2018/11/26.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit

import Closures

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pushToChat(_ sender: UIButton) {
        
        let vc = MTChatController()
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

