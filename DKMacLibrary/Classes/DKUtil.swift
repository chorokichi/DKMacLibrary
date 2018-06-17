//
//  DKUtil.swift
//  DKLibrary
//
//  Created by yuya on 2017/07/19.
//  Copyright © 2017年 yuya. All rights reserved.
//

import Foundation

public struct DKUtil
{
    public static func unrap<T>(_ value:T?, d:T) -> T
    {
        if let value = value
        {
            return value
        }
        else
        {
            return d
        }
    }
}
