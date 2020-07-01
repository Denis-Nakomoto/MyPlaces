//
//  Place.swift
//  My Places
//
//  Created by Smart Cash on 25.06.2020.
//  Copyright © 2020 Denis Svetlakov. All rights reserved.
//

import RealmSwift

class Places: Object {
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    
    convenience init (name: String, location: String?, type: String?, imageData: Data?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
}
