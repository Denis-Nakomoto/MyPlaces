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
    private var ratingButtons = [UIButton]()
    var rating = 0
    
    private func setupButton(){
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        for _ in 0..<starCount {
            let button = UIButton()
            button.backgroundColor = .red
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
    }
    
    @objc func buttonAction(button: UIButton){
        print("Button pressed")
    }
}
