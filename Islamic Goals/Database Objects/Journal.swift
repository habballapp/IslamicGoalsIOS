//
//  Journal.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 25/10/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import Foundation
import FirebaseFirestore

class JournalDatabase {
    
    var dateJournal : String
    var jDescription : String
    var timestamp : String
    
    init(dateJournal : String, jDescription : String, timestamp : String) {
        self.dateJournal = dateJournal
        self.jDescription = jDescription
        self.timestamp = timestamp
        
    }
    
    func addJournalDatabase(currentUser : UserDatabase, handleFinish:@escaping((_ isAdded:Bool) -> ())) {
        
        let db = Firestore.firestore()
        _ = db.collection("users").document(currentUser.user_id).collection("AddJournal").addDocument(data: [
            "dateJournal" : dateJournal,
            "jDescription" : jDescription,
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
    
    static func getAllJournalOfAUser(currentUser : UserDatabase, handleFinish:@escaping((_ isExsists:Bool,_ journalsData:[String:[String]]) -> ())) {
        
        var journalsData = [String:[String]]()
        
        let db = Firestore.firestore()
        let journalRef = db.collection("users").document(currentUser.user_id).collection("AddJournal")
        journalRef.getDocuments { (document, error) in
            if let error = error {
                CustomToast.showNegativeMessage(message: error.localizedDescription)
                print(error.localizedDescription)
            }
            if let document = document {
                for doc in document.documents {
                    let data = doc.data()
                    //entry is present
                    if var jD = journalsData[data["dateJournal"] as! String] {
                        jD.append(data["jDescription"] as! String)
                        journalsData[data["dateJournal"] as! String] = jD
                    }
                    // entry is missing
                    else {
                        journalsData.updateValue([data["jDescription"] as! String], forKey: (data["dateJournal"] as! String))
                    }
                }
                handleFinish(true,journalsData)
                return
            }
            handleFinish(false,[:])
        }
    }
    
}
