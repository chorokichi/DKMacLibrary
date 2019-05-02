//
//  ExDate.swift
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

public class ExDate {
    
    static let DefaultLocale = "en_US"
    static let DefaultDateFormat = "yyyy/MM/dd HH:mm:ss"
    
    public enum Format {
        case defined(DefaultFormat)
        case custom(String)
    }
    
    public enum DefaultFormat: String {
        case full = "yyyy/MM/dd HH:mm:ss"
        case short = "yyyy/MM/dd"
    }
    
    /// 年月日から日付型作成
    /// - parameter year: 年
    /// - parameter month: 月
    /// - parameter day: 日
    /// - returns: 日付
    public static func createDate(year y: Int, month m: Int, day d: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        guard let date = calendar.date(from: DateComponents(year: y, month: m, day: d)) else {fatalError()}
        return date
    }
    
    /// 年月日から日付型作成
    /// - parameter y: 年
    /// - parameter m: 月
    /// - parameter d: 日
    /// - returns: 日付
    public static func createDate(_ y: Int, _ m: Int, _ d: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        guard let date = calendar.date(from: DateComponents(year: y, month: m, day: d)) else {fatalError()}
        return date
    }
    
    /// 日付型から指定したフォーマットで文字列作成
    /// - parameter date: 日付
    /// - parameter format: フォーマット
    /// - parameter locale: 地域：nilならen_USを利用する。
    /// - returns: 日付の文字列
    public static func display(_ date: Date, format: Format, locale: String? = nil) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: locale ?? DefaultLocale) // ロケールの設定
        switch format {
        case let .defined(defaultFormat):
            dateFormatter.dateFormat = defaultFormat.rawValue
        case let .custom(format):
            dateFormatter.dateFormat = format
        }
        return dateFormatter.string(from: date)
    }

    public static func dateByAddingDay(value: Int, date: Date) -> Date {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        guard let date = calendar.date(byAdding: .day, value: value, to: date) else {fatalError()}
        return date
    }
    
    public static func dateByAddingMonth(value: Int, date: Date) -> Date {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        guard let createdDate = calendar.date(byAdding: .month, value: value, to: date) else {fatalError()}
        return createdDate
    }
}
