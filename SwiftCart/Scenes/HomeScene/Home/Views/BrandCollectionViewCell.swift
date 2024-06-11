//
//  BrandCollectionViewCell.swift
//  SwiftCart
//
//  Created by Elham on 02/06/2024.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = 30
        self.contentView.layer.borderWidth = 1.0
        let secColor = UIColor(.black)
        self.contentView.layer.borderColor = secColor.cgColor
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    
}
