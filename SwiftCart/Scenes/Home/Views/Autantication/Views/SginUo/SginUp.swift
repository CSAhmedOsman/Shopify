//
//  SginUp.swift
//  SwiftCart
//
//  Created by Anas Salah on 31/05/2024.
//

import UIKit
import FirebaseAuth

class SginUp: UIViewController { // TODO: fix routation in Sgin UP
    
    weak var coordinator: AppCoordinator?
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("SginUp is loaded ")
        
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
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                Utils.showAlert(title: "Error creating user",
                                message: error.localizedDescription, preferredStyle: .alert,
                                     from: self)
            } else {
                print("User created successfully")
                self.coordinator?.gotoHome()
                // Navigate to the next screen, the home screen
            }
        }
    }

    @IBAction func sginUpWithGoogle(_ sender: Any) { }

    @IBAction func sginUpWithX(_ sender: Any) {}

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
