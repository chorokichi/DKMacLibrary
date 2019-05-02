//
//  DKTextUtil.swift
//  DKLibrary
//
//  Created by yuya on 2017/03/19.
//  Copyright © 2017年 yuya. All rights reserved.
//

import Foundation

public struct DKTextUtil {
    public static func isEmpty(str: String?) -> Bool {
        if let str = str, str != "" {
            return false
        } else {
            return true
        }
    }
    
    public static func deleteSpaceAndNewLines(str: String) -> String {
        let trimedStr = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimedStr
    }
}
