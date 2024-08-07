//
//  ProductCollectionCell.swift
//  SwiftCart
//
//  Created by Elham on 10/06/2024.
//

import UIKit

protocol ProductCollectionCellDelegate: AnyObject {
    func deleteFavoriteTapped(for cell: ProductCollectionCell, completion: @escaping () -> Void)
    func saveToFavorite(for cell: ProductCollectionCell, completion: @escaping () -> Void)
    func goToDetails(item cell: ProductCollectionCell)
}

extension ProductCollectionCellDelegate {
    func deleteFavoriteTapped(for cell: ProductCollectionCell, completion: @escaping () -> Void) {
        completion()
    }

    func saveToFavorite(for cell: ProductCollectionCell, completion: @escaping () -> Void) {
        completion()
    }

    func goToDetails(item cell: ProductCollectionCell) {
    }
}

class ProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var addFavBtnOL: UIButton!
    

    weak var delegate: ProductCollectionCellDelegate?
    var indexPath: IndexPath?
    var coordinator: AppCoordinator?
    var isFavorited = false
    var isCellNowFav = false
    var isCellNowCategorie = false
    var isCellNowHome = false
    
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
    }

    func configure(with product: ProductDumy, isFavorited: Bool) {
        ProductName.text = product.name
        price.text = product.price.formatAsCurrency()
        
        if let url = URL(string: product.imageName) {
            img.load(url: url)
        } else {
            img.image = UIImage(named: product.imageName)
        }
        
        setButtonImage(isFavorited: isFavorited)
    }
    
    @IBAction func goToDetails(_ sender: Any) { // TODO:
        
        delegate?.goToDetails(item: self)
    }
    
    @IBAction func addToFavBtn(_ sender: UIButton) {
        if UserDefaultsHelper.shared.getUserData().name != nil {
            sender.configuration?.showsActivityIndicator = true
            sender.isEnabled = false
            if isCellNowFav {
                deleteItemFromFavScreen {
                    sender.configuration?.showsActivityIndicator = false
                    sender.isEnabled = true
                }
            } else if isCellNowCategorie || isCellNowHome {
                if isFavorited {
                    deleteItemFromFavScreen {
                        sender.configuration?.showsActivityIndicator = false
                        sender.isEnabled = true
                    }
                } else {
                    delegate?.saveToFavorite(for: self) {
                        self.isFavorited = true
                        self.setButtonImage(isFavorited: self.isFavorited)
                        sender.configuration?.showsActivityIndicator = false
                        sender.isEnabled = true
                    }
                }
            }
        } else {
            Utils.showAlert(title: "Sorry :(",
                            message: "Please login to open this feature",
                            preferredStyle: .alert,
                            from: self.parentViewController!)
        }

    }
    
    
    func deleteItemFromFavScreen(completion: @escaping () -> Void) {
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.delegate?.deleteFavoriteTapped(for: self) {
                self.isFavorited = false
                self.setButtonImage(isFavorited: self.isFavorited)
                completion()
            }
        })
        let no = UIAlertAction(title: "No", style: .cancel, handler: { _ in
            completion()
        })
        
        if let viewController = self.contentView.parentViewController {
            Utils.showAlert(title: "Confirmation", message: "Are you sure you want to remove \(self.ProductName.text!) from your favorites? This action cannot be undone.", preferredStyle: .alert, from: viewController, actions: [yes, no])
        } else {
            completion()
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

extension UIView { // helps with alert i present
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
