//
//  EventCell.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 12/11/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class EventCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var event: DefaultEvent!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupBasic()
    }

    func setupBasic() {
        self.clipsToBounds = true
        
    }

    func configureCell(event: DefaultEvent) {
        self.event = event
            titleLabel.text = event.title
    }

}
