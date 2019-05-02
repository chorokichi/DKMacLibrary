//
//  ExQuickConfiguration.swift
//  DKMacLibrary_Tests
//
//  Created by yuya on 2019/05/01.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import DKMacLibrary

class ExQuickConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        configuration.beforeEach { metaData in
            let index = String(format: "%03d", metaData.exampleIndex)
            ExLog.separatorLine("-", repeatNum: 30)
            ExLog.log("⭐️\(index). Start: \"\(metaData.example.name)\"", format: .Raw)
            ExLog.separatorLine("-", repeatNum: 30)
        }
        
        configuration.afterEach {metaData in
            ExLog.log("- End(\(metaData.example.name)) -", format: .Raw)
            ExLog.separatorLine("-", repeatNum: 30)
        }
    }
}
