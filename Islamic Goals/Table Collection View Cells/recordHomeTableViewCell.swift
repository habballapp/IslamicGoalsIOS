//
//  recordHomeTableViewCell.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 27/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit

class recordHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var backCard: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backCard.layer.cornerRadius = 25
        backCard.dropShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
