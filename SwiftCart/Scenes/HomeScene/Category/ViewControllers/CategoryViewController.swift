//
//  CategoryViewController.swift
//  SwiftCart
//
//  Created by Elham on 03/06/2024.
//

import UIKit
import RxSwift

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var categoriesSegmented: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var subCategoriesView: UISegmentedControl!
    
    @IBOutlet weak var topconstrensinCollectionView: NSLayoutConstraint!
    var isFilterHidden = true
    
    weak var coordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    private var products: [Product] = []
   
    var viewModel = CategoryViewModel(network: NetworkManager.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subCategoriesView.isHidden = isFilterHidden
        topconstrensinCollectionView.constant = 8
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "ProductCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        
        setupBindings()
        viewModel.getAllProducts()
    }
 
    func setupBindings() {
        viewModel.categoriesObservable?
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] products in
                self?.products = products
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    @IBAction func filter(_ sender: Any) {
        isFilterHidden = !isFilterHidden
        UIView.animate(withDuration: 0.5) {
            self.subCategoriesView.isHidden = self.isFilterHidden
            
            self.topconstrensinCollectionView.constant = self.isFilterHidden ? 8 : (self.subCategoriesView.frame.height + 16)
            self.view.layoutIfNeeded()
        }
        
    }
    
  

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        viewModel.clearFilter()  // Clear any previous filters
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.getAllProducts()
        case 1:
            viewModel.getCategoryProducts(categoryId: K.CategoryID.MEN)
        case 2:
            viewModel.getCategoryProducts(categoryId: K.CategoryID.WOMEN)
        case 3:
            viewModel.getCategoryProducts(categoryId: K.CategoryID.SALE)
        case 4:
            viewModel.getCategoryProducts(categoryId: K.CategoryID.KID)
        default:
            viewModel.getAllProducts()
        }
    }
    @IBAction func SubCategoriesBtn(_ sender: Any) {
        switch subCategoriesView.selectedSegmentIndex {
        case 0:
            self.viewModel.filterProductsArray(productType: "T-SHIRTS")
        case 1:
            self.viewModel.filterProductsArray(productType: "SHOES")
        case 2:
            self.viewModel.filterProductsArray(productType: "ACCESSORIES")
        default:
            self.viewModel.filterProductsArray(productType: "T-SHIRTS")
        }
    }

    @IBAction func favBtn(_ sender: Any) {
        coordinator?.goToFav()
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getProductsCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionCell
        
        let product = viewModel.getProducts()[indexPath.item]
        if let imageUrl = URL(string: viewModel.getProducts()[indexPath.row].image.src) {
            cell.img.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "9"))
        }
        cell.ProductName.text = product.title
        cell.price.text = product.variants[0].price
        
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize / 2, height: ( collectionViewSize / 2))
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedProduct = viewModel.getProducts()[indexPath.row]
        coordinator?.goToProductInfo(product: selectedProduct)
        //print("Item Selected")
    }
}
