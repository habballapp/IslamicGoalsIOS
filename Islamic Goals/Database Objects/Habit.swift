//
//  Habit.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 29/10/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import Foundation
import FirebaseFirestore

class HabitDatabase {
    
    var habit_title : String
    var time : String
    var type : String
    var timestamp : String

    init(habit_title:String, time:String, type:String, timestamp : String) {
        self.habit_title = habit_title
        self.time = time
        self.type = type
        self.timestamp = timestamp
    }
    
    func addHabitDatabase(currentUser : UserDatabase, handleFinish:@escaping((_ isAdded:Bool) -> ())) {
        if time == ""{
            let db = Firestore.firestore()
            _ = db.collection("users").document(currentUser.user_id).collection("AddReminder").addDocument(data: [
                "Name" : habit_title,
                "TypeOfReminder" : type,
                "timestamp" : timestamp
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
        else{
            let db = Firestore.firestore()
            _ = db.collection("users").document(currentUser.user_id).collection("AddReminder").addDocument(data: [
                "Name" : habit_title,
                "Time" : time,
                "TypeOfReminder" : type,
                "timestamp" : timestamp
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
}

}
