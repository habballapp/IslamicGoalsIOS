//
//  Calendar.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 01/11/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import Foundation
import FirebaseFirestore

class CalendarDatabase {
    
    var calendar_id : String
    var description : String
    var end_date : String
    var start_date : String
    var title : String
    
    init(calendar_id : String, description : String, end_date : String, start_date : String, title : String
) {
        self.calendar_id = calendar_id
        self.description = description
        self.end_date = end_date
        self.start_date = start_date
        self.title = title
    }
    
    func addCalendarDatabase (currentUserId : String, handleFinish:@escaping((_ isAdded:Bool) -> ())) {
        let db = Firestore.firestore()
        _ = db.collection("calendar").document(currentUserId).collection("events").addDocument(data: [
            "calendar_id":calendar_id,
            "description":description,
            "end_date":end_date,
            "start_date":start_date,
            "title":title
        ]){ err in
            if let err = err {
                CustomToast.showNegativeMessage(message: "Error adding document: \(err)")
                print("Error adding document: \(err)")
                handleFinish(false)
            } else {
                print("Document added")
                handleFinish(true)
            }
        }

    }
    
    static func checkCalendarExistence(currentUserId : String, end_date : String, start_date : String, title : String, handleFinish:@escaping((_ isExsists:Bool) -> ())){
        let db = Firestore.firestore()
        let calendarRef = db.collection("calendar").document(currentUserId).collection("events").whereField("start_date", isEqualTo: start_date).whereField("end_date", isEqualTo: end_date).whereField("title", isEqualTo: title).limit(to: 1)
        calendarRef.getDocuments{ (document, error) in
            handleFinish(document?.count == 1)
        }
    }
    
    static func getCalendarObject(currentUser : UserDatabase, calendarID:String,handleFinish:@escaping((_ isExsists:Bool,_ calendar:CalendarDatabase?) -> ())){
        let db = Firestore.firestore()
        let calendarRef = db.collection("calendar").document(currentUser.user_id).collection("events").document(calendarID)
        calendarRef.getDocument { (document, error) in
            if let error = error {
                CustomToast.showNegativeMessage(message: error.localizedDescription)
                print(error.localizedDescription)
            }
            if let document = document {
                if document.exists {
                    let calendar = CalendarDatabase.init(calendar_id: document["calendar_id"] as! String, description: document["description"] as! String, end_date: document["end_date"] as! String, start_date: document["start_date"] as! String, title: document["title"] as! String)
                    handleFinish(true,calendar)
                    return
                }
            }
            handleFinish(false,nil)
        }
    }

    
}
