//
//  Place.swift
//  My Places
//
//  Created by Smart Cash on 25.06.2020.
//  Copyright © 2020 Denis Svetlakov. All rights reserved.
//

import UIKit

struct Places {
    var name: String
    var location: String?
    var type: String?
    var image: UIImage?
    var restaurantImage: String?
    
    static let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]
   static func getPlace() -> [Places]{
        
        var places = [Places]()
        
        for place in restaurantNames {
            places.append(Places(name: place, location: "Уфа", type: "Ресторан", image: nil, restaurantImage: place))
        }
        
        return places
    }
}
