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
        print("Test")
        let sginUp = SginUp(nibName: K.sginUpNibName, bundle: nil)
        
        if let navController = navigationController {
            navController.pushViewController(sginUp, animated: true)
        } else {
            print("Parent is not UINavigationController")
        }
    }

    @IBAction func loginBtn(_ sender: Any) {       
        print("Test")
        if let email = emailTF.text, let password = passwordTF.text {
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    // MARK: show alert why cant Sgin UP // this will be from firebase
                    // remmber firebase should contain at least 6 number for password and email should include
                    // @ .com  // any way i will do more constatrin put for rembmber
                } else {
                    // MARK: Navigate to Home i think
                    print("SginUp Done Succesfuly")
                }
            }
        } else {
            // MARK: show alert why cant Sgin UP // this will be from me and i can make an if on all of it to make sure from pass and email follow the princples i need.
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
