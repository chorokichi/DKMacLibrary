//
//  CoreDataViewController.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2019/05/02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa
import DKMacLibrary
class CoreDataViewController: NSViewController {

    deinit {
        ExLog.method()
    }
    
    @IBOutlet weak var messageTextField: NSTextField!
    @IBOutlet weak var listButton: NSButton!
    @IBOutlet weak var addButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExLog.method()
        
        self.confirmCoreDataStatus()
    }
    
    private func confirmCoreDataStatus(){
        ExLog.method()
        listButton.isEnabled = false
        addButton.isEnabled = false
        let result = CoreDataA.initInstance(completionHandler: { (_: NSManagedObjectContext?) in
            ExLog.log("Initialized!")
            self.listButton.isEnabled = true
            self.addButton.isEnabled = true
        })
        ExLog.log(result)
        switch result {
        case .Initilazed:
            listButton.isEnabled = true
            addButton.isEnabled = true
        default:
            ExLog.log("Waiting to finish the initialization...")
        }
    }
    
    
    @IBAction func onList(_ sender: NSButton) {
        ExLog.method()
        ExLog.separatorLine("=", repeatNum: 25)
        
        guard let context = CoreDataA.getContext() else{
            fatalError()
        }
        
        do{
            guard let testAs = try context.fetch(TestA.fetchRequest()) as? [TestA] else{
                fatalError()
            }
            
            ExLog.log(testAs.count)
            testAs.forEach{ExLog.log(String(format: "%@(%@)", $0.message ?? "nil", $0.id ?? "nil"))}
        }catch{
            ExLog.error(error)
        }
        ExLog.separatorLine("=", repeatNum: 25)
    }
    @IBAction func onAdd(_ sender: NSButton) {
        ExLog.method()
        
        guard let message = self.messageTextField?.stringValue, !message.isEmpty else{
            ExLog.log("message is empty or nil.")
            return
        }
        
        guard let context = CoreDataA.getContext() else{
            fatalError()
        }
        
        let test = TestA(context: context)
        test.id = "\(Date().timeIntervalSince1970)"
        test.message = message
        
        do{
            try context.save()
        }catch{
            ExLog.error(error)
        }
    }
    
    
}
