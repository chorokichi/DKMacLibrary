//
//  ExFile.swift
//  DKMacLibrary
//
//  Created by yuya on 2019/04/27.
//

import Foundation

public struct ExFile{
    // 呼び出し元のファイル名を返す
    public static func getFileName(classFile: String = #file) -> String
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
    
    // CoreDataのファイルなどを保存するフォルダーのパスを取得するメソッド
    public static func getFolderPathHavingCoreDataFile() -> String
    {
        let supportDirectory = FileManager.SearchPathDirectory.applicationSupportDirectory
        let searchPathDomainMask = FileManager.SearchPathDomainMask.allDomainsMask
        let directories = NSSearchPathForDirectoriesInDomains(supportDirectory, searchPathDomainMask, true)
        return directories.first ?? "Not Found path"
    }
}
