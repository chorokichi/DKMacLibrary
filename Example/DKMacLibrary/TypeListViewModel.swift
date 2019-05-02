//
//  TypeListViewModel.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2019/05/01.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import DKMacLibrary
import RxSwift

class TypeListViewModel {
    
    deinit {
        ExLog.method()
    }
    
    private let disposeBag = DisposeBag()
    
    private let categories:[TestCategory]
    
    private let selectionSubject: PublishSubject<TestItem>
    
    init() {
        self.selectionSubject = PublishSubject<TestItem>()
        self.categories = TypeListViewModel.createTestCategories()
        ExLog.method()
    }
    
    func getCategory(_ index:Int) -> TestCategory{
        return self.categories[index]
    }
    
    func getCategories() -> [TestCategory]{
        return self.categories
    }
    
    func emit(_ item:TestItem){
        self.selectionSubject.onNext(item)
    }
    
    func getObservable() -> Observable<TestItem>{
        return self.selectionSubject.asObservable()
    }
    
    private static func createTestCategories() -> [TestCategory]{
        return [
            TestCategory(name: "Check ExLog", items: [TestItem(name: "Normal Log", type: .ExLog)]),
            TestCategory(name: "Check DKCoreDate", items: [TestItem(name: "Type1", type: .CoreData)])
        ]
    }
}
