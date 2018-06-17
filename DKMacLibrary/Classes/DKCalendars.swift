//
//  PTCalendars.swift
//  PeopleTable
//
//  Created by yuya on 2017/06/01.
//  Copyright © 2017年 yuya. All rights reserved.
//

import Foundation

/// 月カレンダー
/// 使い方
/// 1. 初期化でDateとカレンダーサイズ、週初めの曜日を指定。ここで設定したDateの日が強調されて、その月のカレンダーが表示される
/// 2. updateで日付を更新すると月も変わる
public struct DKCalendars<T>
{
    private let calendarSize:Int
    public let startWeek:DKWeekDay
    
    // 注目している日付
    public var markedDate:DKDateUtil.SDate<T>
    public var year:Int!
    public var month:Int!
    public var days:[DKDateUtil.SDate<T>] = []
    
    public init(markedDate:Date = Date(), calendarSize:Int, startWeek:DKWeekDay = .Sun) throws
    {
        guard let date:DKDateUtil.SDate<T> = DKDateUtil.getSimpleDate(from: markedDate) else
        {
            fatalError()
        }
        self.markedDate = date
        self.calendarSize = calendarSize
        if calendarSize % 7 != 0
        {
            assertionFailure("カレンダーの日付数は７の倍数でないと動作しない：推奨7*6")
        }
        self.startWeek = startWeek
        try self.construct()
    }
    
    public mutating func update(_ newTargetMonth:Date)
    {
        guard let date:DKDateUtil.SDate<T> = DKDateUtil.getSimpleDate(from: newTargetMonth) else
        {
            fatalError()
        }
        self.markedDate = date
        try? self.construct()
    }
    
    private mutating func construct() throws
    {
        guard let firstDate:DKDateUtil.SDate<T> = DKDateUtil.getFirstDay(self.markedDate.date) else
        {
            assertionFailure()
            return
        }
        
        // カレンダーの最初の日付
        let cDate:Date = { () -> Date in
            if firstDate.weekDay == self.startWeek
            {
                return firstDate.date
            }
            else
            {
                let difference:Int
                if(firstDate.weekDay.rawValue > self.startWeek.rawValue)
                {
                    difference = -1 * abs(firstDate.weekDay.rawValue - self.startWeek.rawValue)
                }
                else
                {
                    difference = -1 * abs(self.startWeek.rawValue - firstDate.weekDay.rawValue)
                }
                guard let date = DKDateUtil.dateByAddingDay(value: difference, date: firstDate.date) else
                {
                    fatalError()
                }
                return date
            }
        }()
        
        
        self.days = []
        
        
        for i in 0 ..< calendarSize
        {
            let date = DKDateUtil.dateByAddingDay(value: i, date: cDate)
            guard let lDate:DKDateUtil.SDate<T> = DKDateUtil.getSimpleDate(from: date) else{
                fatalError()
            }
            self.days.append(lDate)
        }
    }
    
}
