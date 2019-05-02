//
//  HomeSplitViewController.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2019/05/01.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa
import DKMacLibrary

class HomeSplitViewController: NSSplitViewController {

    private let viewModel = HomeSplitViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExLog.method()
        
        ExLog.log(self.splitViewItems.count)
        self.splitViewItems.map{$0.viewController}.forEach{vc in
            ExLog.log("\(String(describing: type(of: vc.self))): \(vc.view.frame)")
        }
        
        NSLayoutConstraint(item: self.splitViewItems[0].viewController.view,
                           attribute: NSLayoutConstraint.Attribute.width,
                           relatedBy: NSLayoutConstraint.Relation.equal,
                           toItem: nil,
                           attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                           multiplier: 1, constant: viewModel.MasterWidth).isActive = true
        
        setUpViewModels()
    }
    
    /// view modelの設定
    private func setUpViewModels(){
        self.splitViewItems.map{$0.viewController}.forEach { (vc) in
            if let vc = vc as? TypeListViewController{
                viewModel.set(typeListViewModel: vc.viewModel)
            }else if let vc = vc as? DetailViewController{
                viewModel.set(detailViewModel: vc.viewModel)
            }
        }
        
        self.viewModel.setUpObservable()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        ExLog.method()
    }
    @IBAction func onTouchBarFirstButton(_ sender: NSButton) {
        ExLog.method()
    }
}
