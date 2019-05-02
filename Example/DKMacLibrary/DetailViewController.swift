//
//  DetailViewController.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2019/05/02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa
import DKMacLibrary

class DetailViewController: NSViewController {

    @IBOutlet weak var containerView: NSView!
    
    let viewModel: DetailViewModel
    
    required init?(coder: NSCoder) {
        self.viewModel = DetailViewModel()
        super.init(coder: coder)
        
        self.viewModel.setUp(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExLog.method()
    }
    
    @IBAction func onHelp(_ sender: NSButton) {
        ExLog.method()
        ExLog.separatorLine("=", repeatNum: 25)
        ExLog.log(containerView)
        ExLog.log(children)
        ExLog.separatorLine("=", repeatNum: 25)
    }
    
    
    private func swapContentController<T:NSViewController>(content:T, container:NSView){
        ExLog.method()
        
        container.subviews.forEach{$0.removeFromSuperview()}
        
        let tChildren = children.filter { $0 is T }
        if tChildren.count == 0{
            addChild(content)
            content.view.frame = container.bounds
            container.addSubview(content.view)
            return
        }
        
        guard tChildren.count == 1 else{
            fatalError()
        }
        
        container.addSubview(tChildren[0].view)
    }
    
    private func createCoreDataViewController() -> CoreDataViewController{
        guard let vc = self.storyboard?.instantiateController(withIdentifier: "CoreDataViewController") as? CoreDataViewController else{
            fatalError()
        }
        return vc
    }
    
    private func createExLogViewController() -> ExLogViewController{
        guard let vc = self.storyboard?.instantiateController(withIdentifier: "ExLogViewController") as? ExLogViewController else{
            fatalError()
        }
        return vc
    }
}

extension DetailViewController: UIDetailViewAction{
    func updateContinerViewController(vcType: ViewControllerType) {
        switch vcType {
        case .CoreData:
            self.swapContentController(content: self.createCoreDataViewController(), container: self.containerView)
        case .ExLog:
            self.swapContentController(content: self.createExLogViewController(), container: self.containerView)
        }
        
    }
}

