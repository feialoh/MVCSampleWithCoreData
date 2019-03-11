//
//  UserEntryManager.swift
//  CoreData4_2Test
//
//  Created by Feialoh Francis on 2/27/19.
//  Copyright © 2019 Cabot. All rights reserved.
//

import Foundation


class UserEntryManager: NSObject {
    
    //Login User
    func loginUser(loginViewModelData: LoginViewModel, completion :  @escaping ( _ error: String?) -> Void) {        
        
        guard let userName = loginViewModelData.userName else { return }
        
        guard let password = loginViewModelData.password else { return }
        
        if (User.checkUser(userName, password)){
            completion(nil)
        } else {
            completion("Invalid username or password.")
        }
    }
    
    //Signup User
    func signUpUser(signupViewModelData: SignupViewModel, completion :  @escaping ( _ error: String?) -> Void) {
        

        guard let userName = signupViewModelData.username else { return }
        
        if (User.userExists(userName)){
            completion("User already exists.")
        } else {
            let _ = User(withData: signupViewModelData)
            completion(nil)
            
        }
    }
    
}
