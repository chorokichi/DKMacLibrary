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
    func getDay(_ year: Int, _ month: Int, _ day: Int) -> RichDate<T>?
    
    func update(_ newDate: Date)
    func updateContent(_ index: Int, new: T)
    func updateAllContents(by newList: [T])
    func initAllContents(by new: T)
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
    
    public init(markedDate: Date = Date(), numOfWeeks: Int, startWeek: WeekDay = .Sun) {
        let date: RichDate<T> = RichDate(from: markedDate)
        self.markedDate = date
        self.numOfWeeks = numOfWeeks
        guard numOfWeeks > 0 else {fatalError("週数は必ず0以上")}
        self.startWeek = startWeek
        self.construct()
    }
    
    public func printCalendarAsGrid() {
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
    
    /// 日付をリストでコンソールに出力するメソッド。RichDateの中身(data)のdebugDescriptionを出力する。
    /// そのため、内容を自分でカスタマイズしたい場合はTクラスにCustomDebugStringConvertibleを継承させて、
    /// debugDescriptionを自分で定義すること
    public func printCalendarAsList() {
        ExLog.log("################################", format: .NoPostFix)
        days.forEach { (richDate: RichDate<T>) in
            let header = String(format: "%04d/%02d/%02d(%@): ", richDate.year, richDate.month, richDate.day, richDate.weekDay.getKey())
            let content = richDate.data.debugDescription 
            ExLog.log("\(header)\(content)", format: .NoPostFix)
        }
        ExLog.log("################################", format: .NoPostFix)
    }
    
    private func construct() {
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
    
    public func getDay(_ year: Int, _ month: Int, _ day: Int) -> RichDate<T>? {
        let filteredDays = days.filter {($0.year == year && $0.month == month && $0.day == day)}
        guard filteredDays.count < 2 else {
            ExLog.fatalError("A date should be only one. \(filteredDays)")
            return nil
        }
        
        if filteredDays.count == 0 {
            return nil
        } else {
            return filteredDays[0]
        }
    }
    
    public func update(_ newDate: Date) {
        let date: RichDate<T> = RichDate(from: newDate)
        self.markedDate = date
        self.construct()
    }
    
    public func updateContent(_ index: Int, new: T) {
        self.days[index].data = new
    }
    
    public func updateAllContents(by newList: [T]) {
        assert(self.days.count == newList.count)
        for index in 0 ..< self.days.count {
            self.days[index].data = newList[index]
        }
    }
    
    public func initAllContents(by new: T) {
        for index in 0 ..< self.days.count {
            self.days[index].data = new
        }
    }
}
