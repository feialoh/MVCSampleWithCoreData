//
//  HomeManager.swift
//  CoreData4_2Test
//
//  Created by Feialoh Francis on 2/27/19.
//  Copyright © 2019 Cabot. All rights reserved.
//

import Foundation

class HomeManager: NSObject {
    
    //Get Users
    func getUserLists(_ searchString: String, completion: @escaping (_ data: [HomeViewModel]?, _ error: String?) -> Void) {
        
        completion(User.fetchUserData(),nil)
    }
    
    //update phonenumber
    func updateNumber(userName:String, phoneNo: String, completion :  @escaping ( _ error: String?) -> Void) {
        
        User.updateData(userName, phoneNo)
        completion(nil)
    }
    
    //delete user
    func deleteUser(userName:String, completion :  @escaping ( _ error: String?) -> Void) {
        
        User.deleteData(username: userName)
        completion(nil)
    }
}
