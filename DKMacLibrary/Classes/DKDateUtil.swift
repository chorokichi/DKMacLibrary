//
//  DKDateUtil.swift
//  DKLibrary
//
//  Created by yuya on 2017/03/13.
//  Copyright © 2017年 yuya. All rights reserved.
//

//
//  DateUtil.swift
//  PeopleTable
//
//  Created by yuya on 2016/03/23.
//  Copyright © 2016年 yuya. All rights reserved.
//

import Foundation

enum WeeekDayError : Error
{
    case NotDefinedKey
    case NotDefinedValue
}

public enum DKWeekDay:Int{
    case Sun = 0
    case Mon = 1
    case Tue = 2
    case Wed = 3
    case Thu = 4
    case Fri = 5
    case Sat = 6
    
    
    private enum Key:String{
        case Sun = "Sun"
        case Mon = "Mon"
        case Tue = "Tue"
        case Wed = "Wed"
        case Thu = "Thu"
        case Fri = "Fri"
        case Sat = "Sat"
    }
    
    public init(_ int:Int?) throws
    {
        guard  let int = int else
        {
            throw WeeekDayError.NotDefinedValue
        }
        
        if let tmp = DKWeekDay(rawValue: int)
        {
            self = tmp
            return
        }
        throw WeeekDayError.NotDefinedValue
    }
    
    public init(key:String) throws
    {
        guard let keyType:Key = Key(rawValue: key) else
        {
            throw WeeekDayError.NotDefinedKey
        }
        
        switch keyType
        {
        case .Sun:
            self = .Sun
        case .Mon:
            self = .Mon
        case .Tue:
            self = .Tue
        case .Wed:
            self = .Wed
        case .Thu:
            self = .Thu
        case .Fri:
            self = .Fri
        case .Sat:
            self = .Sat
        }
    }
    
    public func getDisplayedValue() -> String{
        switch self{
        case .Sun:
            return "日"
        case .Mon:
            return "月"
        case .Tue:
            return "火"
        case .Wed:
            return "水"
        case .Thu:
            return "木"
        case .Fri:
            return "金"
        case .Sat:
            return "土"
        }
    }
    
    public func getKey() -> String
    {
        let key:Key = self.getKey()
        return key.rawValue
    }
    
    private func getKey() -> Key
    {
        switch self{
        case .Sun:
            return Key.Sun
        case .Mon:
            return Key.Mon
        case .Tue:
            return Key.Tue
        case .Wed:
            return Key.Wed
        case .Thu:
            return Key.Thu
        case .Fri:
            return Key.Fri
        case .Sat:
            return Key.Sat
        }
    }
}

public class DKDateUtil{
    
    static let DefaultLocale = "en_US"
    static let DefaultDateFormat = "yyyy/MM/dd HH:mm:ss"
    
    public enum Format
    {
        case defined(DefaultFormat)
        case custom(String)
    }
    
    public enum DefaultFormat : String
    {
        case full = "yyyy/MM/dd HH:mm:ss"
        case short = "yyyy/MM/dd"
    }
    
    public struct SDate<T>
    {
        public let year:Int
        public let month:Int
        public let day:Int
        public let weekDay:DKWeekDay
        public var data:T?
        public let date:Date
        
        public func print()
        {
            let msg = "\(year)/\(month)/\(day)/\(weekDay.getDisplayedValue())"
            ExLog.log(msg)
        }
    }
    
    /// 年月日から日付型作成
    /// - parameter year: 年
    /// - parameter month: 月
    /// - parameter day: 日
    /// - returns: 日付
    public static func createDate(year y:Int, month m:Int, day d:Int) -> Date?
    {
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: DateComponents(year: y, month: m, day: d))
        return date
    }
    
    /// 日付型から指定したフォーマットで文字列作成
    /// - parameter date: 日付
    /// - parameter format: フォーマット
    /// - returns: 日付の文字列
    public static func display(_ date:Date, format:Format) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: DefaultLocale) // ロケールの設定
        switch format
        {
        case let .defined(defaultFormat):
            dateFormatter.dateFormat = defaultFormat.rawValue
        case let .custom(format):
            dateFormatter.dateFormat = format
        }
        return dateFormatter.string(from: date)
    }
    
    /// 日付型を扱いやすいSDate型に変換する
    /// - parameter from: 元の日付
    /// - returns: SDate型。取得できなければnil。
    public static func getSimpleDate<T>(from date:Date?, data:T? = nil) -> SDate<T>?
    {
        guard let date = date else
        {
            ExLog.error()
            return nil
        }
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dataComps = (calendar as NSCalendar).components([.year, .month, .day, .weekday], from: date)
        
        guard let y = dataComps.year else
        {
            ExLog.error()
            return nil
        }
        
        guard let m = dataComps.month else
        {
            ExLog.error()
            return nil
        }
        
        guard let d = dataComps.day else
        {
            ExLog.error()
            return nil
        }
        
        guard let wdInt = dataComps.weekday else
        {
            ExLog.error()
            return nil
        }
        
        guard let wd = try? DKWeekDay(wdInt - 1) else
        {
            ExLog.error()
            return nil
        }
        
        return SDate(year: y, month: m, day: d, weekDay:wd, data:data, date:date)
    }
    
    /// dateの月の初日のNSDateComponent(Year, Month, Day, Weekday)の取得
    /// - parameter date: 任意の日付
    /// - returns: 引数の月の初日のSDate型。取得できなければnil。
    public static func getFirstDay<T>(_ date:Date?, value:T? = nil) -> SDate<T>?
    {
        guard let firstDate = DKDateUtil.getFirstDay(date) else
        {
            return nil
        }
        return DKDateUtil.getSimpleDate(from:firstDate, data:value)
    }
    
    private static func getFirstDay(_ date:Date?) -> Date?
    {
        guard let sDate:SDate<String> = DKDateUtil.getSimpleDate(from: date) else
        {
            return nil
        }
        return DKDateUtil.createDate(year: sDate.year, month: sDate.month, day: 1)
    }
    
    public static func dateByAddingDay(value:Int, date:Date) -> Date?
    {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return calendar.date(byAdding: .day, value: value, to: date)
    }
    
    public static func dateByAddingMonth(value:Int, date:Date?) -> Date?
    {
        guard let date = date else
        {
            ExLog.error()
            return nil
        }
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return calendar.date(byAdding: .month, value: value, to: date)
    }
    
    
    public static func getLastDay<T>(_ date:Date?, data:T? = nil) -> SDate<T>?
    {
        let lastDate = DKDateUtil.getLastDay(date)
        return DKDateUtil.getSimpleDate(from: lastDate, data:data)
    }
    
    private static func getLastDay(_ date:Date?) -> Date?
    {
        
        guard let nextMonthDate = DKDateUtil.dateByAddingMonth(value: 1, date: date) else
        {
            ExLog.error()
            return nil
        }
        
        guard let nextMonthFirstDate = DKDateUtil.getFirstDay(nextMonthDate) else
        {
            ExLog.error()
            return nil
        }
        
        return DKDateUtil.dateByAddingDay(value: -1, date: nextMonthFirstDate)
    }
    
    /// dateの月の最終日のNSDateComponent(Year, Month, Day, Weekday)の取得
    public static func getLastDay(_ date:Date) -> DateComponents{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: DefaultLocale) // ロケールの設定
        dateFormatter.dateFormat = DefaultDateFormat
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dataComps = (calendar as NSCalendar).components([.year, .month, .day], from: date)
        
        var nextMonth = (dataComps.month ?? 0)+1
        if nextMonth > 12{
            nextMonth = 1
        }
        
        let nextMonthFirstDay = (dateFormatter.date(from: "\(dataComps.year!)/\((nextMonth))/01 09:00:00"))!
        let finalDayInThisMonth = Date(timeInterval: -1*24*60*60, since:nextMonthFirstDay)
        let dayComponent = (calendar as NSCalendar).components([.year, .month, .day, .weekday], from: finalDayInThisMonth)
        
        return dayComponent
    }
    
}
