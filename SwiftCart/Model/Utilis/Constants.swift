//
//  Constants.swift
//  SwiftCart
//
//  Created by Anas Salah on 07/06/2024.
//

import Foundation

// MARK: This for all string in project pleas dont user strings in project

public enum K {
    
    enum Auth {
        static let SginUp_Nib_Name = "SginUp"
        static let Login_Nib_Name = "Login"
    }
    
    enum Home {
        static let Home_Storyboard_Name = "HomeStoryboard"
        static let Home_View_Name = "HomeViewController"
        static let Category_View_Name = "CategoryViewController"
        static let Product_View_Name = "ProductViewController"
        
        
    }
    
    enum Settings {
        static let Settings_Storyboard_Name = "SettingsStoryboard"
        static let Settings_View_Name = "SettingsViewController"
        static let Addresses_View_Name = "AddressesViewController"
        static let Address_Details_View_Name = "AddressDetailsViewController"
        static let Contact_Us_View_Name = "ContactUsViewController"
        static let Cart_View_Name = "CartViewController"
        static let Profile_View_Name = "ProfileViewController"
        static let Currency_View_Name = "CurrencyViewController"
        static let Order_View_Name = "OrderViewController"
        static let OrderDetails_View_Name = "OrderDetailsViewController"
    }
    
    enum Shopify {
        static let Shopify_API_Key = "236f00d0acd3538f6713fd3a323150b6"
        static let Shopify_API_Secret = "f7e30cfe8bb4caedc97901323c1a2d67"
        static let Shopify_Shop_Name = "mad44-sv-iost1"
        static let Access_Token = "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"
        static let Base_URL = "https://mad44-sv-iost1.myshopify.com/admin/api/2024-04/"
        static var userID =  UserDefaultsHelper.shared.getUserData().shopifyCustomerID ?? "6930899632175"

    }
    
    enum HTTPMethod {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
    }
    
    enum CategoryID {
        static let ALL = 0
        static let MEN = 287822315567
        static let WOMEN = 287822348335
        static let KID = 287822381103
        static let SALE = 287822413871
    }
    
    enum endPoints : String{
        case getOrPostAddress = "/customers/{customer_id}/addresses.json"
        case putOrDeleteAddress = "/customers/{customer_id}/addresses/{address_id}.json"
        case defaultAddress = "/customers/{customer_id}/addresses/{address_id}/default.json"
        case draftOrders = "/draft_orders/{draft_orders_id}.json"
        case variants = "/variants/{variant_id}.json"
        
    }
    
    enum Currency : String{
        case baseURL = "https://api.currencyapi.com/v3/latest"
        case endPoint = "base_currency={base_currency}&currencies[]={currencies}"
        case ApiKey = "cur_live_ucypaSmXyj5YoUkYSZLwVz6wXgb4Z0IIPmV0W33o"
        case egp = "EGP"
        case USD = "USD"
        case SAR = "SAR"
    }
    
    enum customRadioButton : String {
        case filled = "circle.inset.filled"
        case unFilled = "circle"
    }
    
    //MARK: Add any Const ants u need in a staruct pleas
}
