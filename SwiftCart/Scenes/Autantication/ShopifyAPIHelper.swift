//
//  ShopifyAPIHelper.swift
//  SwiftCart
//
//  Created by Anas Salah on 09/06/2024.
//

import Foundation
import Alamofire

struct ShopifyAPIHelper {
    
    static let shared = ShopifyAPIHelper()
    
    private init() {}
    
    private func createHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": K.Shopify.Access_Token
        ]
        return headers
    }
    
    func createCustomer(email: String, firstName: String, lastName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let path = "customers.json"
        let url = K.Shopify.Base_URL + path
        
        let customerData: [String: Any] = [
            "customer": [
                "email": email,
                "first_name": firstName,
                "last_name": lastName
            ]
        ]
        
        AF.request(url, method: .post, parameters: customerData, encoding: JSONEncoding.default, headers: createHeaders())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CustomerResponse.self) { response in
                switch response.result {
                case .success(let customerResponse):
                    let customerId = customerResponse.customer.id
                    print("Customer created with ID: \(customerId)")
                    completion(.success("Customer created with ID: \(customerId)"))
                case .failure(let error):
                    print("Error creating customer: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    func createDraftOrder(customerId: String, lineItems: [[String: Any]], completion: @escaping (Result<Int, Error>) -> Void) {
        let path = "draft_orders.json"
        let url = K.Shopify.Base_URL + path
        
        let draftOrderData: [String: Any] = [
            "draft_order": [
                "customer": ["id": Int(customerId)],
                "line_items": lineItems,
                "use_customer_default_address": true
            ]
        ]
        
        print("Creating draft order with data:")
        print(draftOrderData)
        
        AF.request(url, method: .post, parameters: draftOrderData, encoding: JSONEncoding.default, headers: createHeaders())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DraftOrderResponse.self) { response in
                switch response.result {
                case .success(let draftOrderResponse):
                    let draftOrderId = draftOrderResponse.draftOrder.id
                    print("Draft order created with ID: \(draftOrderId)")
                    completion(.success(draftOrderId))
                case .failure(let error):
                    print("Error creating draft order: \(error.localizedDescription)")
                    if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response data: \(responseString)")
                    }
                    completion(.failure(error))
                }
            }
    }

}

// Define the structure for the DraftOrderResponse
struct DraftOrderResponse: Decodable {
    let draftOrder: DraftOrder
    
    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct DraftOrder: Decodable {
    let id: Int
    let name: String
    let status: String
}

// Define the structure for the CustomerResponse.
struct CustomerResponse: Codable {
    let customer: Customer
}

struct Customer: Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
