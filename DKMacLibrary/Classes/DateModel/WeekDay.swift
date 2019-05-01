//
//  WeekDay.swift
//  DKMacLibrary
//
//  Created by yuya on 2019/04/28.
//

import Foundation

public enum WeeekDayError: Error {
    case NotDefinedKey
    case NotDefinedValue
}

public enum WeekDay: Int {
    case Sun = 0
    case Mon = 1
    case Tue = 2
    case Wed = 3
    case Thu = 4
    case Fri = 5
    case Sat = 6
    
    private enum Key: String {
        case Sun
        case Mon
        case Tue
        case Wed
        case Thu
        case Fri
        case Sat
    }
    
    public init(_ int: Int?) throws {
        guard let int = int else {
            throw WeeekDayError.NotDefinedValue
        }
        
        if let tmp = WeekDay(rawValue: int) {
            self = tmp
            return
        }
        throw WeeekDayError.NotDefinedValue
    }
    
    public init(key: String) throws {
        guard let keyType: Key = Key(rawValue: key) else {
            throw WeeekDayError.NotDefinedKey
        }
        
        switch keyType {
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

    // 次の曜日を取得(自分自体も書き換える)
    @discardableResult
    public mutating func next() -> WeekDay {
        var newValue: WeekDay
        if let val = WeekDay(rawValue: self.rawValue + 1) {
            newValue = val
        } else {
            newValue = .Sun
        }
        self = newValue
        return newValue
    }
    
    // 次の曜日を取得(自分自体も書き換える)
    @discardableResult
    public mutating func back() -> WeekDay {
        var newValue: WeekDay
        if let val = WeekDay(rawValue: self.rawValue - 1) {
            newValue = val
        } else {
            newValue = .Sat
        }
        self = newValue
        return newValue
    }
    
//    public func getDisplayedValue() -> String{
//        switch self{
//        case .Sun:
//            return "日"
//        case .Mon:
//            return "月"
//        case .Tue:
//            return "火"
//        case .Wed:
//            return "水"
//        case .Thu:
//            return "木"
//        case .Fri:
//            return "金"
//        case .Sat:
//            return "土"
//        }
//    }
    
    public func getKey() -> String {
        let key: Key = self.getKey()
        return key.rawValue
    }
    
    private func getKey() -> Key {
        switch self {
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
