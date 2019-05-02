//
//  TestItem.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2019/05/01.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class TestCategory{
    let name: String
    let items: [TestItem]
    
    init(name:String, items:[TestItem]) {
        self.name = name
        self.items = items
    }
}

extension TestCategory: ItemProtocol{
    func getShownName() -> String {
        return name
    }
}
