//
//  HomeSplitViewModel.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2019/05/02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import DKMacLibrary
import RxSwift

class HomeSplitViewModel{
    
    deinit {
        ExLog.method()
    }
    
    let MasterWidth:CGFloat = 150
    
    private let disposeBag = DisposeBag()
    private var typeListViewModel:TypeListViewModel!
    private var detailViewModel:DetailViewModel!
    
    func set(typeListViewModel: TypeListViewModel){
        self.typeListViewModel = typeListViewModel
    }
    
    func set(detailViewModel: DetailViewModel){
        self.detailViewModel = detailViewModel
    }
    
    func setUpObservable(){
        guard self.validation() else{
            fatalError()
        }
        
        self.typeListViewModel.getObservable().subscribe(onNext: { (item) in
            ExLog.log("⭐️⭐️⭐️⭐️⭐️Click on \(item.getShownName())⭐️⭐️⭐️⭐️⭐️")
            self.detailViewModel.emit(type: item.type)
        }).disposed(by: disposeBag)
    }
    
    private func validation() -> Bool{
        return typeListViewModel != nil && detailViewModel != nil
    }
}
