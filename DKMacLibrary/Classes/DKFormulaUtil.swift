//
//  DKFormulaUtil.swift
//  DKLibrary
//
//  Created by yuya on 2017/03/13.
//  Copyright © 2017年 yuya. All rights reserved.
//

import Foundation

public struct DKFormulaUtil{
    static func getRandomValue<T>(_ array:[T]) -> T{
        return array[Int(arc4random_uniform(UInt32(array.count)))]
    }
}
