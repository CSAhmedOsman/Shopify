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
        let sginUP = Login(nibName: "Login", bundle: nil)
        
        if let nabigationContoller = self.navigationController {
            nabigationContoller.pushViewController(sginUP, animated: true)
        }
    }

    @IBAction func sginUp(_ sender: Any) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
            print("Email and password are required")
            return
        }

        // Create a new user account with the provided email and password
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                // Handle the error, e.g., show an alert to the user
            } else {
                print("User created successfully")
                // Navigate to the next screen, e.g., the home screen
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
