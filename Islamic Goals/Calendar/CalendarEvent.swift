//
//  CalendarEvent.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 12/11/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import Foundation
import JZCalendarWeekView

class DefaultEvent: JZBaseEvent {

    var title: String

    init(id: String, title: String, startDate: Date, endDate: Date) {
        self.title = title

        // If you want to have you custom uid, you can set the parent class's id with your uid or UUID().uuidString (In this case, we just use the base class id)
        super.init(id: id, startDate: startDate, endDate: endDate)
    }

    override func copy(with zone: NSZone?) -> Any {
        return DefaultEvent(id: id, title: title, startDate: startDate, endDate: endDate)
    }
}
