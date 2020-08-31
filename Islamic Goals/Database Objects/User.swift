//
//  User.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 23/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import Foundation
import FirebaseFirestore

class UserDatabase {
    var created_at : String
    var account_type : String
    var email : String
    var name : String
    var user_id : String
    var Record1 : Int
    var Record2 : Int
    var Record3 : Int
    var Record4 : Int
    var ReminderDone : Int
    var ReminderNotDone : Int
    var Record1_Day = ""
    var user_location : [String: Any]
    var timestamp : [String: Any]
    var check = true
    var token = ""
    var Update_TimeStamp = ""
    var ReminderDone_Day = ""
    var Update_Rem_TimeStamp = ""
    var GMT = ""
    var type = ""
    var habitArray : [String: Any]
    
    
    
    
    
    init(created_at:String, account_type:String, email:String, name:String, user_id:String,Record1 : Int,Record2 : Int,Record3 : Int,Record4 : Int,user_location: [String: Any],timestamp: [String: Any],ReminderDone: Int, Record1_Day: String, Update_TimeStamp : String, ReminderDone_Day: String, Update_Rem_TimeStamp: String, token: String, check: Bool , GMT: String,habitArray:  [String: Any],ReminderNotDone: Int, type: String) {
        self.user_id = user_id
        self.created_at = created_at
        self.account_type = account_type
        self.name = name
        self.email = email
        self.Record1 = Record1
        self.Record2 = Record2
        self.Record3 = Record3
        self.Record4 = Record4
        self.user_location = user_location
        self.timestamp = timestamp
        self.ReminderDone = ReminderDone
        self.Record1_Day = Record1_Day
        self.Update_TimeStamp = Update_TimeStamp
        self.ReminderDone_Day = ReminderDone_Day
        self.Update_Rem_TimeStamp = Update_Rem_TimeStamp
        self.token = token
        self.check = check
        self.GMT = GMT
        self.habitArray = habitArray
        self.ReminderNotDone = ReminderNotDone
        self.type = type
    }
    
    func addUserDatabase(){
        let db = Firestore.firestore()
        _ = db.collection("users").document(user_id).setData([
            "user_id" : user_id,
            "created_at" : created_at,
            "account_type" : account_type,
            "name" : name,
            "email" : email,
            "Record1" : Record1,
            "Record2" : Record2,
            "Record3" : Record3,
            "Record4" : Record4,
            "user_location" : user_location,
            "timestamp" : timestamp,
            "ReminderDone": ReminderDone,
            "Record1_Day": Record1_Day,
            "Update_TimeStamp" : Update_TimeStamp,
            "ReminderDone_Day" : ReminderDone_Day,
            "Update_Rem_TimeStamp" : Update_Rem_TimeStamp,
            "token" : token,
            "check" : check,
            "GMT" : GMT,
            "habitArray": habitArray,
            "ReminderNotDone": ReminderNotDone,
            "type" : type
        ]){ err in
            if let err = err {
                CustomToast.showNegativeMessage(message: "Error adding document: \(err)")
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    
    // MARK: - Static Functions
    
    static func checkUserExsistence(userId:String,handleFinish:@escaping((_ isExsists:Bool) -> ())){
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { (document, error) in
            if let error = error {
                CustomToast.showNegativeMessage(message: error.localizedDescription)
                print(error.localizedDescription)
            }
            if let document = document {
                handleFinish(document.exists)
                return
            }
            handleFinish(false)
        }
    }
    
    static func checkEmailExsistence(email:String, handleFinish:@escaping((_ isExsists:Bool) -> ())){
        let db = Firestore.firestore()
        let userRef = db.collection("users").whereField("email", isEqualTo: email).limit(to: 1)
        userRef.getDocuments{ (document, error) in
            handleFinish(document?.count == 1)
        }
    }
    
    static func getUserObject(userId:String,handleFinish:@escaping((_ isExsists:Bool,_ user:UserDatabase?) -> ())){
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { (document, error) in
            if let error = error {
                CustomToast.showNegativeMessage(message: error.localizedDescription)
                print(error.localizedDescription)
            }
            if let document = document {
                if document.exists {
                    let user = UserDatabase.init(
                        created_at: document["created_at"] as! String,
                        account_type: document["account_type"] as! String,
                        email: document["email"] as! String,
                        name: document["name"] as! String,
                        user_id: document["user_id"] as! String,
                        Record1: document["Record1"] as! Int,
                        Record2: document["Record2"] as! Int,
                        Record3: document["Record3"] as! Int,
                        Record4: document["Record4"] as! Int,
                        user_location: document["user_location"] as! [String: Any],
                        timestamp: document["timestamp"] as! [String: Any],
                        ReminderDone: document["ReminderDone"] as! Int,
                        Record1_Day: document["Record1_Day"] as! String,
                        Update_TimeStamp : document["Update_TimeStamp"] as! String,
                        ReminderDone_Day : document["ReminderDone_Day"] as! String,
                        Update_Rem_TimeStamp: document["Update_Rem_TimeStamp"] as! String,
                        token : document["token"] as! String,
                        check : document["check"] as! Bool,
                        GMT : document["GMT"] as! String,
                        habitArray: document["habitArray"] as! [String: Any],
                        ReminderNotDone: document["ReminderNotDone"] as! Int,
                        type : document["type"] as! String
                        )
                    
                    handleFinish(true,user)
                    return
                }
            }
            handleFinish(false,nil)
        }
    }
}
