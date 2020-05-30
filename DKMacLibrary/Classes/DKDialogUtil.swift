//
//  DialogUtil.swift
//  PeopleTable
//
//  Created by yuya on 2016/03/31.
//  Copyright © 2016年 yuya. All rights reserved.
//

import Foundation
import Cocoa

public class DKDialogUtil {
    
    public static func startDialog(_ title: String, message: String? = nil, onClickOKButton:() -> Void) {
        let alert = NSAlert()
        alert.messageText = title
        if let message = message {
            alert.informativeText = message
        }
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "キャンセル")
        let result = alert.runModal()
        if result == NSApplication.ModalResponse.alertFirstButtonReturn {
            ExLog.log("OK")
            onClickOKButton()
        }
    }
    
    /// 警告メッセージ用のダイアログを表示する。警告用のためボタンはひとつのみ。
    /// NOTE: ボタンが押されるまで呼び出し元は次の操作にうつれない(NSAlertの仕様)。
    /// - parameter onClickOKButton: ボタン押下後に呼び出されるコールバック関数
    /// - parameter onClickOKButton: ボタン押下後に呼び出されるコールバック関数
    public static func alertDialog(_ title: String, firstButton: String = "OK", onClickOKButton:() -> Void = {}) {
        let alert = NSAlert()
        alert.messageText = title
        alert.addButton(withTitle: firstButton)
        alert.alertStyle = .informational
        
        
        let result = alert.runModal()
        if result == NSApplication.ModalResponse.alertFirstButtonReturn {
            ExLog.log("OK")
            onClickOKButton()
        }
    }
}
