//
//  SginUp.swift
//  SwiftCart
//
//  Created by Anas Salah on 31/05/2024.
//

import UIKit
import FirebaseAuth

class SginUp: UIViewController { // TODO: fix routation in Sgin UP
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any) { }

    @IBAction func skipBtn(_ sender: Any) { }
    
    @IBAction func alleadyHaveAcc(_ sender: Any) {
        if let loginViewController = navigationController?.viewControllers.first(where: { $0 is Login }) {
            navigationController?.popToViewController(loginViewController, animated: true)
        } else {
            let login = Login(nibName: K.Auth.loginNibName, bundle: nil)
            navigationController?.setViewControllers([login], animated: true)
        }
    }

    @IBAction func sginUp(_ sender: Any) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty,
              let rePassword = rePasswordTF.text, !rePassword.isEmpty,
              let name = nameTF.text, !name.isEmpty
        else {
            AuthHelper.showAlert(title: "Error", message: "All fileds should be completed", from: self)
            return
        }
        
        guard password == rePassword else {
            AuthHelper.showAlert(title: "Invalid password matching!", message: "Passwords do not match", from: self)
            return
        }
        
        guard AuthHelper.isValidPassword(password: password) else {
            AuthHelper.showAlert(title: "Invalid password", message: "Password must contain one at least uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters long.", from: self)
            return
        }
        
        guard AuthHelper.isValidName(name) else {
            AuthHelper.showAlert(title: "Invalid name", message: "pleas enter name between 3 - 20 Character", from: self)
            return
        }

        guard AuthHelper.isValidEmail(email) else {
            AuthHelper.showAlert(title: "Invalid email", message: "Please enter a valid email address.", from: self)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                AuthHelper.showAlert(title: "Error creating user",
                                     message: error.localizedDescription,
                                     from: self)
            } else {
                print("User created successfully")
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
