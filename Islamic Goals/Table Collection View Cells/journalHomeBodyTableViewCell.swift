//
//  journalHomeBodyTableViewCell.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 27/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit

class journalHomeBodyTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCard.layer.cornerRadius = min(25,backgroundCard.frame.height/2)
        backgroundCard.dropShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
