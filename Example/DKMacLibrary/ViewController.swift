//
//  ViewController.swift
//  DKMacLibrary
//
//  Created by Jirokichi on 06/16/2018.
//  Copyright (c) 2018 Jirokichi. All rights reserved.
//

import Cocoa
import DKMacLibrary

class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    ExLog.log("isTesting? => \(ExTest.isTesting())")
  }

  override var representedObject: Any? {
    didSet {
    }
  }

}
