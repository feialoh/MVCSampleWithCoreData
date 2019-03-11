//
//  User+CoreDataClass.swift
//  CoreData4_2Test
//
//  Created by Feialoh Francis on 2/27/19.
//  Copyright © 2019 Cabot. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(User)
public class User: NSManagedObject {
    
    static let entityName = "User"
    
    convenience init(withData signupViewModelData: SignupViewModel){
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let newEntity =  NSEntityDescription.entity(forEntityName: User.entityName, in:managedContext)
            
            // initializer on NSManagedObject class
            self.init(entity: newEntity!, insertInto: managedContext)
            
            self.name = signupViewModelData.name
            
            self.phoneno = signupViewModelData.phoneNo
            
            self.username = signupViewModelData.username
            
            self.password = signupViewModelData.password
            
            
            //Saving to database
            do {
                try managedContext.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            self.init()
        }
    }
    
    
    //Validate user details
    class func checkUser(_ username:String,_ password:String)->Bool{
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: User.entityName,
                                                in:managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "(username == %@) AND (password == %@)", username,password)
        
        do{
            let count = try managedContext.count(for: request)
            
            if (count > 0){
                return true
            }
            else{
                return false
            }
        }
        catch let error{
            print("check for duplicate assessment error: \(error.localizedDescription)")
            return false
        }
    }
    
    
    //Check if user exists
    class func userExists(_ username:String)->Bool{
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: User.entityName,
                                                in:managedContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "(username == %@)", username)
        
        do{
            let count = try managedContext.count(for: request)
            
            if (count > 0){
                return true
            }
            else{
                return false
            }
        }
        catch let error{
            print("check for duplicate assessment error: \(error.localizedDescription)")
            return false
        }
    }
    
    //Get user list
    class func fetchUserData() ->[HomeViewModel] {
        
        var userData = [HomeViewModel]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return userData}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: User.entityName)
        
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "feialoh")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        //
        let userName = UserDefaults.standard.string(forKey: "username") ?? ""
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                var homeData = HomeViewModel()
                homeData.name = data.value(forKey: "name") as? String
                homeData.phoneNo = data.value(forKey: "phoneno") as? String
                let uName = data.value(forKey: "username") as? String
                homeData.userName = uName
                if(uName != userName){
                    userData.append(homeData)
                }
                print(data.value(forKey: "name") as! String)
                print(data.value(forKey: "phoneno") ?? "No value")
            }
            return userData
            
        } catch {
            
            print("Failed")
            return userData
        }
    }
    
    
    
    //For updating existing data
    class func updateData(_ username:String, _ phoneNo:String){
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: User.entityName)
        fetchRequest.predicate = NSPredicate(format: "username = %@", username)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(phoneNo, forKey: "phoneno")
            print("Updated phone number = \(phoneNo)")
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        
    }
    
    //For deleting value
    class func deleteData(username:String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: User.entityName)
        fetchRequest.predicate = NSPredicate(format: "username = %@", username)
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    
}
