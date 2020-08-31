//
//  CalendarModel.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 12/11/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import Foundation
import JZCalendarWeekView

enum ViewType: String {
    case defaultView = "Default JZBaseWeekView"
    case customView = "Custom JZBaseWeekView"
    case longPressView = "JZLongPressWeekView"
}

struct OptionsSelectedData {
    
    var viewType: ViewType
    var date: Date
    var numOfDays: Int
    var scrollType: JZScrollType
    var firstDayOfWeek: DayOfWeek?
    var hourGridDivision: JZHourGridDivision
    var scrollableRange: (startDate: Date?, endDate: Date?)
    
    init(viewType: ViewType, date: Date, numOfDays: Int, scrollType: JZScrollType, firstDayOfWeek: DayOfWeek?, hourGridDivision: JZHourGridDivision, scrollableRange: (Date?, Date?)) {
        self.viewType = viewType
        self.date = date
        self.numOfDays = numOfDays
        self.scrollType = scrollType
        self.firstDayOfWeek = firstDayOfWeek
        self.hourGridDivision = hourGridDivision
        self.scrollableRange = scrollableRange
    }
}

class DefaultViewModel: NSObject {

    private let firstDate = Date()
    private let secondDate = Date().add(component: .day, value: 1)
    private let thirdDate = Date().add(component: .day, value: 2)
    
    var events : [DefaultEvent]

    override init() {
        events = [
        DefaultEvent(id: "0", title: "One", startDate: firstDate, endDate: firstDate.add(component: .hour, value: 1)),
        DefaultEvent(id: "1", title: "Two", startDate: secondDate, endDate: secondDate.add(component: .hour, value: 4)),
        DefaultEvent(id: "2", title: "Three", startDate: thirdDate, endDate: thirdDate.add(component: .hour, value: 2)),
        DefaultEvent(id: "3", title: "Four", startDate: thirdDate, endDate: thirdDate.add(component: .hour, value: 26))]
    }
    
    
    lazy var eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)

    var currentSelectedData: OptionsSelectedData!
    
    
}


