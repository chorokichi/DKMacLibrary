//
//  DialogViewController.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2020/05/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Cocoa
import DKMacLibrary
class DialogViewController: NSViewController {
    deinit {
        ExLog.method()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExLog.method()
    }
    
    @IBAction func onOpenDialog(_ sender: Any) {
        ExLog.method()
        DKDialogUtil.alertDialog("alertDialog", firstButton: "Custom") {
            ExLog.log("Done")
        }
    }
    
}
