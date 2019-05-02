//
//  DetailViewModel.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2019/05/02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import DKMacLibrary


protocol UIDetailViewAction{
    func updateContinerViewController(vcType: ViewControllerType)
}

class DetailViewModel{
    
    deinit {
        ExLog.method()
    }
    
    private let selectVC = PublishSubject<ViewControllerType>()
    private var delegate: UIDetailViewAction!
    
    private let disposeBag = DisposeBag()
    init() {
        ExLog.method()
    }
    
    func setUp(delegate: UIDetailViewAction){
        self.delegate = delegate
        self.selectVC.subscribe(onNext: { type in
            self.delegate.updateContinerViewController(vcType: type)
        }).disposed(by: disposeBag)
    }
    
    func emit(type: ViewControllerType){
        self.selectVC.onNext(type)
    }
}
