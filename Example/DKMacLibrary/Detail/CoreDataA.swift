//
//  CoreData.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2019/05/02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import DKMacLibrary

class CoreDataA: DKCoreData{
    override var data: DKCoreData.RequiredData {
        let data = DKCoreData.RequiredData(
            "Model",
            "jp.ky.mac.library",
            "DKMacLibrary")
        return data
    }
}
