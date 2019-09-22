//
//  ExCalendarsLogSpec.swift
//  DKMacLibrary_Tests
//
//  Created by yuya on 2019/05/06.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import DKMacLibrary

class ExCalendarsLogSpec: QuickSpec{
    override func spec() {
        describe("5 weeks related with 2019/05/05 ") {
            let date = ExDate.createDate(year: 2019, month: 5, day: 5)
            it("Show grid logs"){
                let calendar = ExCalendars<String>(markedDate: date, numOfWeeks: 5, startWeek: WeekDay.Sun)
                calendar.printCalendarAsGrid()
            }
            
            it("Show list logs for string content"){
                let calendar = ExCalendars<String>(markedDate: date, numOfWeeks: 5, startWeek: WeekDay.Sun)
                calendar.updateContent(0, new: "first")
                calendar.updateContent(5, new: "second")
                calendar.printCalendarAsList()
                
                calendar.update(ExDate.createDate(year: 2019, month: 6, day: 5))
                calendar.printCalendarAsList()
                
                calendar.getDays().forEach{expect($0.data).to(beNil())}
            }
            
            it("Show list logs for custom class content"){
                class TestA: CustomDebugStringConvertible{
                    let str:String
                    init(_ str:String) {
                        self.str = str
                    }
                    
                    var debugDescription:String{
                        return str
                    }
                }
                
                let calendar = ExCalendars<TestA>(markedDate: date, numOfWeeks: 5, startWeek: WeekDay.Sun)
                calendar.updateContent(0, new: TestA("Test1"))
                calendar.updateContent(5, new: TestA("Test2"))
                calendar.printCalendarAsList()
                
                calendar.update(ExDate.createDate(year: 2019, month: 6, day: 5))
                calendar.printCalendarAsList()
                
                calendar.getDays().forEach{expect($0.data).to(beNil())}
            }
        }
    }
}
