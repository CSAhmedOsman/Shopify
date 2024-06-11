//
//  FavVC.swift
//  SwiftCart
//
//  Created by Anas Salah on 11/06/2024.
//

import UIKit

struct ProductDumy {
    let name: String
    let price: String
    let imageName: String
}

class FavVC: UIViewController {

    var coordinator: AppCoordinator?
    var products: [ProductDumy] = []

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "ProductCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        for i in 1...15 {
            products.append(ProductDumy(name: "Product \(i)", price: "$\(i * 10)", imageName: "9"))
        }
        
        collectionView.reloadData()
    }

    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
}

extension FavVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionCell
        
        let product = products[indexPath.item]
//        cell.ProductName.text = product.title
//        cell.price.text = product.variants[0].price
//        cell.img.image = UIImage(named: product.images[0].src)
        cell.ProductName.text = product.name
        cell.price.text = product.price
        cell.img.image = UIImage(named: product.imageName)
        // Set isCellNowFav to true for all cells
        cell.isCellNowFav = true
        cell.setBtnImg()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let sectionInset: CGFloat = 10
        let totalSpacing = sectionInset * 2 + spacing
        let width = (collectionView.frame.width - totalSpacing) / 2
        print("DONE!!")
        print("DONE!!")
        print("DONE!!")
        return CGSize(width: width, height: 150)
    }
}

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
