//
//  CategoryCollectionViewCell.swift
//  SwiftCart
//
//  Created by Elham on 03/06/2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        img.layer.cornerRadius = 20
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
}
