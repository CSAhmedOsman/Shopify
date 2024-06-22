//  Order.swift
//  SwiftCart
//
//  Created by Elham on 20/06/2024.
//

import Foundation

// Struct for handling order response
struct OrdersResponse: Codable {
    var orders: [Order]
}
struct OrderResponse: Codable {
    var order: Order
}


// MARK: - Order
struct Order: Codable {
    var id:Int64
    var orderNumber: String?
    var productNumber: Int?
    var address: Address?
   // var phone: String?
    var date: String
    var currency: MyCurrency
    var email: String
    var totalPrice: String
    var items: [ItemProductOrder]
    var userID: Int?
    var billingAddress: Address?
    var customer: Customer?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber = "name"
        case productNumber = "number"
        case address = "shipping_address"
        //case phone
        case date = "created_at"
        case currency
        case email
        case totalPrice = "total_price"
        case items = "line_items"
        case userID = "user_id"
        case billingAddress = "billing_address"
        case customer
    }
}

enum MyCurrency: String, Codable {
    case eur = "EUR"
}

// MARK: - LineItem
struct ItemProductOrder: Codable {
    var id: Int
    var image: String?
    var price: String
    var quantity: Int
    var title: String

    enum CodingKeys: String, CodingKey {
        case id
        case image = "sku"
        case price
        case quantity
        case title
    }
}


