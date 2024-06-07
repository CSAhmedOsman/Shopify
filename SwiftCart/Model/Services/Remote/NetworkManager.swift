//
//  NetworkManager.swift
//  SwiftCart
//
//  Created by Elham on 02/06/2024.
//



import Foundation
import Alamofire
import RxSwift
import RxAlamofire

protocol Networking{
    func getApiData(url: String) -> Observable<Data>
    
}

class NetworkManager : Networking {
    static let shared = NetworkManager()
    
    private init() {}
    
    func getApiData(url: String) -> Observable<Data> {
        print("NetworkManager: Preparing to request data from URL: \(url)")
        
        return RxAlamofire.data(.get, url)
            .flatMap { data -> Observable<Data> in
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("NetworkManager: Response Data: \(jsonString)")
                } else {
                    print("NetworkManager: Response Data: unable to convert to string")
                }
                return Observable.just(data)
            }
    }
}

