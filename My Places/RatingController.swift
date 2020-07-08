//
//  RatingController.swift
//  My Places
//
//  Created by Smart Cash on 03.07.2020.
//  Copyright © 2020 Denis Svetlakov. All rights reserved.
//

import UIKit

@IBDesignable class RatingController: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setupButton()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setupButton()
        }
    }
    let emptyStar = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .thin))
    let filledStar = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .thin))
    let highlightedStar = UIImage(systemName: "star.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .thin))
    
    
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            setupSelectedRatingState()
        }
    }
    
    private func setupButton(){
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        for _ in 0..<starCount {
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.selected, .highlighted])
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
        setupSelectedRatingState()
    }
    
    @objc func buttonAction(button: UIButton){
        guard let index = ratingButtons.firstIndex(of: button) else {return}
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    private func setupSelectedRatingState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
