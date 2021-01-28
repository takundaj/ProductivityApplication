//
//  HabitTrackerTableViewCell.swift
//  ToDoListApp
//
//  Created by T.J on 25/01/2021.
//  Copyright © 2021 TETRA. All rights reserved.
//

import UIKit

class HabitTrackerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var habitTitle: UILabel!
    
    @IBOutlet weak var outOf100: UILabel!
    
    @IBOutlet weak var progressMeter: UIProgressView!
    
    @IBOutlet weak var completionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
