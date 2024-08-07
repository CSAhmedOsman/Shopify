//
//  ProductInfoVC.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//

import UIKit
import Cosmos
import RxSwift

class ProductInfoVC: UIViewController{
    
    weak var coordinator: AppCoordinator?
    var productInfoVM: ProductInfoVM!
    private let disposeBag = DisposeBag()
    let favCRUD = FavCRUD()
    var id: Int = 0
    let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
    let cartVM = CartViewModel(network: NetworkManager.shared)
    var customIndicator: CustomIndicator?

    @IBOutlet weak var productImageCollectionView: UICollectionView!
    @IBOutlet weak var productReviesCollectionView: UICollectionView!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel! // e.g "820.25 EGP"
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var cosmos: CosmosView!
    @IBOutlet weak var addToFavBtn: UIButton!
    @IBOutlet weak var setColorOT: UIButton!
    @IBOutlet weak var setSizeOT: UIButton!
    
    var isFavorited = false
    private var productVariants: [ShopifyProductVariant] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProductImageCollectionView()
        setupProductReviesCollectionView()
        
        customIndicator = CustomIndicator(containerView: self.view)

        productInfoVM.productObservable
                    .subscribe(onNext: { [weak self] product in
                        self?.updateProductDetails(product)
                        self?.productVariants = product.variants ?? []
                        self?.customIndicator?.stop()
                    }, onError: { [weak self] error in
                        self?.customIndicator?.stop()
                    })
                    .disposed(by: disposeBag)
        
        productInfoVM.colorsObservable
            .subscribe(onNext: { [weak self] colors in
                self?.setupMenuButton(options: colors, for: self?.setColorOT ?? UIButton(), isColor: true)
            })
            .disposed(by: disposeBag)

                productInfoVM.sizesObservable
                    .subscribe(onNext: { [weak self] sizes in
                        self?.setupMenuButton(options: sizes, for: self?.setSizeOT ?? UIButton())
                    })
                    .disposed(by: disposeBag)
        
        customIndicator?.start()

        productInfoVM.fetchProduct(with: id)
        
        cosmos.rating = getRandomRating()
        setButtonImage(isFavorited: isFavorited)
        
        cartVM.getCartProductsList(completion: {_ in})
    }
    
    private func setupMenuButton(options: [String], for button: UIButton, isColor: Bool = false) {
        print("Setting up menu for button: \(button.titleLabel?.text ?? "Unknown")")
        let menuItems = options.map { option in
            UIAction(title: option) { [weak self] _ in
                button.setTitle(option, for: .normal)
                if isColor, let color = self?.productInfoVM.colorsDictionary[option] {
                    button.tintColor = color
                    print("Updated button tint color to \(color) for option: \(option)")
                }
                if !isColor {
                    self?.printVariantId(for: option)
                }
            }
        }
        
        let menu = UIMenu(title: button.titleLabel?.text ?? "Options", children: menuItems)
        
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }

    private func printVariantId(for size: String) {
        if let selectedColor = setColorOT.title(for: .normal) {
            if let variant = productVariants.first(where: { $0.option1 == size && $0.option2 == selectedColor }) {
                print("Selected Variant ID: \(variant.id ?? 0)")
            }
        }
    }
    
    @IBAction func addToFavBtn(_ sender: UIButton) {
        guard let product = productInfoVM.getProduct() else { return }
        let itemId = product.id
        
        sender.isEnabled = false
        sender.configuration?.showsActivityIndicator = true
        
        if UserDefaultsHelper.shared.getUserData().email == nil {
            let okBtn = UIAlertAction(title: "OK", style: .default) { _ in
                sender.isEnabled = true
                sender.configuration?.showsActivityIndicator = false
            }
            Utils.showAlert(title: "Sorry :(",
                            message: "Please login to open this feature",
                            preferredStyle: .alert,
                            from: self, actions: [okBtn])
        }
        
        else{
            if isFavorited {
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                    self.favCRUD.deleteItem(favId: self.favId!, itemId: itemId ?? 0) { success in
                        DispatchQueue.main.async {
                            sender.isEnabled = true
                            sender.configuration?.showsActivityIndicator = false
                            
                            if success {
                                self.setButtonImage(isFavorited: false)
                                self.isFavorited = false
                            } else {
                                // TODO: Handle save failure
                            }
                        }
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    sender.isEnabled = true
                    sender.configuration?.showsActivityIndicator = false
                }
                
                Utils.showAlert(title: "Confirm Deletion", message: "Are you sure you want to remove this item from favorites?", preferredStyle: .alert, from: self, actions: [deleteAction, cancelAction])
            } else {
                // Not favorited, so add it
                let itemImg = product.images?.first?.src ?? ""
                let itemName = product.title
                let itemPrice = Double(product.variants?.first?.price ?? "0.0") ?? 0.0
                
                favCRUD.saveItem(favId: favId!, itemId: itemId!, itemImg: itemImg, itemName: itemName!, itemPrice: itemPrice) { success in
                    DispatchQueue.main.async {
                        sender.isEnabled = true
                        sender.configuration?.showsActivityIndicator = false
                        
                        if success {
                            self.setButtonImage(isFavorited: true)
                            self.isFavorited = true
                        } else {
                            // TODO: Handle save failure
                        }
                    }
                }
            }
        }
    }

    @IBAction func addToCartBtn(_ sender: UIButton) {
        sender.isEnabled = false
        sender.configuration?.showsActivityIndicator = true
        
        guard let product = productInfoVM.getProduct() else {
            Utils.showAlert(title: "Check Internet Connection", message: "Sorry, you can't add this product to your cart.", preferredStyle: .alert, from: self)
            sender.isEnabled = true
            sender.configuration?.showsActivityIndicator = false
            return
        }
        
        if UserDefaultsHelper.shared.getUserData().email == nil {
            Utils.showAlert(title: "Sorry :(", message: "Please login to open this feature", preferredStyle: .alert, from: self)
        } else {
            let okBtn = UIAlertAction(title: "OK", style: .default) { _ in
                sender.isEnabled = true
                sender.configuration?.showsActivityIndicator = false
            }
            
            cartVM.productSoldOut = {
                Utils.showAlert(title: "Sold Out", message: "Sorry, you can't add this product to your cart.", preferredStyle: .alert, from: self, actions: [okBtn])
            }
            
            cartVM.productAlreadyExist = {
                Utils.showAlert(title: "Already Exist", message: "Go to your cart to update the quantity.", preferredStyle: .alert, from: self, actions: [okBtn])
            }
            
            cartVM.bindDoneOperation = {
                Utils.showAlert(title: "Successfully Added", message: "", preferredStyle: .alert, from: self, actions: [okBtn])
            }
            
            cartVM.bindErrorOperation = {
                Utils.showAlert(title: "Error", message: "Sorry, you can't add this product to your cart.", preferredStyle: .alert, from: self, actions: [okBtn])
            }
            
            guard let selectedSize = setSizeOT.title(for: .normal),
                  let selectedColor = setColorOT.title(for: .normal),
                  let variantId = getSelectedVariantId(for: selectedSize, color: selectedColor)
            else {
                Utils.showAlert(title: "Variant Not Found", message: "Please select a variant.", preferredStyle: .alert, from: self, actions: [okBtn])
                return
            }
            
            cartVM.addNewItemLine(variantID: variantId, quantity: 1, imageURLString: product.images?.first?.src ?? "", productID: 0, productTitle: product.title ?? "No title", productPrice: product.variants?.first?.price ?? "")
        }
    }

    private func getSelectedVariantId(for size: String, color: String) -> Int? {
        guard let variants = productInfoVM.getProduct()?.variants else { return nil }
        
        return variants.first { $0.option1 == size && $0.option2 == color }?.id
    }

    
    @IBAction func btnBack(_ sender: Any) {
        coordinator?.finish()
    }
    
    @IBAction func selectColorBtn(_ sender: Any) {
    }
    
    @IBAction func selectSizeBtn(_ sender: Any) {
    }
    
    // helper Methods
    
    func setupProductImageCollectionView() {
        productImageCollectionView.dataSource = self
        productImageCollectionView.delegate = self
        
        let productImageNib = UINib(nibName: "productImgCellCollectionViewCell", bundle: nil)
        productImageCollectionView.register(productImageNib, forCellWithReuseIdentifier: "productImgCellCollectionViewCell")
        
        if let layout = productImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: productImageCollectionView.frame.width, height: productImageCollectionView.frame.height)
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            layout.scrollDirection = .horizontal
        }
    }
    
    func setupProductReviesCollectionView() {
        productReviesCollectionView.dataSource = self
        productReviesCollectionView.delegate = self
        
        let productReviewNib = UINib(nibName: "productReviewCell", bundle: nil)
        productReviesCollectionView.register(productReviewNib, forCellWithReuseIdentifier: "productReviewCell")
        
        if let reviewLayout = productReviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            reviewLayout.itemSize = CGSize(width: productReviesCollectionView.frame.width - 48, height: 85)
            reviewLayout.minimumLineSpacing = 8
            reviewLayout.minimumInteritemSpacing = 0
            reviewLayout.scrollDirection = .horizontal
        }
        
        pageControl.numberOfPages = 10
        pageControl.currentPage = 0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == productImageCollectionView {
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = Int(pageIndex)
        }
    }

    func updateProductDetails(_ product: ShopifyProduct) {
        //print("Updating UI with product details:", product)
        productName.text = product.title
        productPrice.text = "\(product.variants?.first?.price ?? "90.00")".formatAsCurrency()
        productDescription.text = product.body_html
        pageControl.numberOfPages = product.images?.count ?? 0

        productImageCollectionView.reloadData()
    }


    func getRandomRating() -> Double {
        let randomRating = Double.random(in: 3.0...5.0)
        return (randomRating * 10).rounded() / 10.0
    }

    func setButtonImage(isFavorited: Bool) {
        let imageName = isFavorited ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        addToFavBtn.setImage(image, for: .normal)
    }

}

// MARK: Extension

extension ProductInfoVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productImageCollectionView {
            return productInfoVM.getProduct()?.images?.count ?? 0
        } else if collectionView == productReviesCollectionView {
            return 25
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productImageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImgCellCollectionViewCell", for: indexPath) as! productImgCellCollectionViewCell
            
            if let product = productInfoVM.getProduct() {
                let imageURLString = product.images?[indexPath.item].src
                if let url = URL(string: imageURLString!) {
                    cell.configure(with: url)
                }
            }
            
            return cell
        } else if collectionView == productReviesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productReviewCell", for: indexPath) as! productReviewCell
            
            let randomIndex = Int.random(in: 0..<dummyReviews.count)
            let review = dummyReviews[randomIndex]
            
            let randomReviewerName = reviewers.randomElement() ?? "Anas"
            let randomReview = Review(reviewerName: randomReviewerName, reviewDescription: review.reviewDescription, reviewRating: review.reviewRating)
            
            cell.configure(with: randomReview)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = productInfoVM.getProduct() else { return }
        
        let imageURLs = product.images?.compactMap { URL(string: $0.src ?? "") } ?? []
        let selectedImageURL = imageURLs[indexPath.item]
        
        coordinator?.goToImageZoom(imageURLs: imageURLs, selectedImageURL: selectedImageURL)
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

