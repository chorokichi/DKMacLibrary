//
//  ExCalendarsSpec.swift
//  DKMacLibrary_Tests
//
//  Created by yuya on 2019/04/28.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import DKMacLibrary

class ExCalendarsSpec: QuickSpec {

    private func assert(calendar: ExCalendars<String>?,
                        expectedFirst first: (Int, Int, Int, WeekDay),
                        expectedLast last: (Int, Int, Int, WeekDay),
                        classFile: String = #file,
                        functionName: String = #function,
                        lineNumber: UInt = #line) {
        guard let calendar = calendar else {
            fail("calendar should not be nil!")
            return
        }
        it("First Day in this calendar") {
            calendar.printCalendarAsGrid()
            expect(calendar.getFirstDay(), file: classFile, line: lineNumber).to(self.richDate(first.0, first.1, first.2, first.3))
        }

        it("Last Day in this calendar") {
            calendar.printCalendarAsGrid()
            expect(calendar.getLastDay(), file: classFile, line: lineNumber).to(self.richDate(last.0, last.1, last.2, last.3))
        }
    }

    override func spec() {
        describe("2019.04.03") {
            let date = ExDate.createDate(year: 2019, month: 4, day: 3)

            context("Start Week Is Sunday & size 7") {
                let calendar = try? ExCalendars<String>(markedDate: date, numOfWeeks: 1, startWeek: WeekDay.Sun)
                // April, 2019
                // Sun Mon Tue Wed Thu Fri Sat
                //  31   1   2  ●3   4   5   6
                self.assert(calendar: calendar,
                            expectedFirst: (2019, 3, 31, WeekDay.Sun),
                            expectedLast: (2019, 4, 6, WeekDay.Sat))
            }

            context("Start Week Is Sunday & size 14") {
                let calendar = try? ExCalendars<String>(markedDate: date, numOfWeeks: 2, startWeek: WeekDay.Sun)
                // April, 2019
                // Sun Mon Tue Wed Thu Fri Sat
                //  31   1   2  ●3   4   5   6
                //   7   8   9  10  11  12  13
                self.assert(calendar: calendar,
                            expectedFirst: (2019, 3, 31, WeekDay.Sun),
                            expectedLast: (2019, 4, 13, WeekDay.Sat))

            }
        }

        describe("2019.04.03") {
            let date = ExDate.createDate(year: 2019, month: 4, day: 3)

            context("Start Week Is Saturday & size 7") {
                let calendar = try? ExCalendars<String>(markedDate: date, numOfWeeks: 3, startWeek: WeekDay.Sat)
                // April, 2019
                // Sat Sun Mon Tue Wed Thu Fri
                //  30  31   1   2  ●3   4   5
                //   6   7   8   9  10  11  12
                //  13  14  15  16  17  18  19
                self.assert(calendar: calendar,
                            expectedFirst: (2019, 3, 30, WeekDay.Sat),
                            expectedLast: (2019, 4, 19, WeekDay.Fri))
            }
        }

        describe("2019.04.17") {
            let date = ExDate.createDate(year: 2019, month: 4, day: 17)

            context("Start Week Is Sunday & size 7") {
                let calendar = try? ExCalendars<String>(markedDate: date, numOfWeeks: 1, startWeek: WeekDay.Sun)
                // April, 2019
                // Sun Mon Tue Wed Thu Fru Sat
                //  31   1   2   3   4   5   6
                //   7   8   9  10  11  12  13
                // ●14  15  16  17  18  19  20
                self.assert(calendar: calendar,
                            expectedFirst: (2019, 4, 14, WeekDay.Sun),
                            expectedLast: (2019, 4, 20, WeekDay.Sat))
            }

            context("Start Week Is Sunday & size 14") {
                let calendar = try? ExCalendars<String>(markedDate: date, numOfWeeks: 2, startWeek: WeekDay.Sun)
                // April, 2019
                // Sun Mon Tue Wed Thu Fru Sat
                //   7   8   9  10  11  12  13
                // ●14  15  16  17  18  19  20
                self.assert(calendar: calendar,
                            expectedFirst: (2019, 4, 07, WeekDay.Sun),
                            expectedLast: (2019, 4, 20, WeekDay.Sat))
            }

            context("Start Week Is Sunday & size 21") {
                let calendar = try? ExCalendars<String>(markedDate: date, numOfWeeks: 3, startWeek: WeekDay.Sun)
                // April, 2019
                // Sun Mon Tue Wed Thu Fru Sat
                //  31   1   2   3   4   5   6
                //   7   8   9  10  11  12  13
                // ●14  15  16  17  18  19  20
                self.assert(calendar: calendar,
                            expectedFirst: (2019, 3, 31, WeekDay.Sun),
                            expectedLast: (2019, 4, 20, WeekDay.Sat))
            }

            context("Start Week Is Sunday & size 28") {
                let calendar = try? ExCalendars<String>(markedDate: date, numOfWeeks: 4, startWeek: WeekDay.Sun)
                // April, 2019
                // Sun Mon Tue Wed Thu Fru Sat
                //  31   1   2   3   4   5   6
                //   7   8   9  10  11  12  13
                // ●14  15  16  17  18  19  20
                //  21  22  23  24  25  26  27
                self.assert(calendar: calendar,
                            expectedFirst: (2019, 3, 31, WeekDay.Sun),
                            expectedLast: (2019, 4, 27, WeekDay.Sat))
            }
        }

        describe("2019.01.01") {
            let date = ExDate.createDate(year: 2019, month: 1, day: 1)

            context("Start Week Is Saturday & size 7") {
                let calendar = try? ExCalendars<String>(markedDate: date, numOfWeeks: 3, startWeek: WeekDay.Sat)
                // January, 2019
                // Sat Sun Mon Tue Wed Thu Fri
                //  29  30  31  ●1   2   3   4
                //   5   6   7   8   9  10  11
                //  12  13  14  15  16  17  18
                self.assert(calendar: calendar,
                            expectedFirst: (2018, 12, 29, WeekDay.Sat),
                            expectedLast: (2019, 01, 18, WeekDay.Fri))
            }
        }
    }

    private func richDate<T>(_ year: Int, _ month: Int, _ day: Int, _ weekDay: WeekDay,
                             classFile: String = #file,
                             functionName: String = #function,
                             lineNumber: Int = #line) -> Predicate<RichDate<T>> {
        return Predicate { (actualExpression: Expression<RichDate>) throws -> PredicateResult in
            let message = ExpectationMessage.expectedTo("richDate[⚠️]")
            if let actualValue = try actualExpression.evaluate() {
                ExLog.log(actualValue, classFile: classFile, functionName: functionName, lineNumber: lineNumber)
                let message = ExpectationMessage.expectedTo("\(year)/\(month)/\(day)(\(weekDay)) but \(actualValue)[⚠️]")
                return PredicateResult(
                    bool: (actualValue.year == year) &&
                        (actualValue.month == month) &&
                        (actualValue.day == day) &&
                        (actualValue.weekDay == weekDay),
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
