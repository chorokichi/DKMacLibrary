//
//  TestItem.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2019/05/01.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class TestItem {
    let name: String
    let type: ViewControllerType
    init(name:String, type: ViewControllerType) {
        self.name = name
        self.type = type
    }
}

extension TestItem: ItemProtocol{
    func getShownName() -> String {
        return name
    }
}
