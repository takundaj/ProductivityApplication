//
//  HomeTableViewCell.swift
//  ToDoListApp
//
//  Created by T.J on 08/12/2020.
//  Copyright © 2020 TETRA. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet var itemTitle:UILabel!
    @IBOutlet var itemNotes:UILabel!
    @IBOutlet var dateLabel:UILabel!
    @IBOutlet weak var Statusview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.accessoryView?.isOpaque = false
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
