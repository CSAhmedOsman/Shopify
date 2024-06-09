//
//  SginUp.swift
//  SwiftCart
//
//  Created by Anas Salah on 31/05/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SginUp: UIViewController { // TODO: fix routation in Sgin UP
    
    weak var coordinator: AppCoordinator?
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backBtn(_ sender: Any) { 
        coordinator?.finish()
    }

    @IBAction func skipBtn(_ sender: Any) { 
        coordinator?.gotoHome()
    }
    
    @IBAction func alleadyHaveAcc(_ sender: Any) {
        coordinator?.gotoLogin(pushToStack: false)
    }

    @IBAction func sginUp(_ sender: Any) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty,
              let rePassword = rePasswordTF.text, !rePassword.isEmpty,
              let name = nameTF.text, !name.isEmpty
        else {
            Utils.showAlert(title: "Error", message: "All fileds should be completed", preferredStyle: .alert, from: self)
            return
        }
        
        guard password == rePassword else {
            Utils.showAlert(title: "Invalid password matching!", message: "Passwords do not match", preferredStyle: .alert, from: self)
            return
        }
        
        guard AuthHelper.isValidPassword(password: password) else {
            Utils.showAlert(title: "Invalid password", message: "Password must contain one at least uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters long.", preferredStyle: .alert, from: self)
            return
        }
        
        guard AuthHelper.isValidName(name) else {
            Utils.showAlert(title: "Invalid name", message: "pleas enter name between 3 - 20 Character", preferredStyle: .alert, from: self)
            return
        }

        guard AuthHelper.isValidEmail(email) else {
            Utils.showAlert(title: "Invalid email", message: "Please enter a valid email address.", preferredStyle: .alert, from: self)
            return
        }
        
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                Utils.showAlert(title: "Error creating user",
//                                message: error.localizedDescription, preferredStyle: .alert,
//                                     from: self)
//            } else {
//                print("User created successfully")
//                self.coordinator?.gotoHome()
//                // Navigate to the next screen, the home screen
//            }
//        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    Utils.showAlert(title: "Error creating user", message: error.localizedDescription, preferredStyle: .alert, from: self)
                    return
                } else {
                    print("User created successfully in Firebase")
                    guard let uid = authResult?.user.uid else { return }
                    
                    ShopifyAPIHelper.shared.createCustomer(email: email, firstName: name, lastName: "") { result in
                        switch result {
                        case .success(let shopifyCustomerID):
                            DispatchQueue.main.async {
                                self.storeUserData(uid: uid, shopifyCustomerID: shopifyCustomerID, email: email, name: name) {
                                    self.coordinator?.gotoHome()
                                }
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                Utils.showAlert(title: "Error", message: "Failed to create Shopify customer: \(error.localizedDescription)", preferredStyle: .alert, from: self)
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func sginUpWithGoogle(_ sender: Any) { }

    @IBAction func sginUpWithX(_ sender: Any) {}

    // Helper Methods:
    
    func storeUserData(uid: String, shopifyCustomerID: String, email: String, name: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "uid": uid,
            "shopifyCustomerID": shopifyCustomerID,
            "email": email,
            "name": name
        ]
        
        db.collection("users").document(uid).setData(userData) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error writing document: \(error.localizedDescription)")
                    Utils.showAlert(title: "Error", message: "Failed to store user data: \(error.localizedDescription)", preferredStyle: .alert, from: self)
                } else {
                    print("Document successfully written!")
                    UserDefaults.standard.set(email, forKey: "userEmail")
                    UserDefaults.standard.set(name, forKey: "userName")
                    UserDefaults.standard.set(uid, forKey: "userUID")
                    UserDefaults.standard.set(shopifyCustomerID, forKey: "shopifyCustomerID")
                    completion()
                }
            }
        }
    }
}

/*
 "customers": [
         {
             "id": 6978897346607,
             "email": "anas.shopify07@gmail.com",
             "created_at": "2024-06-09T14:54:45-04:00",
             "updated_at": "2024-06-09T14:54:45-04:00",
             "first_name": "anas",
             "last_name": "",
             "orders_count": 0,
             "state": "disabled",
             "total_spent": "0.00",
             "last_order_id": null,
             "note": null,
             "verified_email": true,
             "multipass_identifier": null,
             "tax_exempt": false,
             "tags": "",
             "last_order_name": null,
             "currency": "EGP",
             "phone": null,
             "addresses": [],
             "tax_exemptions": [],
             "email_marketing_consent": {
                 "state": "not_subscribed",
                 "opt_in_level": "single_opt_in",
                 "consent_updated_at": null
             },
             "sms_marketing_consent": null,
             "admin_graphql_api_id": "gid://shopify/Customer/6978897346607"
         }
 */

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
