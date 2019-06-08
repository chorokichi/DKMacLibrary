//
//  LogUtil.swift
//  PeopleTable
//
//  Created by yuya on 2016/03/10.
//  Copyright © 2016年 yuya. All rights reserved.
//

import Foundation

/// ログ用クラス
///
open class ExLog {
    #if DEBUG
    private let Debug = true
    #else
    private let Debug = false
    #endif
    
    // ファイルにログを出力するかどうか
    private var shouldFileOutput = true
    // アプリ名：ログファイルを保存するフォルダ名に利用される
    private var appName = "DKMacLibraryTest"
    // ログファイル名
    private var fileName = "debug-log.log"
    
    // 直前の表示内容を記録している文字列
    private var history: String = ""
    
    private static let instance = ExLog()
    private init() {
    }
    
    private func _log(classFile: String = #file,
                      functionName: String = #function,
                      lineNumber: Int = #line,
                      type: ExLogType = .Info,
                      format: ExLogFormat = .Normal,
                      _ runOnDebug:() -> Any?) {
        guard Debug else {
            return
        }
        
        let msg = runOnDebug() ?? "nil"
        let classDetail = URL(string: String(classFile))?.lastPathComponent  ?? classFile
        let formatMsg = format.string(emoji: type.getEmoji(),
                                      date: Date(),
                                      msg: msg,
                                      functionName: functionName,
                                      classDetail: classDetail,
                                      lineNumber: lineNumber)
        self.output(formatMsg)
    }
    
    private func output(_ formattedMsg: String) {
        // コンソールに出力
        print(formattedMsg)
        //  ファイルに出力するか決定
        if self.shouldFileOutput {
            self.outputToFile(formattedMsg)
        }
        // 履歴に保存
        self.history = formattedMsg
    }
    
    private func outputToFile(_ msg: String) {
        // To Download this file
        // iOS: you have to add "Application supports iTunes file sharing=true" flag to info.plist/
        // MacOS: check Document folder
        guard let fileUrl = self.getLogFileForLog() else {
            print("folderUrl is nil")
            return
        }
        
        guard let output = OutputStream(url: fileUrl, append: true) else {
            print("output is nil")
            return
        }
        
        output.open()
        
        defer {
            output.close()
        }
        
        guard let data = (msg + "\n").data(using: .utf8, allowLossyConversion: false) else {
            return
        }
        
        let result = data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> UInt8 in
            guard let baseAddress = pointer.bindMemory(to: UInt8.self).baseAddress else {
                return 0
            }
            output.write(baseAddress, maxLength: data.count)
            return pointer.load(as: UInt8.self)
        }

//        let result = data.withUnsafeBytes {
//            output.write($0, maxLength: data.count)
//        }
        if result <= 0 {
            print("[\(result)]fail to write msg into \(fileUrl)")
        }
    }
    
    public func getLogFileForLog() -> URL? {
        return self.createOrGetFolderForLog()?.appendingPathComponent(self.fileName)
    }
    
    public func createOrGetFolderForLog() -> URL? {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("************************")
            print("* ==> documentDirectory is nil")
            print("************************")
            return nil
        }
        let folderUrl = dir.appendingPathComponent(self.appName)
        let path = folderUrl.path
        if !fm.fileExists(atPath: path) {
            print("Not found directory and try to create this dir(\(path))")
            do {
                try fm.createDirectory( atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("************************")
                print("* ==> Created!")
                print("************************")
            } catch {
                //エラー処理
                print("************************")
                print("* ==> Fail to create folder: \(path)")
                dump("* ==> \(error)")
                print("************************")
            }
        }
        return folderUrl
    }
    
    /// 初期設定。AppDelegateのapplicationDidFinishLaunchingで呼び出すことを想定している
    /// - parameter appName: ログファイルを格納するドキュメントフォルダー内のフォルダー名(Init: "DKMacLibraryTest")
    /// - parameter fileName: ログファイル名(Init: "debug-log.log")
    public static func configure(appName: String? = nil, fileName: String? = nil, shouldFileOutput: Bool? = nil) {
        ExLog.instance.appName = appName ?? ExLog.instance.appName
        ExLog.instance.fileName = fileName ?? ExLog.instance.fileName
        ExLog.instance.shouldFileOutput = shouldFileOutput ?? ExLog.instance.shouldFileOutput
    }
    
    /// ログ出力: 全ての設定がカスタマイズ可能
    public static func log(_ object: Any? = "No Log",
                           classFile: String = #file,
                           functionName: String = #function,
                           lineNumber: Int = #line,
                           type: ExLogType = .Info,
                           format: ExLogFormat = .Normal) {
        ExLog.instance._log(classFile: classFile, functionName: functionName, lineNumber: lineNumber, type: type, format: format) {
            return object
        }
    }
    
    /// デバッグ時しか実行したくないコードによってのみ取得できるログを出力するメソッド。コールバックメソッドの返り値がログ出力される。
    public static func log(classFile: String = #file,
                           functionName: String = #function,
                           lineNumber: Int = #line,
                           type: ExLogType = .Info,
                           format: ExLogFormat = .Normal,
                           _ runOnDebug:() -> Any?) {
        ExLog.instance._log(classFile: classFile, functionName: functionName, lineNumber: lineNumber, type: type, format: format, runOnDebug)
    }
    
    /// メソッド名をログに出力
    public static func method(classFile: String = #file,
                              functionName: String = #function,
                              lineNumber: Int = #line,
                              type: ExLogType = .Info,
                              format: ExLogFormat = .Normal) {
        let msg = functionName
        ExLog.instance._log(classFile: classFile, functionName: functionName, lineNumber: lineNumber, type: type, format: format) {
            return msg
        }
    }
    
    public static func emptyLine(_ lineNums: Int = 1) {
        let log = ExLog.instance
        if log.Debug {
            var msg = ""
            for _ in 1..<lineNums {
                msg = msg + "\n"
            }
            log.output(msg)
        }
    }
    
    // 同じ文字を複数個出力する。セパレーターとして利用できる。（例：　"----------"）
    public static func separatorLine(_ character: String = "-", repeatNum: Int = 10, postFix: String? = nil) {
        let log = ExLog.instance
        if log.Debug {
            var msg = ""
            for _ in 0..<repeatNum {
                msg = msg + character
            }
            if let postFix = postFix {
               msg = msg + postFix
            }
            log.output(msg)
            log.history = msg
        }
    }
    
    public static func error(_ object: Any? = "No Log",
                             classFile: String = #file,
                             functionName: String = #function,
                             lineNumber: Int = #line,
                             format: ExLogFormat = .Normal) {
        log(object, classFile: classFile, functionName: functionName, lineNumber: lineNumber, type: .Error, format: format)
    }
    
    public static func fatalError(_ object: Any? = "No Log",
                                  classFile: String = #file,
                                  functionName: String = #function,
                                  lineNumber: Int = #line,
                                  format: ExLogFormat = .Normal) {
        log(object, classFile: classFile, functionName: functionName, lineNumber: lineNumber, type: .Error, format: format)
        fatalError(object)
    }
    
    public static func getHistory() -> String {
        return ExLog.instance.history
    }
}

public enum ExLogType: String {
    case Info = ""
    case Important = "[Important]"
    case Debug = "[DEBUG]"
    case Error = "[Error]"
    
    func getEmoji() -> String {
        //絵文字表示: command + control + スペースキー
        switch self {
        case .Info:
            return "🗣"
        case .Important:
            return "📍"
        case .Debug:
            return "✂️"
        case .Error:
            return "⚠️"
        }
    }
}

public enum ExLogFormat {
    case Normal
    case Short
    case NoPostFix
    case Raw
    func string(emoji: String, date: Date, msg: Any, functionName: String, classDetail: String, lineNumber: Int) -> String {
        // 日時フォーマット
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let threadName = Thread.isMainThread ? "Main" : "Sub "
        
        switch self {
        case .Normal:
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            let dateStr = dateFormatter.string(from: Date())
            return "[\(threadName)][\(emoji)][\(dateStr)]:\(msg) [\(functionName)/\(classDetail)(\(lineNumber))]"
        case .NoPostFix:
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            let dateStr = dateFormatter.string(from: Date())
            return "[\(threadName)][\(emoji)][\(dateStr)]:\(msg)"
        case .Short:
            dateFormatter.dateFormat = "HH:mm:ss"
            let dateStr = dateFormatter.string(from: Date())
            return "[\(threadName)][\(emoji)][\(dateStr)]:\(msg) [\(classDetail)(\(lineNumber))]"
        case .Raw:
            return "\(msg)"
        }
    }
}
