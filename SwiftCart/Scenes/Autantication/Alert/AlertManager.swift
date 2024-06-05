//
//  AlertManager.swift
//  SwiftCart
//
//  Created by Anas Salah on 05/06/2024.
//

import Foundation
import UIKit

struct AlertManager {
    
    static func showAlert(title: String?,
                          message: String?,
                          preferredStyle: UIAlertController.Style,
                          actions: [UIAlertAction],
                          from viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
    // MARK: here how to use it
/*
    func showMyAlert() {
        // Define actions
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
             
        // Show alert
        AlertManager.showAlert(title: "Alert",
            message: "SkipBtn is tapped",
            preferredStyle: .alert,
            actions: [defaultAction, cancelAction],
            from: self)
         }
        
/////////////////// OR \\\\\\\\\\\\\\\\\\\\
     
    @IBAction func btnTapped(_ sender: Any) {
        let defaultAction = UIAlertAction(title: "Save", style: .default, handler: { _ in print("Logic here")})
        let destructiveAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        AlertManager.showAlert(title: "Alert",
            message: "SkipBtn is tapped",
            preferredStyle: .alert,
            actions: [defaultAction, destructiveAction, cancelAction],
            from: self)
        }
 
 /////////////////// OR \\\\\\\\\\\\\\\\\\\\
 AlertManager.showAlert(title: "Error!", message: "Pleas enter both email and password", preferredStyle: .alert, actions: [], from: self)
*/

