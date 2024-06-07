//
//  Utilites.swift
//  SwiftCart
//
//  Created by Elham on 03/06/2024.
//
  
    import Foundation
    import UIKit
    
struct Utils {
    
    static func convertTo<T: Decodable>(from data: Data)-> T?{
        
        do {
            let decoder = JSONDecoder()
              decoder.dateDecodingStrategy = .iso8601
            let result = try decoder.decode(T.self, from: data)
            return result
            
        } catch let error{
            print(error)
            return nil
        }
    }
    
    static func showAlert(title: String, message:String , view : UIViewController , isCancelled :Bool, complitionHandler : @escaping ()->() ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default) { action in
            complitionHandler()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(ok)
        if isCancelled {
            alert.addAction(cancel)
        }
        
        view.present(alert, animated: true)
    }
    
}
