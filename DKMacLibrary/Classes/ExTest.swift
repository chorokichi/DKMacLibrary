//
//  ExTest.swift
//  DKMacLibrary
//
//  Created by yuya on 2019/04/27.
//

import Foundation

public class ExTest {
    /// テスト実行中の判定(DEBUG以外では必ずfalse)。didFinishLaunchingWithOptionsに次のように埋め込むと良い。
    /// ```
    /// // iOS
    /// guard !isTesting() else {
    ///     window?.rootViewController = UIViewController()
    ///     return true
    /// }
    /// ```
    /// - Returns: テスト判定結果
    public static func isTesting() -> Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
