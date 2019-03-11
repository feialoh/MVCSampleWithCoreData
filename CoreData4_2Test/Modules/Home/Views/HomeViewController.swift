//
//  HomeViewController.swift
//  CoreData4_2Test
//
//  Created by Feialoh Francis on 2/27/19.
//  Copyright © 2019 Cabot. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    
    @IBOutlet weak var userTableView: UITableView!
    
    var userData = [HomeViewModel]()
    
    let homeManager = HomeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeData()
        // Do any additional setup after loading the view.
    }
    

    func initializeData(){
        
        //Set navigation bar attributes
        let userName = UserDefaults.standard.string(forKey: "username") ?? ""
        
        self.title = "Welcome \(userName)"
        
        //Set tableview attributes
        userTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier:"userCell" )
        userTableView.tableFooterView = UIView()
    
        //Get user lists
        self.fetchUpdateUserList()

    }
    
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        
         UserDefaults().set(false, forKey: "isLoggedin")
        self.present( UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserEntry") as UIViewController, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        
         cell.configure(userData[indexPath.row])

        return cell

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let viewModel = userData[indexPath.row]
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Edit Phone number", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = viewModel.phoneNo
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                guard let userName = viewModel.userName else { return }
                
                guard let phoneNo = alert.textFields?.first?.text else { return }
                
                self.homeManager.updateNumber(userName:userName,phoneNo: phoneNo) { (error) in
                    if error == nil {
                        print("Success!!")
                        DispatchQueue.main.async {
                            self.fetchUpdateUserList()
//                           self.userTableView.reloadRows(at: [indexPath], with: .fade)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            Utilities.showAlert(error!, title: "Error", delegate: self, cancelButtonTitle: "Ok")
                        }
                    }
                    
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
            guard let userName = viewModel.userName else { return }
            
            let alert = UIAlertController(title: "", message: "Delete User \(String(describing: userName))?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (updateAction) in
            

            self.homeManager.deleteUser(userName:userName) { (error) in
                if error == nil {
                    print("Success!!")
                    DispatchQueue.main.async {
                        self.userData.remove(at: indexPath.row)
                        self.userTableView.reloadData()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Utilities.showAlert(error!, title: "Error", delegate: self, cancelButtonTitle: "Ok")
                    }
                }
                
            }
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: false)
            
        })
        
        return [deleteAction, editAction]

    }


    func fetchUpdateUserList(){
        homeManager.getUserLists("") { (homeViewModelArray, error) in
            
            if error == nil {
                self.userData = homeViewModelArray ?? [HomeViewModel]()
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
                
            } else {
                DispatchQueue.main.async {
                    Utilities.showAlert("No Data", title: "Error", delegate: self, cancelButtonTitle: "Ok")
                }
            }
        }
    }
}
