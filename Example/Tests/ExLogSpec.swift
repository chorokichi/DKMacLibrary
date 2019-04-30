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

class ExLogSpec: QuickSpec {
    override func spec() {
        describe("Basic") {
            it("Call log method and confirm there are no issues") {
                let msg = "Test"
                ExLog.log(msg)
                expect(ExLog.getHistory()).to(contain(#function))
                ExLog.log(msg, format: .Short)
                expect(ExLog.getHistory()).notTo(contain(#function))
                ExLog.log(msg, type: .Important)
                ExLog.log(msg, type: .Debug)
                ExLog.log(msg, type: .Error)
                ExLog.error(msg)
                ExLog.emptyLine()
                ExLog.separatorLine("-", repeatNum: 7)
                ExLog.emptyLine(3)
            }

            it("Check Log") {
                ExLog.log("")
                expect(ExLog.getHistory()).notTo(contain("Kida"))

                ExLog.log("Kida")
                expect(ExLog.getHistory()).to(contain("Kida"))
                expect(ExLog.getHistory()).notTo(equal("Kida")) // 関数名などがあるため完全に一致はしない

                ExLog.log("Kida", format: .Raw)
                expect(ExLog.getHistory()).to(contain("Kida"))
                expect(ExLog.getHistory()).to(equal("Kida"))
            }

            it("async pattern") {
                DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 10) {
                    // 0.5秒後に実行する処理
                    ExLog.log("Async Log")
                }
                expect(ExLog.getHistory()).toEventually(contain("Async"), timeout: 15)
                expect(ExLog.getHistory()).toEventually(contain("Sub "), timeout: 15)
            }
        }
    }
}
