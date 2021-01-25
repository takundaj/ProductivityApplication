//
//  JournalHomeTableViewCell.swift
//  ToDoListApp
//
//  Created by T.J on 14/01/2021.
//  Copyright © 2021 TETRA. All rights reserved.
//

import UIKit

class JournalHomeTableViewCell: UITableViewCell {

    //MARK: Cell sub view IBOulets
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var entrySnippet:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
