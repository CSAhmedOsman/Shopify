//
//  ProductViewController.swift
//  SwiftCart
//
//  Created by Elham on 03/06/2024.
//

import UIKit
import RxSwift

class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var sliderPrice: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var subCategoriesView: UISegmentedControl!
    
    @IBOutlet weak var topconstrensinCollectionView: NSLayoutConstraint!
    var isFilterHidden = true
    
    weak var coordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    private var products: [Product] = []
    var brandID: Int?
    var viewModel = CategoryViewModel(network: NetworkManager.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderPrice.isHidden = isFilterHidden
        subCategoriesView.isHidden = isFilterHidden
        topconstrensinCollectionView.constant = 8
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: "ProductCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        
        setupBindings()
        setUpPriceFilter()
        if let brandID = brandID {
            viewModel.getCategoryProducts(categoryId: brandID)
        }
    }
    
    func setUpPriceFilter() {
        sliderPrice.rx.value
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                DispatchQueue.global().async {
                    self.viewModel.filterProducts(price: value)
                }
            })
            .disposed(by: disposeBag)
    }

    
    func setupBindings() {
        viewModel.categoriesObservable?
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] products in
                self?.products = products
                self?.updateSliderRange()
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }


    func updateSliderRange() {
        let prices = products.compactMap { Float($0.variants[0].price) }
        if let minPrice = prices.min(), let maxPrice = prices.max() {
            sliderPrice.minimumValue = minPrice - 30
            sliderPrice.maximumValue = maxPrice + 30
            sliderPrice.value = maxPrice
        }
    }

   @IBAction func filter(_ sender: Any) {
        isFilterHidden = !isFilterHidden
        UIView.animate(withDuration: 0.5) {
            self.subCategoriesView.isHidden = self.isFilterHidden
            self.sliderPrice.isHidden = self.isFilterHidden
            self.topconstrensinCollectionView.constant = self.isFilterHidden ? 8 : (self.subCategoriesView.frame.height + self.sliderPrice.frame.height + 16)
            self.view.layoutIfNeeded()
        }
        
    }
    @IBAction func SubCategoriesBtn(_ sender: Any) {
        switch subCategoriesView.selectedSegmentIndex {
        case 0:
            viewModel.getCategoryProducts(categoryId: brandID ?? 0)
        case 1:
            self.viewModel.filterProductsArray(productType: "SHOES")
        case 2:
            self.viewModel.filterProductsArray(productType: "ACCESSORIES")
        case 3:
            self.viewModel.filterProductsArray(productType: "T-SHIRTS")
        default:
            viewModel.getCategoryProducts(categoryId: brandID ?? 0)
        }
    }
    
    @IBAction func favBtn(_ sender: Any) {
        coordinator?.goToFav()
    }
    
    @IBAction func backTToHome(_ sender: Any) {
        coordinator?.finish()
    }
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionCell
        let product = products[indexPath.item]
        if let imageUrl = URL(string: product.image.src) {
            cell.img.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "9"))
        }
        cell.ProductName.text = product.title
        cell.price.text = product.variants[0].price
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedProduct = viewModel.getProducts()[indexPath.row]
        coordinator?.goToProductInfo(product: selectedProduct)
        //print("Item Selected")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize / 2, height: ( collectionViewSize / 2))
    }
}
