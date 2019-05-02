//
//  ExLogViewController.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2019/05/02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa
import DKMacLibrary
class ExLogViewController: NSViewController {
    deinit {
        ExLog.method()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExLog.method()
    }
    
}
