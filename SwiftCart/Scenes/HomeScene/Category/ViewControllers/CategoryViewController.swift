//
//  CategoryViewController.swift
//  SwiftCart
//
//  Created by Elham on 03/06/2024.
//

import UIKit
import RxSwift

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     var testViewModel = OrderViewModel()
    
    @IBOutlet weak var categoriesSegmented: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var subCategoriesView: UISegmentedControl!
    
    @IBOutlet weak var topconstrensinCollectionView: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isFilterHidden = true
    let favCRUD = FavCRUD()
    
    weak var coordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    private var products: [Product] = []
    private var favoriteProductIDs: Set<Int> = [] // TODO: s

    var viewModel = CategoryViewModel(network: NetworkManager.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print("viewDidLoad ======================= CategoryViewController")
        subCategoriesView.isHidden = isFilterHidden
        topconstrensinCollectionView.constant = 8
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "ProductCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        
        testViewModel.bindOrder = {
            self.coordinator?.finish()
        }
        
        setupBindings()
        viewModel.getAllProducts()
        fetchFavoriteItems()
        setupSearchBar()
    }
 
    private func fetchFavoriteItems() {
        let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0") ?? 0
        favCRUD.readItems(favId: favId) { [weak self] lineItems in
            DispatchQueue.main.async {
                self?.favoriteProductIDs = Set(lineItems.compactMap { $0.id })
                self?.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func filter(_ sender: Any) {
        let address = Address(
            id: nil,
            customerID: nil,
            firstName: "John",
            lastName: "Doe",
            address1: "123 Main St",
            city: "Cairo",
            country: "EG",
            phone: "011123456789",
            isDefault: true
        )

        let billingAddress = Address(
            id: nil,
            customerID: nil,
            firstName: "John",
            lastName: "Doe",
            address1: "123 Main St",
            city: "Cairo",
            country: "EG",
            phone: "011123456789",
            isDefault: true
        )

        let testOrder = Order(
            id: 1073460025,
            orderNumber: "#122",
            productNumber: 2,
            address: address,
           // phone: "011123456789",
            date: "2024-05-14T21:19:37-04:00",
            currency: .eur,
            email: UserDefaults.standard.string(forKey: "userEmail") ?? "",
            totalPrice: "238.47",
            items: [
                ItemProductOrder(id: 1071823276, image: "https://cdn.shopify.com/s/files/1/0624/0239/6207/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1716812402", price: "80", quantity: 3, title: "Big Brown Bear Boots"),
                ItemProductOrder(id: 1081823276, image: "https://cdn.shopify.com/s/files/1/0624/0239/6207/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1716812402", price: "50", quantity: 1, title: " Brown Bear Boots")
            ],
            userID: Int(K.Shopify.userID),
            billingAddress: billingAddress,
            customer: UserDefaultsHelper.shared.printUserDefaults()
        )

        testViewModel.addNewOrder(newOrder: testOrder)

        
        isFilterHidden = !isFilterHidden
        UIView.animate(withDuration: 0.5) {
            self.subCategoriesView.isHidden = self.isFilterHidden
            
            self.topconstrensinCollectionView.constant = self.isFilterHidden ? 8 : (self.subCategoriesView.frame.height + 16)
            self.view.layoutIfNeeded()
        }
        
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
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getProductsCount()
    }

    @IBAction func goToFav(_ sender: Any) {
        coordinator?.goToFav()
    }
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionCell
        
        let product = viewModel.getProducts()[indexPath.item]
        if let imageUrl = URL(string: viewModel.getProducts()[indexPath.row].image.src) {
            cell.img.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "9"))
        }
        cell.ProductName.text = product.title
        cell.price.text = product.variants[0].price.formatAsCurrency()
        cell.isCellNowCategorie = true
        cell.indexPath = indexPath
        cell.delegate = self
        
        cell.isFavorited = favoriteProductIDs.contains(product.id)
        cell.setButtonImage(isFavorited: cell.isFavorited)
        
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
        let isFavorited = favoriteProductIDs.contains(selectedProduct.id)

        coordinator?.goToProductInfo(productId: selectedProduct.id, isFav: isFavorited)
        //print("Item Selected")
    }
}

extension CategoryViewController: ProductCollectionCellDelegate {
    func saveToFavorite(foe cell: ProductCollectionCell) {
        guard let indexPath = cell.indexPath else {
            print("No index path found for cell")
            return
        }
        
        let product = products[indexPath.item]
        let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
        favCRUD.saveItem(favId: favId!, itemId: product.id, itemImg: product.image.src, itemName: product.title, itemPrice: Double(product.variants[0].price) ?? 70.0)
        print("save to favorite for product id: \(product.id)")

    }
    

    func deleteFavoriteTapped(for cell: ProductCollectionCell) {
        guard let indexPath = cell.indexPath else {
            print("No index path found for cell")
            return
        }
        
        let product = products[indexPath.item]
        let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
        favCRUD.deleteItem(favId: favId!, itemId: product.id)
        
//        products.remove(at: indexPath.item)
//        collectionView.reloadData()
        
       // print("Deleted favorite for product id: \(product.id)")
    }
}

extension CategoryViewController: UISearchBarDelegate {
    
    func setupSearchBar() {
        searchBar.delegate = self
        bindSearchBar()
    }
    
    private func bindSearchBar() {
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.searchProducts(query: query)
            })
            .disposed(by: disposeBag)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchProducts(query: searchText)
    }
}
