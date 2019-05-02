//
//  AppDelegate.swift
//  DKMacLibrary
//
//  Created by Jirokichi on 06/16/2018.
//  Copyright (c) 2018 Jirokichi. All rights reserved.
//

import Cocoa
import DKMacLibrary

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        ExLog.method()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        ExLog.method()
    }
    
    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        ExLog.log()
        return CoreDataA.getContext()?.undoManager
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        ExLog.log("*** applicationShouldTerminate")
        let applicationTerminateReply = CoreDataA.saveAnyChangesBeforeApplicationTerminates(
            sender,
            context: CoreDataA.getContext(),
            runClass: self)
        return applicationTerminateReply
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
