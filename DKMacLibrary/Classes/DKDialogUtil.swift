//
//  DialogUtil.swift
//  PeopleTable
//
//  Created by yuya on 2016/03/31.
//  Copyright © 2016年 yuya. All rights reserved.
//

import Foundation
import Cocoa

public class DKDialogUtil{
    
    public static func startDialog(_ title:String, message:String? = nil, onClickOKButton:()->()){
        // Swiftの場合
        let alert = NSAlert()
        alert.messageText = title
        if let message = message{
            alert.informativeText = message
        }
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "キャンセル")
        let result = alert.runModal()
        if (result == NSApplication.ModalResponse.alertFirstButtonReturn) {
            ExLog.log("OK")
            onClickOKButton()
        }
    }
    
    /// This method has an issue(http://openradar.appspot.com/28700495).
    /// - parameter <#型#>: <#説明#>
    /// - returns: <#返り値の説明#>
    public static func alertDialog(_ title:String, onClickOKButton:()->() = {}){
        // Swiftの場合
        let alert = NSAlert()
        alert.messageText = title
        alert.addButton(withTitle: "OK")
        let result = alert.runModal()// Apple Issue: http://openradar.appspot.com/28700495
        if (result == NSApplication.ModalResponse.alertFirstButtonReturn) {
            ExLog.log("OK")
            onClickOKButton()
        }
    }
}
