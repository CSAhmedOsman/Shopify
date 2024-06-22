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
                  //  print("NetworkManager: Response Data: \(jsonString)")
                } else {
                    print("NetworkManager: Response Data: unable to convert to string")
                }
                return Observable.just(data)
            }
    }
    
    
     func createRequestDetails(url : String ,endpoint: String, headers: HTTPHeaders?) -> (String, HTTPHeaders) {
        let url = "\(K.Shopify.Base_URL)\(endpoint)"
        var combinedHeaders = headers ?? HTTPHeaders()
        combinedHeaders.add(name: "X-Shopify-Access-Token", value: K.Shopify.Access_Token)
        combinedHeaders.add(name: "Content", value: "application/json")
        return (url, combinedHeaders)
    }

    func get<T: Decodable>(url: String = K.Shopify.Base_URL, endpoint: String, parameters: [String: Any]? = nil, headers: HTTPHeaders? = nil) -> Observable<T> {
        let (url, combinedHeaders) = createRequestDetails(url: url, endpoint: endpoint, headers: headers)

        return RxAlamofire
            .requestData(.get, url, parameters: parameters, encoding: URLEncoding.default, headers: combinedHeaders)
            .flatMap { response, data -> Observable<T> in
                if let decodedObject: T = Utils.convertTo(from: data) {
                    return Observable.just(decodedObject)
                } else {
                    return Observable.error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Decoding error"]))
                }
            }
    }
    
    func delete(url: String = K.Shopify.Base_URL, endpoint: String, parameters: [String: Any]? = nil, headers: HTTPHeaders? = nil) -> Observable<Int> {
        let (completeURL, combinedHeaders) = createRequestDetails(url: url, endpoint: endpoint, headers: headers)

        return Observable.create { observer in
            let disposable = RxAlamofire.requestData(.delete, completeURL, parameters: parameters, encoding: URLEncoding.default, headers: combinedHeaders)
                .subscribe(onNext: { (response, _) in
                    observer.onNext(response.statusCode)
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                })

            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    func post<T: Encodable, U: Decodable>(url: String = K.Shopify.Base_URL, endpoint: String, body: T, headers: HTTPHeaders? = nil, responseType: U.Type) -> Observable<(Bool, String?, U?)> {
            let (completeURL, combinedHeaders) = createRequestDetails(url: url, endpoint: endpoint, headers: headers)
            print(completeURL)
            return RxAlamofire
                .requestData(.post, completeURL, parameters: body.dictionary, encoding: JSONEncoding.default, headers: combinedHeaders)
                .flatMap { response, data -> Observable<(Bool, String?, U?)> in
                    let statusCode = response.statusCode
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        
                        let responseObject = try decoder.decode(U.self, from: data)
                        if (201...299).contains(statusCode) {
                            return Observable.just((true, "Succeeded", responseObject))
                        } else {
                            return Observable.just((false, "Request failed with status code: \(statusCode)", nil))
                        }
                    } catch {
                        return Observable.just((false, "Decoding error: \(error.localizedDescription)", nil))
                    }
                }
                .catchError { error in
                    Observable.just((false, "Request error: \(error.localizedDescription)", nil))
                }
        }
    
    func postOrder(url: String, endpoint: String, body: [String: Any]) -> Observable<(Bool, String?, OrderResponse?)> {
            let completeURL = url + endpoint
            let credentials = "236f00d0acd3538f6713fd3a323150b6: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"
            let base64Credentials = Data(credentials.utf8).base64EncodedString()
            let headers: HTTPHeaders = [ 

                "Content-Type": "application/json",
                "Authorization": "Basic \(base64Credentials)"
            ]

            return RxAlamofire
                .requestData(.post, completeURL, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .debug()  // Add debug to log request and response
                .flatMap { response, data -> Observable<(Bool, String?, OrderResponse?)> in
                    let statusCode = response.statusCode
                    let responseString = String(data: data, encoding: .utf8) ?? "No response body"
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        let responseObject = try decoder.decode(OrderResponse.self, from: data)
                        if (201...299).contains(statusCode) {
                            return Observable.just((true, "Succeeded", responseObject))
                        } else {
                            return Observable.just((false, "Request failed with status code: \(statusCode), response: \(responseString)", nil))
                        }
                    } catch {
                        return Observable.just((false, "Decoding error: \(error.localizedDescription), response: \(responseString)", nil))
                    }
                }
                .catchError { error in
                    Observable.just((false, "Request error: \(error.localizedDescription)", nil))
                }
        }
    
func put<T: Encodable, U: Decodable>(url: String = K.Shopify.Base_URL, endpoint: String, body: T, headers: HTTPHeaders? = nil, responseType: U.Type) -> Observable<(Bool, String?, U?)> {
            let (completeURL, combinedHeaders) = createRequestDetails(url: url, endpoint: endpoint, headers: headers)
            print(completeURL)
            return RxAlamofire
                .requestData(.put, completeURL, parameters: body.dictionary, encoding: JSONEncoding.default, headers: combinedHeaders)
                .flatMap { response, data -> Observable<(Bool, String?, U?)> in
                    let statusCode = response.statusCode
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        let responseObject = try decoder.decode(U.self, from: data)
                        if (201...299).contains(statusCode) {
                            return Observable.just((true, "Succeeded", responseObject))
                        } else {
                            return Observable.just((false, "Request failed with status code: \(statusCode)", nil))
                        }
                    } catch {
                        return Observable.just((false, "Decoding error: \(error.localizedDescription)", nil))
                    }
                }
                .catchError { error in
                    Observable.just((false, "Request error: \(error.localizedDescription)", nil))
                }
        }
    }



extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
