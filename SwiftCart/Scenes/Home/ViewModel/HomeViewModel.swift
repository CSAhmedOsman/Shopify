//
//  ViewModel.swift
//  SwiftCart
//
//  Created by Elham on 02/06/2024.
//


import Foundation
import RxSwift

class HomeViewModel {
    private let brandsSubject = PublishSubject<[Brand]>()
    var brandsObservable: Observable<[Brand]> {
        return brandsSubject.asObservable()
    }
    
    private var brandsArray: [Brand] = []
    private let network: Networking
    private let disposeBag = DisposeBag()
    
    private let url = "https://236f00d0acd3538f6713fd3a323150b6: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@mad44-sv-iost1.myshopify.com/admin/api/2024-04/smart_collections.json"
    
    init(network: Networking) {
        self.network = network
    }
    
    func loadData() {
        network.getApiData(url: url)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                print("ViewModel: Received brand response")
                if let brandResponse: BrandResponse = Utils.convertTo(from: data) {
                    self?.brandsArray = brandResponse.brands ?? []
                    self?.brandsSubject.onNext(self?.brandsArray ?? [])
                    print("ViewModel: Number of brands: \(self?.brandsArray.count ?? 0) image :: \(self?.brandsArray.first?.image?.src ?? "")")
                } else {
                    print("loadData else")
                }
            }, onError: { error in
                print("ViewModel: API Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func getBrands() -> [Brand] {
        return brandsArray
    }
    
    func getBrandsCount() -> Int {
        return brandsArray.count
    }
}
