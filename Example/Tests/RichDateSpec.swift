//
//  RichDateSpec.swift
//  DKMacLibrary_Tests
//
//  Created by yuya on 2019/04/28.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import DKMacLibrary

class RichDateSpec: QuickSpec {
    override func spec() {
        describe("2019/04/28") {

            it("init") {
                let date = ExDate.createDate(year: 2019, month: 4, day: 28)
                let rDate0 = RichDate<String>(from: date)
                let rDate1 = RichDate(from: date, data: "SampleData")
                let rDate2 = RichDate(from: date, data: 777)
                expect(rDate0).to(self.richDate(2019, 4, 28, WeekDay.Sun, data: nil))
                expect(rDate1).to(self.richDate(2019, 4, 28, WeekDay.Sun, data: "SampleData"))
                expect(rDate2).to(self.richDate(2019, 4, 28, WeekDay.Sun, data: 777))
            }
            
            it("replace") {
                let date = ExDate.createDate(year: 2019, month: 4, day: 28)
                var rDate0 = RichDate<String>(from: date)
                rDate0.data = "test"
                expect(rDate0).to(self.richDate(2019, 4, 28, WeekDay.Sun, data: "test"))
            }

            let R = RichDate<String>.self
            context("RichDate<String>") {
                it("firstDateInMonth") {
                    expect(R.init(from: ExDate.createDate(2018, 12, 29)).createFirstDay()).to(self.richDate(2018, 12, 1, WeekDay.Sat))
                    expect(R.init(from: ExDate.createDate(2019, 01, 01)).createFirstDay()).to(self.richDate(2019, 01, 1, WeekDay.Tue))
                    expect(R.init(from: ExDate.createDate(2019, 01, 31)).createFirstDay()).to(self.richDate(2019, 01, 1, WeekDay.Tue))
                    expect(R.init(from: ExDate.createDate(2019, 02, 28)).createFirstDay()).to(self.richDate(2019, 02, 1, WeekDay.Fri))

                    // Need to confirm the intended behavior
                    expect(R.init(from: ExDate.createDate(2018, -1, 29)).createFirstDay()).to(self.richDate(2017, 11, 1, WeekDay.Wed))
                    expect(R.init(from: ExDate.createDate(2018, 12, 32)).createFirstDay()).to(self.richDate(2019, 01, 1, WeekDay.Tue))
                }

                it("createLastDay") {
                    expect(R.init(from: ExDate.createDate(2018, 12, 29)).createLastDay()).to(self.richDate(2018, 12, 31, WeekDay.Mon))
                    expect(R.init(from: ExDate.createDate(2019, 01, 01)).createLastDay()).to(self.richDate(2019, 01, 31, WeekDay.Thu))
                    expect(R.init(from: ExDate.createDate(2019, 01, 31)).createLastDay()).to(self.richDate(2019, 01, 31, WeekDay.Thu))
                    expect(R.init(from: ExDate.createDate(2019, 02, 01)).createLastDay()).to(self.richDate(2019, 02, 28, WeekDay.Thu))
                    expect(R.init(from: ExDate.createDate(2018, 02, 01)).createLastDay()).to(self.richDate(2018, 02, 28, WeekDay.Wed))
                    expect(R.init(from: ExDate.createDate(2017, 02, 01)).createLastDay()).to(self.richDate(2017, 02, 28, WeekDay.Tue))
                    expect(R.init(from: ExDate.createDate(2016, 02, 01)).createLastDay()).to(self.richDate(2016, 02, 29, WeekDay.Mon))
                }

                it("createRichDate(added)") {
                    expect(R.init(from: ExDate.createDate(2018, 12, 31)).createRichDate(added: 1)).to(self.richDate(2019, 01, 01, WeekDay.Tue))
                    expect(R.init(from: ExDate.createDate(2018, 12, 31)).createRichDate(added: -1)).to(self.richDate(2018, 12, 30, WeekDay.Sun))
                    expect(R.init(from: ExDate.createDate(2019, 01, 01)).createRichDate(added: 1)).to(self.richDate(2019, 01, 02, WeekDay.Wed))
                    expect(R.init(from: ExDate.createDate(2019, 01, 01)).createRichDate(added: -1)).to(self.richDate(2018, 12, 31, WeekDay.Mon))
                }

                it("createFirstDayInThisWeek") {
                    // April, 2019
                    // Sat Sun Mon Tue Wed Thu Fri
                    //  23  24  25  26  27  28  29
                    //  30  31   1   2  ●3   4   5
                    //   6   7   8   9  10  11  12
                    //  13  14  15  16  17  18  19
                    expect(R.init(from: ExDate.createDate(2019, 04, 01)).createFirstDayInThisWeek(startWeekDay: .Sun)).to(self.richDate(2019, 03, 31, WeekDay.Sun))
                    expect(R.init(from: ExDate.createDate(2019, 04, 01)).createFirstDayInThisWeek(startWeekDay: .Mon)).to(self.richDate(2019, 04, 01, WeekDay.Mon))
                    expect(R.init(from: ExDate.createDate(2019, 04, 01)).createFirstDayInThisWeek(startWeekDay: .Tue)).to(self.richDate(2019, 03, 26, WeekDay.Tue))
                    expect(R.init(from: ExDate.createDate(2019, 04, 01)).createFirstDayInThisWeek(startWeekDay: .Sat)).to(self.richDate(2019, 03, 30, WeekDay.Sat))
                }
            }
        }
    }

    private func richDate<T: Equatable>(_ year: Int, _ month: Int, _ day: Int, _ weekDay: WeekDay, data: T? = nil,
                                        classFile: String = #file,
                                        functionName: String = #function,
                                        lineNumber: Int = #line) -> Predicate<RichDate<T>> {
        return Predicate { (actualExpression: Expression<RichDate>) throws -> PredicateResult in
            let message = ExpectationMessage.expectedTo("richDate[⚠️]")
            if let actualValue = try actualExpression.evaluate() {
                ExLog.log(actualValue, classFile: classFile, functionName: functionName, lineNumber: lineNumber)
                let message = ExpectationMessage.expectedTo("\(year)/\(month)/\(day)(\(weekDay)):\(String(describing: data)) but \(actualValue)[⚠️]")
                return PredicateResult(
                    bool: (actualValue.year == year) &&
                        (actualValue.month == month) &&
                        (actualValue.day == day) &&
                        (actualValue.weekDay == weekDay) &&
                        (actualValue.data == data),
                    message: message
                )
            } else {
                return PredicateResult(
                    status: .fail,
                    message: message
                )
            }
        }
    }
}
