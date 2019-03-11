//
//  UserTableViewCell.swift
//  CoreData4_2Test
//
//  Created by Feialoh Francis on 2/27/19.
//  Copyright © 2019 Cabot. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneNoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ viewModel: HomeViewModel) {
        
        self.nameLabel.text  = viewModel.name
        self.phoneNoLabel.text  = viewModel.phoneNo
        
    }
    
}
