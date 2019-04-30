//
//  ExFileSpec.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2019/04/27.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import DKMacLibrary

class ExFileSpec: QuickSpec {
    override func spec() {
        describe("ExFileSpec") {

            it("getFolderPathHavingCoreDataFile should be correct path without any error") {
                let path = ExFile.getFolderPathHavingCoreDataFile()
                ExLog.log(path)
                expect(path).to(contain("Application Support"))
            }

            it("getFileName should be correct class name without any error") {
                let fileName = ExFile.getFileName()
                ExLog.log(fileName)
                expect(fileName).to(equal("ExFileSpec"))
            }
        }
    }
}
