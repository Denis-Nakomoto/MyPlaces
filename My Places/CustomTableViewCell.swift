//
//  CustomTableViewCell.swift
//  My Places
//
//  Created by Smart Cash on 24.06.2020.
//  Copyright © 2020 Denis Svetlakov. All rights reserved.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var imageOfPlace: UIImageView! {
        didSet{
            imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height / 2
            imageOfPlace.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet var mainScreenRating: MainScreenRating!
    @IBOutlet var cosmosView: CosmosView!{
        didSet{
            cosmosView.settings.updateOnTouch = false
        }
    }
}
