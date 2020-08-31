//
//  Google Calendar.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 01/11/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn

class GoogleCalendar {
    
    static func fetchEvents(userId : String, service:GTLRCalendarService, delegate:GIDSignInDelegate) {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 10
//            query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        service.executeQuery(query, delegate: delegate, didFinish: #selector(addCalendarInDatabase(ticket:finishedWithObject:error:)))
    }
    
    @objc private func addCalendarInDatabase(ticket: GTLRServiceTicket,
    finishedWithObject response : GTLRCalendar_Events,
    error : NSError?) {
        
        if let error = error {
            CustomToast.showNegativeMessage(message: error.localizedDescription)
            return
        }
        
        if let events = response.items, !events.isEmpty {
            for event in events {
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "DD/MM/YYYY hh:mm:ss"

                let description = event.descriptionProperty ?? ""
                let title = event.summary!
                let start = event.start!.dateTime ?? event.start!.date!
                let startString = dateFormatter.string(from: start.date)
                
                let end = event.end!.dateTime ?? event.end!.date!
                let endString = dateFormatter.string(from: end.date)
                let calendarID = event.iCalUID ?? ""
                
                CalendarDatabase.checkCalendarExistence(currentUserId:
                UserManager.shared.userDetails!.user_id, end_date: endString, start_date: startString, title: title) { (isPresent) in
                    if (!isPresent){
                        CalendarDatabase.init(calendar_id: calendarID, description: description, end_date: endString, start_date: startString, title: title).addCalendarDatabase(currentUserId: UserManager.shared.userDetails!.user_id) { (isAdded) in
                            if (isAdded){
//
                            }
                        }
                    }
                }
                
            }
        } else {
//            outputText = "No upcoming events found."
        }


        
    }
    
}
