//
//  TypeListViewController.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2019/05/01.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa
import DKMacLibrary

class TypeListViewController: NSViewController {

    @IBOutlet weak var outlineView: NSOutlineView!

    let viewModel:TypeListViewModel
    
    required init?(coder: NSCoder) {
        self.viewModel = TypeListViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExLog.method()
        ExLog.log(self.outlineView)
        
        self.outlineView.delegate = self
        self.outlineView.dataSource = self
    }
    
    @IBAction func onHelp(_ sender: NSButton) {
        ExLog.method()
        ExLog.separatorLine("=", repeatNum: 25)
        ExLog.log("\(String(describing: type(of: self))): \(self.view.frame)")
        ExLog.log(self.parent)
        ExLog.separatorLine("=", repeatNum: 25)
    }
}

extension TypeListViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem category: Any?) -> Any {
        if category == nil {
            ExLog.log("[index: \(index)] category is nil.")
            return viewModel.getCategory(index)
        }
        
        if let category = category as? TestCategory, category.items.count > index {
            ExLog.log("[index: \(index)] Found this category(\(category.name)).")
            return category.items[index]
        }
        
        ExLog.log("[index: \(index)] Not found any TestCategory.")
        return ""
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable category: Any) -> Bool {
        ExLog.log(category)
        guard let category = category as? TestCategory else {
            ExLog.log("Not found TestCategory")
            return false
        }
        
        ExLog.log("This category(\(category.name)) has \(category.items.count) test items.")
        return !category.items.isEmpty
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem category: Any?) -> Int {
        // If category is nil,
        // this method should return the number of children for the top-level item.
        if category == nil {
            // top level
            let topLevelCount = self.viewModel.getCategories().count
            ExLog.log("topLevelCount: \(topLevelCount)")
            return topLevelCount
        }
        
        if let category = category as? TestCategory {
            let secondLevelCount = category.items.count
            ExLog.log("SecondLevelCount: \(secondLevelCount)")
            return secondLevelCount
        }
        
        
        ExLog.log("Not found any items")
        return 0
    }
}

extension TypeListViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?{
        ExLog.log(item)
        guard let itemProtocol = item as? ItemProtocol else {
            fatalError(String(describing: item))
        }
        
        let v = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as? NSTableCellView
        
        if let tf = v?.textField {
            tf.stringValue = itemProtocol.getShownName()
        }
        return v
    }
    
    func outlineView(_ outlineView: NSOutlineView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet{
        return proposedSelectionIndexes
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification){
        ExLog.method()
        guard let outlineView = notification.object as? NSOutlineView else{
            fatalError()
        }
        
        let object = outlineView.item(atRow: outlineView.selectedRow)
        guard let testItem = object as? TestItem else{
            // TestItem以外は無視
            ExLog.log("Ignore anything except for TestItem")
            ExLog.log(String(format: "\"%@\": (Column, Row)=(%d, %d)", (object as? ItemProtocol)?.getShownName() ?? "nil", outlineView.selectedColumn, outlineView.selectedRow))
            return
        }
        
        self.viewModel.emit(testItem)
    }
}
