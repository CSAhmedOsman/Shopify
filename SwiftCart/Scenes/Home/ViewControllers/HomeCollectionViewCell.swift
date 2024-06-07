//
//  HomeCollectionViewCell.swift
//  SwiftCart
//
//  Created by Elham on 02/06/2024.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    override func layoutSubviews() {
        super.layoutSubviews()
        img.layer.cornerRadius = 20
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
}
