//
//  CategoryViewController.swift
//  SwiftCart
//
//  Created by Elham on 03/06/2024.
//

import UIKit
import RxSwift

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var subCategoriesBtn: NSLayoutConstraint!
    @IBOutlet weak var categoriesSegmented: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!

    weak var coordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    private var products: [Product] = []
    var viewModel = CategoryViewModel(network: NetworkManager.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
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

    @IBAction func subCategoriesBtnTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Subcategory", message: nil, preferredStyle: .actionSheet)

        let subcategories = ["T-SHIRT", "SHOES"]
        for subcategory in subcategories {
            alert.addAction(UIAlertAction(title: subcategory, style: .default, handler: { [weak self] _ in
                self?.viewModel.filterProductsArray(productType: subcategory)
                self?.collectionView.reloadData()
            }))
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getProductsCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        let product = viewModel.getProducts()[indexPath.item]
        if let imageUrl = URL(string: viewModel.getProducts()[indexPath.row].image.src) {
            cell.img.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "9"))
        }
        cell.categoryName.text = product.vendor
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize / 2, height: (self.view.frame.width * 0.46))
    }
}
