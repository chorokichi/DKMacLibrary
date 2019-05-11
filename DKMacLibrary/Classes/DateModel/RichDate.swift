//
//  RichDate.swift
//  DKMacLibrary
//
//  Created by yuya on 2019/04/28.
//

import Foundation

public struct RichDate<T>: CustomStringConvertible, Equatable {
    public let year: Int
    public let month: Int
    public let day: Int
    public let weekDay: WeekDay
    public var data: T?
    public let date: Date
    
    /// 日付型を扱いやすいRichDate型に変換する
    /// - parameter from: 元の日付
    /// - returns: RichDate型。取得できなければnil。
    public init(from date: Date, data: T? = nil) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dataComps = (calendar as NSCalendar).components([.year, .month, .day, .weekday], from: date)
        
        guard let year = dataComps.year else { fatalError() }
        guard let month = dataComps.month else { fatalError() }
        guard let day = dataComps.day else { fatalError() }
        guard let wdInt = dataComps.weekday else { fatalError() }
        guard let weekDay = try? WeekDay(wdInt - 1)  else { fatalError() }
        
        self.year = year
        self.month = month
        self.day = day
        self.date = date
        self.data = data
        self.weekDay = weekDay
    }
    
    /// dateの月の初日のRichDateの取得
    /// - parameter date: 任意の日付
    /// - returns: 引数の月の初日のRichDate型。取得できなければnil。
    public func createFirstDay() -> RichDate<T> {
        // 月初日のDate作成
        let firstDateOfMonth = ExDate.createDate(year: self.year, month: self.month, day: 1)
        return RichDate(from: firstDateOfMonth, data: self.data)
    }
    
    public func createLastDay() -> RichDate<T> {
        // 今月の初日
        let firstRichDateInThisMonth = self.createFirstDay()
        
        // 来月の初日(今月の初日の１ヶ月として取得)
        let firstDateInNextMonth = ExDate.dateByAddingMonth(value: 1, date: firstRichDateInThisMonth.date)
        let firstRichDateInNextMonth = RichDate(from: firstDateInNextMonth, data: self.data)
        
        // 今月の最終日(来月の初日の前日として取得)
        return firstRichDateInNextMonth.createRichDate(added: -1)
    }
    
    /// 現在のRichDateのday日後のRichDateを取得
    public func createRichDate(added day: Int) -> RichDate<T> {
        let date = ExDate.dateByAddingDay(value: day, date: self.date)
        return RichDate(from: date, data: self.data)
    }
    
    /// 今週の初日を取得
    public func createFirstDayInThisWeek(startWeekDay: WeekDay) -> RichDate<T> {
        let diff: Int
        if startWeekDay.rawValue <= self.weekDay.rawValue {
            // Start(Sun): Sun Mon Tue Wed Thu Fri Sat
            //               0   1   2   3   4   5   6
            diff = -1 * (self.weekDay.rawValue - startWeekDay.rawValue)
        } else {
            // Start(Sat): Sat Sun Mon Tue Wed Thu Fri
            //               6   0   1   2   3   4   5
            diff = -1 * (7 + self.weekDay.rawValue - startWeekDay.rawValue)
        }
        
        if diff == 0 {
            return self
        }
        
        return self.createRichDate(added: diff)
    }
    
    public func print() {
        let msg = "\(year)/\(month)/\(day)/\(weekDay.getKey())"
        ExLog.log(msg)
    }
    
    public var description: String {
        let dataDescription: String
        if let data = data{
            dataDescription = "\(data)"
        }else{
            dataDescription = "nil"
        }
        let msg = "\(year)/\(month)/\(day)(\(weekDay.getKey()))(\(dataDescription)): \(date)"
        return msg
    }
    
    public static func == (lhs: RichDate<T>, rhs: RichDate<T>) -> Bool {
        return ( lhs.year == rhs.year ) && ( lhs.month == rhs.month ) && ( lhs.day == rhs.day ) && ( lhs.weekDay == rhs.weekDay )
    }
}
