//
//  journalDateHeaderTableViewCell.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 28/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit

class journalDateHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        background.layer.cornerRadius = background.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
