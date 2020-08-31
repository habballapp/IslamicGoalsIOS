//
//  reminderHomeTableViewCell.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 27/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit

class reminderHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCard.layer.cornerRadius = 35/2
        backgroundCard.layer.borderColor = darkGreenColor.cgColor
        backgroundCard.layer.borderWidth = 1
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
