//
//  OrderViewModel.swift
//  SwiftCart
//
//  Created by Elham on 20/06/2024.
//

import Foundation
import RxSwift

class OrderViewModel{
    
    private let ordersSubject = PublishSubject<[Order]>()
    var orderObservable: Observable<[Order]> {
        return ordersSubject.asObservable()
    }
    private let disposeBag = DisposeBag()
    var ordersList : [Order]?
    var bindOrder : (()-> Void) = {}
    
    func getOrders() -> [Order] {
        return ordersList ?? []
    }
    
    func getOrdersCount() -> Int {
        return ordersList?.count ?? 0
    }
    
    func getOrderByIndex(index:Int) ->  Order{
        return (ordersList?[index])!
    }
    
    func getOrdersList() {
        
        let customerID = K.Shopify.userID
        let endpoint = "orders.json?customer_id=\(customerID)"
        NetworkManager.shared.get(endpoint: endpoint)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (response: OrdersResponse) in
                self?.ordersList = response.orders
                self?.ordersSubject.onNext(self?.ordersList ?? [])
                self?.bindOrder()
                print("ViewModel: Number of orders: \(String(describing: self?.ordersList?.count))")
            }, onError: { (error: Error) in
                print("Error occurred: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        
        
    }
    
    
//    func addNewOrder(newOrder:OrderResponse){
//                let endpoint = "orders.json"
//                NetworkManager.shared.post(endpoint: endpoint, body: ["order": newOrder], responseType: OrderResponse.self)
//                    .observeOn(MainScheduler.instance)
//                    .subscribe(onNext: { (success, message, response) in
//                        if success {
//                            self.bindOrder()
//                            print("OrderViewModel: Number of Order: \(String(describing: response))")
//                        } else {
//                            print("Failed to post order: \(message ?? "No error message")")
//                            print(newOrder)
//                        }
//                    }, onError: { error in
//                        print("Error occurred: \(error.localizedDescription)")
//                    })
//                    .disposed(by: disposeBag)
//            }

    func addNewOrder(newOrder: Order) {
           let endpoint = "orders.json"  // Corrected endpoint path
           let url = "https://236f00d0acd3538f6713fd3a323150b6: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@mad44-sv-iost1.myshopify.com/admin/api/2024-04/"
        print(newOrder)
           do {
               let encoder = JSONEncoder()
               encoder.dateEncodingStrategy = .iso8601
               let orderData = try encoder.encode(newOrder)
               if let orderDict = try JSONSerialization.jsonObject(with: orderData, options: .mutableContainers) as? [String: Any] {
                   NetworkManager.shared.postOrder(url: url, endpoint: endpoint, body: ["order": orderDict])
                       .observeOn(MainScheduler.instance)
                       .subscribe(onNext: { (success, message, response) in
                           if success {
                               print("Order posted successfully: \(String(describing: response))")
                           } else {
                               print("Failed to post order: \(message ?? "No error message")")
                           }
                       }, onError: { error in
                           print("Error occurred: \(error.localizedDescription)")
                       })
                       .disposed(by: disposeBag)
               }
           } catch {
               print("Failed to encode order: \(error.localizedDescription)")
           }
       }
    
}
