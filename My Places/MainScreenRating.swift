//
//  MainScreenRating.swift
//  My Places
//
//  Created by Smart Cash on 07.07.2020.
//  Copyright © 2020 Denis Svetlakov. All rights reserved.
//

import UIKit

@IBDesignable class MainScreenRating: UIStackView {
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        ratingSetup()
    }
    override init (frame:CGRect){
        super.init (frame: frame)
        ratingSetup()
    }
    private var ratingStars = [UIImageView]()
    var starCount = 2 {
        didSet{
            ratingSetup()
        }
    }

    func ratingSetup() {
        for stars in ratingStars {
            removeArrangedSubview(stars)
            stars.removeFromSuperview()
        }
        ratingStars.removeAll()
        
        for _ in 0..<starCount {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints =  false
        imageView.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        imageView.image = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .light))
        addArrangedSubview(imageView)
        ratingStars.append(imageView)
        }
    }
}
