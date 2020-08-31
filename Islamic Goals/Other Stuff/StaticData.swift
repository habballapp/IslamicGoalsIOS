//
//  StaticData.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 27/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import Foundation
import UIKit

let HomePageRecordData = [["Total Perfect Days","21","Today at 1:00 pm"],
                          ["Your Current Streak","2","Today at 1:00 pm"],
                          ["Your Best Streak","4","Today at 1:00 pm"],
                          ["Total Habits Done","7","Today at 1:00 pm"],
                          ["Total Perfect Days","12","Today at 1:00 pm"]]

let HomePageReminderData = [["Do Laundry","Today at 1:00 pm"],
//                            ["Do Laundry","Today at 1:00 pm"],
//                            ["Do Laundry","Today at 1:00 pm"],
                            ["Do Laundry","Today at 1:00 pm"]]

let HomePageJournalData : [String:[String]] = [
    "Journal of Shukr":["Today on the TTC a really nice lady gave her seat to me. 😃","I almost lost my wallet on the bus but I found it! 😅"],
    "Journal of Shukr1":["Today on the TTC a really nice lady gave her seat to me. 😃"],
    "Journal of Shukr2":["lady gave her seat to me. 😃","I almost lost my wallet on the bus but I found it! 😅","I almost lost my wallet on the bus but I found it! 😅","I almost lost my wallet on the bus but I found it! 😅I almost lost my wallet on the bus but I found it! 😅I almost lost my wallet on the bus but I found it! 😅"]
]

let habbitCategoryData = [
    "Health":["Take Vitamins","Eat a good meal","Brush & Floss","Limit sugar","Limit caffeine","Take a break"],
    "Fitness":[],
    "Home":[],
    "Hobby":[],
    "Social":[],
    "Efficiency":[]
]

let journalSpecificData = [
    ["Jan. 28, 2019",["Today on the TTC a really nice lady gave her seat to me. 😃","Today on the TTC a really nice lady gave her seat to me. 😃"]],
//    ["Jan. 16, 2019",["I almost lost my wallet on the bus but I found it! 😅","I almost lost my wallet on the bus but I found it! 😅 I almost lost my wallet on the bus but I found it! 😅","I almost lost my wallet"]],
    ["Jan. 7, 2019",["Today on the TTC a really nice lady gave her seat to me. 😃"]]
]

let AddHabbitTimeData = [
    ["5 min",UIColor.init(red: 253/255, green: 253/255, blue: 150/255, alpha: 1)],
    ["10 min",UIColor.init(red: 191/255, green: 239/255, blue: 187/255, alpha: 1)],
    ["30 min",UIColor.init(red: 255/255, green: 207/255, blue: 181/255, alpha: 1)],
]

let AddHabbitColor : [UIColor] = [.red,.gray,.orange,.magenta,.yellow]

let AddHabbitIcon : [UIImage?] = [UIImage.init(named: "cross"),UIImage.init(named: "check"),UIImage.init(named: "google"),UIImage.init(named: "compass"),UIImage.init(named: "lock"),UIImage.init(named: "plus")]
