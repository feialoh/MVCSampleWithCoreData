//
//  ViewController.swift
//  CoreData4_2Test
//
//  Created by Feialoh Francis on 2/27/19.
//  Copyright © 2019 Cabot. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var signupBtn: UIButton!
    
    let MANDATORY_FIELD_PREFIX = "Please fill the "
    let MANDATORY_FIELD_SUFFIX = " field."
    let errorLabel             = "Error"
    
    let loginManager = UserEntryManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginAction(_ sender: UIButton) {
//        User.fetchUserData()
        self.view.endEditing(true)
        var loginModel = LoginViewModel()
        loginModel.userName = usernameTextField.text
        loginModel.password = passwordTextField.text

        let mandatoryFields = Utilities.validationSuccess(fields: [usernameTextField, passwordTextField])
        
        if !mandatoryFields.0 {
            
            Utilities.showAlert(MANDATORY_FIELD_PREFIX + (mandatoryFields.1?.placeholder)! + MANDATORY_FIELD_SUFFIX, title: errorLabel, delegate: self, cancelButtonTitle: "Ok")
            return
        }
        
        loginManager.loginUser(loginViewModelData: loginModel) { (error) in
            if error == nil {
                print("Success!!")
                UserDefaults().set(true, forKey: "isLoggedin")
                UserDefaults().set(loginModel.userName, forKey: "username")
                DispatchQueue.main.async {
                    self.present( UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home") as UIViewController, animated: false, completion: nil)
                }
            }
            else {
                DispatchQueue.main.async {
                    Utilities.showAlert(error!, title: self.errorLabel, delegate: self, cancelButtonTitle: "Ok")
                }
            }

        }
    }
    
    
    @IBAction func signupAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "loginToRegisterVC", sender: self)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
         return textField.endEditing(false)
    }
    
 
    
   
}

