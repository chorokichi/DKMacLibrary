//
//  DKResult.swift
//  DKLibrary
//
//  Created by yuya on 2017/06/17.
//  Copyright © 2017年 yuya. All rights reserved.
//

import Foundation

public enum DKResult<T, Error> {
    case success(T)
    case failure(Error)
}
