//
//  LogUtil.swift
//  PeopleTable
//
//  Created by yuya on 2016/03/10.
//  Copyright © 2016年 yuya. All rights reserved.
//

import Foundation

open class ExLog{
    
    // ファイルにログを出力するかどうか
    private static var ShouldFileOutput = false
    #if DEBUG
    private static let Debug = true
    #else
    private static let Debug = false
    #endif
    
    
    /// 初期設定。AppDelegateのapplicationDidFinishLaunchingで呼び出すことを想定している
    /// - parameter appName: ログファイルを格納するドキュメントフォルダー内のフォルダー名(Init: "DKMacLibraryTest")
    /// - parameter fileName: ログファイル名(Init: "debug-log.log")
    open static func configure(appName:String? = nil, fileName:String? = nil, shouldFileOutput:Bool? = nil){
        
        if let appName = appName{
            AppName = appName
        }
        if let fileName = fileName{
            FileName = fileName
        }
        if let shouldFileOutput = shouldFileOutput{
            ShouldFileOutput = shouldFileOutput
        }
    }
    
    /// デバッグ時しか実行したくないコードによってのみ取得できるログを出力するメソッド。コールバックメソッドの返り値がログ出力される。
    open static func log(classFile: String = #file,
                         functionName: String = #function,
                         lineNumber: Int = #line,
                         type: ExLogType = .Info, _ runOnDebug:() -> Any?){
        if Debug{
            let msg = runOnDebug()
            ExLog.log(msg,
                      classFile:classFile,
                      functionName:functionName,
                      lineNumber:lineNumber,
                      type:type)
        }
    }
    
    /// メソッド名をログに出力
    open static func method(classFile: String = #file,
                         functionName: String = #function,
                         lineNumber: Int = #line,
                         type: ExLogType = .Info){
        if Debug{
            let msg = functionName
            ExLog.log(msg,
                      classFile:classFile,
                      functionName:functionName,
                      lineNumber:lineNumber,
                      type:type)
        }
    }
    
    open static func emptyLine(_ lineNums:Int = 1){
        if Debug{
            var msg = ""
            for _ in 0..<lineNums{
                msg = msg + "\n"
            }
            output(msg)
        }
    }
    
    open static func separatorLine(_ character:String = "-", repeatNum:Int = 10){
        if Debug{
            var msg = ""
            for _ in 0..<repeatNum{
                msg = msg + character
            }
            output(msg)
            history = msg
        }
    }
    
    open static func log(_ object: Any? = "No Log",
                    classFile: String = #file,
                    functionName: String = #function,
                    lineNumber: Int = #line,
                    type: ExLogType = .Info,
                    format: ExLogFormat = .Normal)
    {
        if Debug{
            // 日時フォーマット
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            // 日時・クラス名・メソッド名を出力
            
            let date = dateFormatter.string(from: Date())
            let objString = object ?? "nil"
            let classDetail = URL(string: String(classFile))?.lastPathComponent  ?? classFile
            let formatMsg = format.string(emoji: type.getEmoji(), date: date, msg: objString, classDetail: classDetail, lineNumber: lineNumber)
            output(formatMsg)
        }
    }
    
    open static func error(_ object: Any? = "No Log",
                         classFile: String = #file,
                         functionName: String = #function,
                         lineNumber: Int = #line,
                         format: ExLogFormat = .Normal){
        log(object, classFile: classFile, functionName:functionName, lineNumber:lineNumber, type: .Error, format:format)
    }
    
    static func printPath()
    {
        let supportDirectory = FileManager.SearchPathDirectory.applicationSupportDirectory
        let searchPathDomainMask = FileManager.SearchPathDomainMask.allDomainsMask
        let directories = NSSearchPathForDirectoriesInDomains(supportDirectory, searchPathDomainMask, true)
        output(directories.first ?? "見つかりませんでした")
    }
}

/// Util系
extension ExLog{
    // CoreDataのファイルなどを保存するフォルダーのパスを取得するメソッド
    open static func getFolderPathHavingCoreDataFile() -> String
    {
        let supportDirectory = FileManager.SearchPathDirectory.applicationSupportDirectory
        let searchPathDomainMask = FileManager.SearchPathDomainMask.allDomainsMask
        let directories = NSSearchPathForDirectoriesInDomains(supportDirectory, searchPathDomainMask, true)
        return directories.first ?? "Not Found path"
    }
    
    open static func getFileName(classFile: String = #file) -> String
    {
        if let fileNameWithExtension = URL(string: String(classFile))?.lastPathComponent {
            if case let fileName = fileNameWithExtension.components(separatedBy: "."), fileName.count > 0{
                return fileName[0]
            }
            return fileNameWithExtension
        } else {
            return classFile
        }
    }
    
    /// テスト実行中の判定(DEBUG以外では必ずfalse)。didFinishLaunchingWithOptionsに次のように埋め込むと良い。
    /// ```
    /// // iOS
    /// guard !isTesting() else {
    ///     window?.rootViewController = UIViewController()
    ///     return true
    /// }
    /// ```
    /// - Returns: テスト判定結果
    open static func isTesting() -> Bool {
        if Debug{
            return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        }else{
            return false
        }
    }
}

// 出力先制御
extension ExLog{
    private static var AppName = "DKMacLibraryTest"
    private static var FileName = "debug-log.log"
    
    // 直前の表示内容を記録している文字列
    open static var history:String = ""
    private static func output(_ msg:String){
        print(msg)
        if ShouldFileOutput{
            outputToFile(msg)
        }
        history = msg
    }
    
    private static func outputToFile(_ msg:String){
        // To Download this file
        // iOS: you have to add "Application supports iTunes file sharing=true" flag to info.plist/
        // MacOS: check Document folder
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("dir is nil")
            return
        }
        
        let folderUrl = dir.appendingPathComponent(AppName)
        
        let fileUrl = folderUrl.appendingPathComponent(FileName)
        
        let path = folderUrl.path
        if !fm.fileExists(atPath: path){
            do {
                try fm.createDirectory( atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                //エラー処理
                print("Fail to create folder: \(fileUrl)")
                return
            }
        }
        
        guard let output = OutputStream(url: fileUrl, append: true) else{
            print("output is nil")
            return
        }
        
        output.open()
        
        defer{
            output.close()
        }
        
        guard let data = (msg + "\n").data(using: .utf8, allowLossyConversion: false) else{
            return
        }
        let result = data.withUnsafeBytes {
            output.write($0, maxLength: data.count)
        }
        
        if result <= 0{
            print("[\(result)]fail to write msg into \(fileUrl)")
        }
    }
}

public enum ExLogType : String{
    case Info = ""
    case Important = "[Important]"
    case Debug = "[DEBUG]"
    case Error = "[Error]"
    
    func getEmoji() -> String{
        //絵文字表示: command + control + スペースキー
        switch self{
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

public enum ExLogFormat{
    case Normal
    case Short
    case Raw
    
    func string(emoji:String, date:String, msg:Any, classDetail:String, lineNumber:Int) -> String{
        
        let threadName = Thread.isMainThread ? "Main" : "Sub "
        
        switch self{
        case .Normal:
            return "[\(threadName)][\(emoji)][\(date)]:\(msg) [\(classDetail)(\(lineNumber))]"
        case .Short:
            return "[\(threadName)][\(emoji)][\(date)]:\(msg) [\(classDetail)(\(lineNumber))]"
        case .Raw:
            return "\(msg)"
        }
    }
}
