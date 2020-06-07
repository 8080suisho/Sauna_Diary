//
//  Diary.swift
//  Sauna_Diary
//
//  Created by 諸星水晶 on 2020/05/20.
//  Copyright © 2020 諸星水晶. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Diary: Object {
   
   static let realm = try! Realm()
   
   //Diaryのプロパティを定義
   @objc dynamic private var id = 0
   @objc dynamic var date: String = ""
   @objc dynamic var title: String = ""
   @objc dynamic var note: String = ""
   @objc dynamic var photo: Data? = nil
   
   //キーの設定
   override static func primaryKey() -> String? {
       return "id"
   }
   
   //新規作成
   static func create() -> Diary {
       let diary = Diary()
       diary.id = lastId()
       return diary
   }
   
   //日付指定で読み込み
   static func search(date: Date) -> [Diary] {
       let selectedDay = Diary.changeDateType(date: date)
       let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
               if (oldSchemaVersion < 1) {
               }
       })
       Realm.Configuration.defaultConfiguration = config
       if realm.objects(Diary.self).filter("date == '\(selectedDay)'").isEmpty == false {
           let objects = realm.objects(Diary.self).filter("date == '\(selectedDay)'")
           var diaryArray: [Diary] = []
           for object in objects {
               diaryArray.append(object)
           }
           return diaryArray
       } else {
           return []
       }
       
   }
   
   //Idの設定
   static func lastId() -> Int {
       if let object = realm.objects(Diary.self).last {
           return object.id + 1
       } else {
           return 1
       }
   }
   
   //保存
   func save() {
       try! Diary.realm.write {
           Diary.realm.add(self)
       }
   }
    
   func deleate(){
    
   }
   
   //日付のフォーマット指定
   static func changeDateType(date: Date) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "MM月dd日"
       let text = dateFormatter.string(from: date)
       return text
   }
   
   

}
