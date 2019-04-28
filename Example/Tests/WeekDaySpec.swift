//
//  WeekDaySpec.swift
//  DKMacLibrary_Tests
//
//  Created by yuya on 2019/04/28.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import DKMacLibrary

class WeekDaySpec: QuickSpec{
    override func spec() {
        describe("Basic") {
            it("init(Int)"){
                expect{try WeekDay(nil)}.to(throwError(WeeekDayError.NotDefinedValue))
                expect{try WeekDay(-1)}.to(throwError(WeeekDayError.NotDefinedValue))
                expect{try WeekDay(0)}.to(equal(WeekDay.Sun))
                expect{try WeekDay(1)}.to(equal(WeekDay.Mon))
                expect{try WeekDay(2)}.to(equal(WeekDay.Tue))
                expect{try WeekDay(3)}.to(equal(WeekDay.Wed))
                expect{try WeekDay(4)}.to(equal(WeekDay.Thu))
                expect{try WeekDay(5)}.to(equal(WeekDay.Fri))
                expect{try WeekDay(6)}.to(equal(WeekDay.Sat))
                expect{try WeekDay(7)}.to(throwError(WeeekDayError.NotDefinedValue))
            }
            
            it("init(key)"){
                expect{try WeekDay(key: "test")}.to(throwError(WeeekDayError.NotDefinedKey))
                expect{try WeekDay(key: "Sun")}.to(equal(WeekDay.Sun))
                expect{try WeekDay(key: "Wed")}.to(equal(WeekDay.Wed))
                expect{try WeekDay(key: "Sat")}.to(equal(WeekDay.Sat))
            }
            
            it("Increment"){
                var weekDay = WeekDay.Mon
                expect(weekDay.next()).to(equal(WeekDay.Tue))
                expect(weekDay.next()).to(equal(WeekDay.Wed))
                expect(weekDay.next()).to(equal(WeekDay.Thu))
                expect(weekDay.next()).to(equal(WeekDay.Fri))
                expect(weekDay.next()).to(equal(WeekDay.Sat))
                expect(weekDay.next()).to(equal(WeekDay.Sun))
                expect(weekDay.next()).to(equal(WeekDay.Mon))
            }
        }
    }
}
