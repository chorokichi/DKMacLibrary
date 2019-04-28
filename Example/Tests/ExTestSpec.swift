//
//  ExTestSpec.swift
//  DKMacLibrary_Tests
//
//  Created by yuya on 2019/04/28.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import DKMacLibrary

class ExTestSpec : QuickSpec{
    override func spec(){
        describe("ExTestSpec") {
            it("isTest?"){
                let isTest = ExTest.isTesting()
                expect(isTest).to(equal(true))
            }
        }
    }
    
}
