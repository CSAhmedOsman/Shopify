//
//  ProductCollectionCell.swift
//  SwiftCart
//
//  Created by Elham on 10/06/2024.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var addFavBtnOL: UIButton!
    
    var isFavorited = false
    var isCellNowFav = false

    
    override func layoutSubviews() {
        super.layoutSubviews()
        img.layer.cornerRadius = 20
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
    }
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.contentView.layer.cornerRadius = 30
        self.contentView.layer.borderWidth = 1.0
        let secColor = UIColor(.black)
        self.contentView.layer.borderColor = secColor.cgColor

        setBtnImg()
    }
    
    
    @IBAction func addToCartBtn(_ sender: Any) {
        // TODO: Add to cart logic
    }
    
    
    @IBAction func addToFavBtn(_ sender: Any) {
        
        if isCellNowFav {
            // here logic of Anas // TODO: Remove From Fav logic
        } else {
            // here logic of elham // TODO: Add to Fav logic
            isFavorited.toggle()
            setButtonImage(isFavorited: isFavorited)
        }
    }
    
    func setButtonImage(isFavorited: Bool) {
        // TODO: Bougs here >><< when scroll the fill reused again
        let imageName = isFavorited ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        addFavBtnOL.setImage(image, for: .normal)
    }
    
    func setBtnImg() {
        if isCellNowFav {
            let image = UIImage(systemName: "trash")
            addFavBtnOL.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "heart")
            addFavBtnOL.setImage(image, for: .normal)
        }
    }
}
