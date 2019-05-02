//
//  PTCalendars.swift
//  PeopleTable
//
//  Created by yuya on 2017/06/01.
//  Copyright © 2017年 yuya. All rights reserved.
//

import Foundation

public protocol ExCalendarsProtocol {
    associatedtype T
    func getMarkedDay() -> RichDate<T>
    func getFirstDay() -> RichDate<T>
    func getLastDay() -> RichDate<T>
    func getDays() -> [RichDate<T>]
    
    func update(_ newDate: Date)
}
/// 月カレンダー
/// 使い方
/// 1. 初期化でDateとカレンダーサイズ、週初めの曜日を指定。ここで設定したDateの日が強調されて、その月のカレンダーが表示される
/// 2. updateで日付を更新すると月も変わる
public class ExCalendars<T> {
    private let numOfWeeks: Int
    public let startWeek: WeekDay
    
    // 注目している日付
    private var markedDate: RichDate<T>
    private var days: [RichDate<T>] = []
    
    public init(markedDate: Date = Date(), numOfWeeks: Int, startWeek: WeekDay = .Sun) throws {
        let date: RichDate<T> = RichDate(from: markedDate)
        self.markedDate = date
        self.numOfWeeks = numOfWeeks
        guard numOfWeeks > 0 else {fatalError("週数は必ず0以上")}
        self.startWeek = startWeek
        try self.construct()
    }
    
    public func printCalendar() {
        ExLog.log("################################", format: .NoPostFix)
        var weekEnd = startWeek
        var log = ""
        
        // 曜日表示
        (0...5).forEach { (_) in
            log = "\(log)\(weekEnd.getKey()) "
            weekEnd.next()
        }
        log = "\(log)\(weekEnd.getKey()) "
        ExLog.log(log, format: .NoPostFix)
        log.removeAll()
        
        // 日付表示
        var months: [String] = []
        days.forEach { (richDate: RichDate<T>) in
            let yearAndMonth = "\(richDate.year)/\(richDate.month)"
            if !months.contains(yearAndMonth) {
                months.append(yearAndMonth)
            }
            
            let dayStr = "\(richDate.day)"
            let prefix: String
            let remark = ((richDate == self.markedDate) ? "*" : " ")
            if dayStr.count == 1 {
                prefix = " \(remark)"
            } else {
                prefix = "\(remark)"
            }
            log = "\(log)\(prefix)\(dayStr) "
            if richDate.weekDay == weekEnd {
                months.forEach { (subInfo) in
                    log = "\(log)\(subInfo) "
                }
                ExLog.log(log, format: .NoPostFix)
                log.removeAll()
                months.removeAll()
            }
        }
        
        ExLog.log("################################", format: .NoPostFix)
    }
    
    private func construct() throws {
        // カレンダーの最初の日付
        // April, 2019
        // Sun Mon Tue Wed Thu Fru Sat
        //  31   1   2   3   4   5   6
        //   7   8   9  10  11  12  13
        //  14  15  16  17  18  19  20
        let firstDayInWeek = self.markedDate.createFirstDayInThisWeek(startWeekDay: self.startWeek)
        let firstDayOnCalendar = self.getFirstDayOnCalendar(firstDayInWeek: firstDayInWeek)
        
        self.days = []
        
        for i in 0 ..< numOfWeeks*7 {
            let date = ExDate.dateByAddingDay(value: i, date: firstDayOnCalendar.date)
            let lDate: RichDate<T> = RichDate(from: date)
            self.days.append(lDate)
        }
    }
    
    private func getFirstDayOnCalendar(firstDayInWeek: RichDate<T>) -> RichDate<T> { 
        var firstDayOnCalendar = firstDayInWeek
        var i = numOfWeeks
        while firstDayOnCalendar.month == self.markedDate.month && i > 1 {
            i = i - 1
            firstDayOnCalendar = firstDayOnCalendar.createRichDate(added: -7)
        }
        
        return firstDayOnCalendar
    }
}

extension ExCalendars: ExCalendarsProtocol {
    public func getMarkedDay() -> RichDate<T> {
        return self.markedDate
    }
    
    public func getFirstDay() -> RichDate<T> {
        return days.first!
    }
    
    public func getLastDay() -> RichDate<T> {
        return days.last!
    }
    
    public func getDays() -> [RichDate<T>] {
        return days
    }
    
    public func update(_ newDate: Date) {
        let date: RichDate<T> = RichDate(from: newDate)
        self.markedDate = date
        try? self.construct()
    }
}
