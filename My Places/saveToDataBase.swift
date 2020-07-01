//
//  saveToDataBase.swift
//  My Places
//
//  Created by Smart Cash on 29.06.2020.
//  Copyright © 2020 Denis Svetlakov. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static func saveObject(_ place: Places){
        try! realm.write {
            realm.add(place)
        }
    }
    static func deleteObject(_ place: Places){
        try! realm.write {
            realm.delete(place)
        }
    }
}
