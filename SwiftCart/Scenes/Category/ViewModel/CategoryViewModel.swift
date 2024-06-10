//
//  CategoryViewModel.swift
//  SwiftCart
//
//  Created by Elham on 07/06/2024.
//

import Foundation
import RxSwift

class CategoryViewModel {
    private let categoriesSubject = PublishSubject<[Product]>()
    var categoriesObservable: Observable<[Product]>? {
        return categoriesSubject.asObservable()
    }

    private var productsArray: [Product] = []
    private var filteredProductsArray: [Product] = []
    
    var isFiltering = false
    private let network: Networking
    private let disposeBag = DisposeBag()

    init(network: Networking) {
        self.network = network
    }

    func getAllProducts() {
        let url = "https://236f00d0acd3538f6713fd3a323150b6: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@mad44-sv-iost1.myshopify.com/admin/api/2024-04/products.json"

        network.getApiData(url: url)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                print("ViewModel: Received ALL Products response !!!!")
                if let productsResponse: ProductsResponse = Utils.convertTo(from: data) {
                    self?.productsArray = productsResponse.products ?? []
                    self?.categoriesSubject.onNext(self?.productsArray ?? [])
                    print("ViewModel: Number of products: \(self?.productsArray.count ?? 0) image :: \(self?.productsArray.first?.image.src ?? "")")
                } else {
                    print("loadData else")
                }
            }, onError: { error in
                print("ViewModel: API Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    func getCategoryProducts(categoryId: Int) {
        let url = "https://236f00d0acd3538f6713fd3a323150b6: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@mad44-sv-iost1.myshopify.com/admin/api/2024-04/products.json?collection_id=\(categoryId)"

        network.getApiData(url: url)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                print("ViewModel: Received Category Products response")
                if let productsResponse: ProductsResponse = Utils.convertTo(from: data) {
                    self?.productsArray = productsResponse.products ?? []
                    self?.categoriesSubject.onNext(self?.productsArray ?? [])
                    print("ViewModel: Number of products: \(self?.productsArray.count ?? 0) image :: \(self?.productsArray.first?.image.src ?? "")")
                } else {
                    print("loadData else")
                }
            }, onError: { error in
                print("ViewModel: API Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    func filterProductsArray(productType: String) {
        isFiltering = true
        filteredProductsArray = productsArray.filter {
            $0.productType.rawValue == productType
        }
        categoriesSubject.onNext(filteredProductsArray)
    }

    func getProductsCount() -> Int {
        return isFiltering ? filteredProductsArray.count : productsArray.count
    }

    func getProducts() -> [Product] {
        return isFiltering ? filteredProductsArray : productsArray
    }
    
    func clearFilter() {
        isFiltering = false
        categoriesSubject.onNext(productsArray)
    }
}
