//
//  ProductCollectionViewCell.swift
//  SwiftCart
//
//  Created by Elham on 03/06/2024.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        img.layer.cornerRadius = 20
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
}
