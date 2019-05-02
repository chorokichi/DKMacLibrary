//
//  DKGcd.swift
//  DKLibrary
//
//  Created by yuya on 2017/07/02.
//  Copyright © 2017年 yuya. All rights reserved.
//

import Foundation

// スレッドの連続実行などの機能をサポートする予定
public class DKGcd<T> {
    public enum Status {
        case InProgress
        case NotStarted
        case FacedError(Error)
    }
    
    public enum SingleResult {
        case NoError
        case Cancel
        case Error
    }
    
    /// work関数内の処理を必ずMainThread上でasync実行させるためのメソッド
    public static func asyncOnMain(_  work:@escaping () -> Void) {
        if Thread.isMainThread {
            work()
            return
        }
        DispatchQueue.main.async {
            work()
        }
    }
    
    /// work関数内の処理を必ずMainThread上でasync実行させるためのメソッド
    public static func async(qos: DispatchQoS.QoSClass = .default, _ work:@escaping () -> Void) {
        DispatchQueue.global(qos: qos).async {
            work()
        }
    }
    
    public static func  executeMultiWorksAsAsyncedOneWork(qos: DispatchQoS.QoSClass = .default, param: T?, works: [DKWork], completionHandler:@escaping (_ excuetedNumber: Int) -> Void) {
        let gcd = DKGcd(qos: qos, param: param)
        gcd.add(works: works)
        gcd.async { (excuetedNumber: Int) in
            completionHandler(excuetedNumber)
        }
    }
    
    public typealias DKWork = (T?)->(DKGcd.SingleResult)
    public var status: DKGcd.Status
    private var works: [DKWork]
    private var qos: DispatchQoS.QoSClass
    private let param: T?
    init(qos: DispatchQoS.QoSClass = .default, param: T? = nil) {
        self.works = []
        self.status = .NotStarted
        self.qos = qos
        self.param = param
    }
    
    func add(work:@escaping DKGcd.DKWork) {
        self.works.append(work)
    }
    
    func add(works: [DKGcd.DKWork]) {
        self.works.append(contentsOf: works)
    }
    
    func async(completionHandler:@escaping (_ excuetedNumber: Int) -> Void) {
        DispatchQueue.global(qos: qos).async {
            for i in 0 ..< self.works.count {
                let result = self.works[i](self.param)
                
                guard result == DKGcd.SingleResult.NoError else {
                    completionHandler(i)
                    return
                }
            }
            completionHandler(self.works.count)
        }
    }
}
