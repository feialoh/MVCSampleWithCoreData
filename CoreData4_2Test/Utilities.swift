//
//  Utilities.swift
//  CoreData4_2Test
//
//  Created by Feialoh Francis on 2/27/19.
//  Copyright © 2019 Cabot. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    class func validationSuccess(fields:[UITextField]) -> (valid:Bool, emptyTextField:UITextField?) {
        for eachField in fields {
            if (eachField.text?.replacingOccurrences(of: " ", with: "").isEmpty)! {
                return (false, eachField)
            }
        }
        return (true, nil)
    }
    
    
    class func showAlert(_ message: String, title: String, delegate: UIViewController, cancelButtonTitle: String) {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Ok", style: .default) { _ in }
            
            alertController.addAction(OKAction)
            delegate.present(alertController, animated: true, completion: nil)
        })
        
    }
    
    //Get viewcontroller for storyboard
    
    class func getViewController(storyboardID: String, viewControllerID: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        
        return viewController
    }
}
