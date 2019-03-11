//
//  RegisterViewController.swift
//  CoreData4_2Test
//
//  Created by Feialoh Francis on 2/27/19.
//  Copyright © 2019 Cabot. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneNoTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var termsAndConditionsBtn: UIButton!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    let MANDATORY_FIELD_PREFIX = "Please fill the "
    let MANDATORY_FIELD_SUFFIX = " field."
    let errorLabel             = "Error"
    
    let registerManager = UserEntryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        
        var signupModel = SignupViewModel()
        signupModel.name = nameTextField.text
        signupModel.username = emailTextField.text
        signupModel.phoneNo = phoneNoTextField.text 
        signupModel.password = passwordTextField.text
        
        let mandatoryFields = Utilities.validationSuccess(fields: [nameTextField, phoneNoTextField, emailTextField, passwordTextField, confirmPasswordTextField])
        
        if !mandatoryFields.0 {
            
            Utilities.showAlert(MANDATORY_FIELD_PREFIX + (mandatoryFields.1?.placeholder)! + MANDATORY_FIELD_SUFFIX, title: errorLabel, delegate: self, cancelButtonTitle: "Ok")
            return
        }
        
        if(passwordTextField.text != confirmPasswordTextField.text){
            
            Utilities.showAlert("Passwords do not match", title: errorLabel, delegate: self, cancelButtonTitle: "Ok")
            
            return
        }
        
        registerManager.signUpUser(signupViewModelData:signupModel ) { (error) in
            if error == nil {
                print("Success!!")
                UserDefaults().set(true, forKey: "isLoggedin")
                UserDefaults().set(signupModel.username, forKey: "username")
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
    
    
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.endEditing(false)
    }
    
}
