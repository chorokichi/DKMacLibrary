//
//  DKRecords.swift
//  DKLibrary
//
//  Created by yuya on 2017/06/18.
//  Copyright © 2017年 yuya. All rights reserved.
//

import Foundation

/// カスタムNSManagedObject。このクラスを継承させて使うと便利。
/// EntityNameをオーバーライドしたクラスを定義すれば、フェッチや作成(空)、削除の静的メソッドが利用可能。
/// 他にも次の二つのコンピュート変数を子クラスでオーバーライドすれば次のような使い方ができる
/// 1. PrimaryAttribute: fetchOneRecordで主キーでの一件だけの検索が可能。createEmptyEntityでvalueOfPrimaryAttributeに主キーの値をセットすれば、既存データの場合は新規作成ではなく、その既存データを取得し返す。
/// 2. MandatoryAttributes
open class DKRecords: NSManagedObject {
    public enum Result {
        case New
        case Updated
        case Fail(String)
    }
    
    // MARK: - [クラス・スタティック変数・関数] -
    
    /// 主キーとしている属性名
    open class var PrimaryAttribute: String? {
        return nil
    }
    
    /// 必須の属性名
    open class var MandatoryAttributes: [String] {
        return []
    }
    
    open class var EntityName: String {
        ExLog.error("Not Defined in Sub class")
        fatalError("Not Defined in Sub class")
    }
    
    /// 空のエンティティを作成する[永続保存されない]
    /// 注意：
    /// ・主キーで一致するデータがある場合は、そのデータを返す
    /// ・主キーで一致するデータがない場合は、新規にデータを作成して主キーの値のみ設定する
    public static func createEmptyEntity<T: DKRecords>(_ context: NSManagedObjectContext, valueOfPrimaryAttribute value: String? = nil, type: T.Type) -> (result: DKRecords.Result, record: T) {
        
        // 主キーで一致するデータがある場合は、そのデータを返す
        if let value = value {
            guard let AttrName = T.PrimaryAttribute else {
                fatalError("主キーの設定が子クラスでされていないにもかからず主キーの値(\(value))で検索しようとしている。")
            }
            
            if let record: T = T.fetchOneRecord(context, valueOfPrimaryAttribute: value, type: type) {
                return (.Updated, record)
            } else {
                guard let record: T = NSEntityDescription.insertNewObject(forEntityName: T.EntityName, into: context) as? T else {
                    fatalError("record should not be nil.")
                }
                record.setValue(value, forKey: AttrName)
                return (.New, record)
            }
        } else {
            if let AttrName = T.PrimaryAttribute {
                fatalError("主キー(\(AttrName))の設定が子クラスでされているにもかからず主キーの値が設定されていない。")
            }
        }
        
        guard let record: T = NSEntityDescription.insertNewObject(forEntityName: T.EntityName, into: context) as? T else {
            fatalError("record should not be nil.")
        }
        return (.New, record)
    }
    
    @nonobjc open class func fetchRequest<T: DKRecords>() -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: self.EntityName)
    }
    
    /// typeを引数に設定しないと宣言時に明示的にDKRecordsのサブクラスを設定する必要があり、実行時エラーの原因になる。そのため、typeをメソッド呼び出し時に強制することでそのエラーを抑えることを狙っている。
    public static func fetchRecords<T: DKRecords>(_ context: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor] = [], predicate: NSPredicate? = nil, type: T.Type) throws -> [T] {
        let fetchRequest: NSFetchRequest<T> = self.fetchRequest()
        if sortDescriptors.count > 0 {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        let records: [T] = try context.fetch(fetchRequest)
        return records
    }
    
    /// typeを引数に設定しないと宣言時に明示的にDKRecordsのサブクラスを設定する必要があり、実行時エラーの原因になる。そのため、typeをメソッド呼び出し時に強制することでそのエラーを抑えることを狙っている。
    public static func fetchOneRecord<T: DKRecords>(_ context: NSManagedObjectContext, valueOfPrimaryAttribute value: String, type: T.Type) -> T? {
        guard let attr = PrimaryAttribute else {
            // 主キーがない
            return nil
        }
        
        let predicate = NSPredicate(format: "\(attr) == %@", value)
        guard let records: [T] = try? self.fetchRecords(context, predicate: predicate, type: type) else {
            assertionFailure("fetchRecords中にエラー発生")
            return nil
        }
        
        // 取得レコード数に応じて処理分け(2件以上はありえないはず)
        if records.count == 1 {
            return records[0]
        } else if records.count == 0 {
            return nil
        } else {
            assertionFailure("主キーによる検索にもかかわらず結果が\(records.count)件！！！！")
            return nil
        }
        
    }
    
    /// すべてのレコードを削除する[永続はされない]
    public static func deleteAllRecords(_ context: NSManagedObjectContext) throws {
        let entityDiscription = NSEntityDescription.entity(forEntityName: self.EntityName, in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDiscription
        if let results = try context.fetch(fetchRequest) as? [DKRecords] {
            for result in results {
                context.delete(result)
            }
        }
    }
    
    // MARK: - [メンバ関数] -
    /// 削除(永続保存されない)
    open func delete() {
        if let context = self.managedObjectContext {
            context.delete(self)
        }
    }
    
    /// 保存（永続化処理）
    /// 注意：関連するコンテキストの変更点が全て保存される。
    open func save() throws -> Bool {
        return try DKRecordUtil.saveContext(self.managedObjectContext)
    }
}
