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
    
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.navigationController?.navigationBar.isHidden = true

        // TODO: hide back btn of navigation
    }

    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
        // TODO: pop from stack "self"
    }

    @IBAction func skipBtn(_ sender: Any) { 
        coordinator?.gotoHome()
    }
    
    @IBAction func dontHaveAcc(_ sender: Any) {
        coordinator?.gotoSignUp(pushToStack: false)
    }

    @IBAction func loginBtn(_ sender: Any) {
        guard let email = emailTF.text, !email.isEmpty,
            let password = passwordTF.text, !password.isEmpty else {

            Utils.showAlert(title: "Error!", message: "Pleas enter both email and password", preferredStyle: .alert, from: self)
            print("Error")
            return
        }

        guard AuthHelper.isValidEmail(email) else {
            Utils.showAlert(title: "Invalid email", message: "Please enter a valid email address.", preferredStyle: .alert, from: self)
            return
        }
        
        guard AuthHelper.isValidPassword(password: password) else {
            Utils.showAlert(title: "Invalid password", message: "Password must contain one at least uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters long.", preferredStyle: .alert, from: self)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                Utils.showAlert(title: "Faild to Login", message: error.localizedDescription, preferredStyle: .alert, from: self)
            } else {
                print("Login Successful")
                self.coordinator?.gotoHome()
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
