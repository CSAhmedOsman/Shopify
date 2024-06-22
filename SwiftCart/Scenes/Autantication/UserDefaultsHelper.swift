//
//  UserDefaultsHelper.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//

import Foundation

struct UserDefaultsHelper {
    
    static let shared = UserDefaultsHelper()
    private init() {}
    
    func saveUserData(email: String, name: String, uid: String, shopifyCustomerID: String, cartID: String, favID: String) {
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(uid, forKey: "userUID")
        UserDefaults.standard.set(shopifyCustomerID, forKey: "shopifyCustomerID")
        UserDefaults.standard.set(cartID, forKey: "cartID")
        UserDefaults.standard.set(favID, forKey: "favID")
        
        UserDefaults.standard.synchronize()
    }
    
    func getUserData() -> (email: String?, name: String?, uid: String?, shopifyCustomerID: String?, cartID: String?, favID: String?) {
        let userEmail = UserDefaults.standard.string(forKey: "userEmail")
        let userName = UserDefaults.standard.string(forKey: "userName")
        let userUID = UserDefaults.standard.string(forKey: "userUID")
        let shopifyCustomerID = UserDefaults.standard.string(forKey: "shopifyCustomerID")
        let cartID = UserDefaults.standard.string(forKey: "cartID")
        let favID = UserDefaults.standard.string(forKey: "favID")
        
        return (userEmail, userName, userUID, shopifyCustomerID, cartID, favID)
    }
    
    func clearUserData() {
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userUID")
        UserDefaults.standard.removeObject(forKey: "shopifyCustomerID")
        UserDefaults.standard.removeObject(forKey: "cartID")
        UserDefaults.standard.removeObject(forKey: "favID")
        
        UserDefaults.standard.synchronize()
    }
    
    func printUserDefaults()->Customer {
        let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? "No Data"
        let userName = UserDefaults.standard.string(forKey: "userName") ?? "No Data"
        let userUID = UserDefaults.standard.string(forKey: "userUID") ?? "No Data"
        let shopifyCustomerID = UserDefaults.standard.string(forKey: "shopifyCustomerID") ?? "No Data"
       // let cartID = UserDefaults.standard.string(forKey: "cartID") ?? "No Data"
        //let favID = UserDefaults.standard.string(forKey: "favID") ?? "No Data"
        
        //print("UserDefaults - Email: \(userEmail), Name: \(userName), UID: \(userUID), ShopifyCustomerID: \(shopifyCustomerID), CartID: \(cartID), FavID: \(favID)")
        return Customer(id: Int(shopifyCustomerID) ?? 0, email: userEmail, firstName: userName, lastName: "")
    }

        private let userDefaults = UserDefaults.standard
        
        func saveCurrency(currencyType: String, value: Double) {
            userDefaults.set(value, forKey: currencyType.uppercased())
        }
        
        func getCurrencyValue(for currencyType: String) -> Double? {
            let value = userDefaults.double(forKey: currencyType.uppercased())
            return value != 0 ? value : 1.0
        }
        
        func getCurrencyType() -> String? {
            return userDefaults.string(forKey: "selectedCurrencyType")
        }
        
        func saveCurrencyType(currencyType: String) {
            userDefaults.set(currencyType.uppercased(), forKey: "selectedCurrencyType")
        }
    

}
