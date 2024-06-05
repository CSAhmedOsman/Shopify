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

        guard isValidEmail(email) else {
            showAlert(title: "Invalid email", message: "Please enter a valid email address.")
            return
        }
        
        guard isValidPassword(password) else {
            showAlert(title: "Invalid password", message: "Password must contain one at least uppercase letter, one lowercase letter, one digit, one special character, and be at least 6 characters long.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login Failed:", error.localizedDescription)
                self.showAlert(title: "Faild to Login", message: error.localizedDescription)
            } else {
                print("Login Successful")
                // TODO: Navigate to Home
            }
        }
    }
    
    
    // MARK: - Helper Methods

    private func showAlert(title: String, message: String) {
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        AlertManager.showAlert(title: title, message: message, preferredStyle: .alert, actions: [defaultAction], from: self)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }


    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{6,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
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
