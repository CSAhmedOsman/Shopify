//
//  Login.swift
//  SwiftCart
//
//  Created by Anas Salah on 31/05/2024.
//

import UIKit
import FirebaseAuth

class Login: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // TODO: hide back btn of navigation 
    }

    @IBAction func backBtn(_ sender: Any) {
        print("Test")
        // TODO: pop from stack "self"
        
    }

    @IBAction func skipBtn(_ sender: Any) { 
        print("Test")
        // TODO: This will nav to home as gust

    }
    
    @IBAction func dontHaveAcc(_ sender: Any) {
        if let signUpViewController = navigationController?.viewControllers.first(where: { $0 is SginUp }) {
            navigationController?.popToViewController(signUpViewController, animated: true)
        } else {
            let signUp = SginUp(nibName: K.Auth.sginUpNibName, bundle: nil)
            navigationController?.setViewControllers([signUp], animated: true)
        }
    }

    @IBAction func loginBtn(_ sender: Any) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)

            AlertManager.showAlert(title: "Error!", message: "Pleas enter both email and password", preferredStyle: .alert, actions: [defaultAction], from: self)
            print("Error")
            return
        }

        guard AuthHelper.isValidEmail(email) else {
            AuthHelper.showAlert(title: "Invalid email", message: "Please enter a valid email address.", from: self)
            return
        }
        
        guard AuthHelper.isValidPassword(password: password) else {
            AuthHelper.showAlert(title: "Invalid password", message: "Password must contain one at least uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters long.", from: self)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                AuthHelper.showAlert(title: "Faild to Login", message: error.localizedDescription, from: self)
            } else {
                print("Login Successful")
                // TODO: Navigate to Home
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
