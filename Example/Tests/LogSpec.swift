//
//  LogTests.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2018/06/16.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import DKMacLibrary

class LogSpec: QuickSpec {
    override func spec() {
        describe("DKLog"){
            it("Call log method and confirm there are no issues"){
                let msg = "Test"
                ExLog.log(msg)
                ExLog.log(msg, type:.Important)
                ExLog.log(msg, type:.Debug)
                ExLog.log(msg, type:.Error)
                ExLog.error(msg)
            }
            
            it("getFolderPathHavingCoreDataFile should be correct path without any error"){
                let path = ExLog.getFolderPathHavingCoreDataFile()
                ExLog.log(path)
                expect(path).to(contain("Application Support"))
            }
            
            it("getFileName should be correct class name without any error"){
                let fileName = ExLog.getFileName()
                ExLog.log(fileName)
                expect(fileName).to(equal("LogSpec"))
            }
            
            it("Check Log"){
                ExLog.log("")
                expect(ExLog.history).notTo(contain("Kida"))
                
                ExLog.log("Kida")
                expect(ExLog.history).to(contain("Kida"))
                expect(ExLog.history).notTo(equal("Kida")) // 関数名などがあるため完全に一致はしない
                
                ExLog.log("Kida", format:.Raw)
                expect(ExLog.history).to(contain("Kida"))
                expect(ExLog.history).to(equal("Kida"))
            }
            
            it("async pattern"){
                DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 10) {
                    // 0.5秒後に実行する処理
                    ExLog.log("Async Log")
                }
                expect(ExLog.history).toEventually(contain("Async"), timeout: 15)
                expect(ExLog.history).toEventually(contain("Sub "), timeout: 15)
            }
        }
    }
}
