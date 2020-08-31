//
//  ChooseFrequencyViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 08/11/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChooseFrequencyViewController: UIViewController {

    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var beginnerSelectedView: UIView!
    @IBOutlet weak var beginnerView: UIView!
    @IBOutlet weak var beginnerImage: UILabel!
    
    @IBOutlet weak var intermediateSelectedView: UIView!
    @IBOutlet weak var intermediateView: UIView!
    @IBOutlet weak var intermediateImage: UILabel!
    
    @IBOutlet weak var advanceSelectedView: UIView!
    @IBOutlet weak var advanceView: UIView!
    @IBOutlet weak var advanceImage: UILabel!
    
    var selectedFrequency : Int = 0
    var db: Firestore!
    var userid = ""
    var Habit = ""
    var SubHabit = ""
    var selectedFrequencyText = ""
    var key : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        userid = (Auth.auth().currentUser?.uid)!
        backgroundCard.layer.cornerRadius = 25
        backgroundCard.dropShadow()
        saveButton.layer.cornerRadius = 25

        headerLabel.text = "\(SubHabit)"
        beginnerView.layer.cornerRadius = 25
        beginnerView.layer.borderColor = darkGreenColor.cgColor
        beginnerView.layer.borderWidth = 1

        beginnerSelectedView.layer.cornerRadius = 30
        beginnerSelectedView.layer.borderColor = darkGreenColor.cgColor
        beginnerSelectedView.layer.borderWidth = 0
       // beginnerImage.layer.cornerRadius = 20
        beginnerImage.layer.cornerRadius = beginnerImage.frame.width/2

        intermediateSelectedView.layer.cornerRadius = 30
        intermediateSelectedView.layer.borderColor = darkGreenColor.cgColor
        intermediateSelectedView.layer.borderWidth = 0
       // intermediateImage.layer.cornerRadius = 20
        intermediateImage.layer.cornerRadius = intermediateImage.frame.width/2


        intermediateView.layer.cornerRadius = 25
        intermediateView.layer.borderColor = darkGreenColor.cgColor
        intermediateView.layer.borderWidth = 1
        

        advanceSelectedView.layer.cornerRadius = 30
        advanceSelectedView.layer.borderColor = darkGreenColor.cgColor
        advanceSelectedView.layer.borderWidth = 0
        //advanceImage.layer.cornerRadius = 20
        advanceImage.layer.cornerRadius = advanceImage.frame.width/2


        advanceView.layer.cornerRadius = 25
        advanceView.layer.borderColor = darkGreenColor.cgColor
        advanceView.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectBeginner(_ sender: Any) {
        selectedFrequency = 1
        selectedFrequencyText = "Beginner"
        UIView.animate(withDuration: 0.3) {
            self.beginnerSelectedView.layer.borderWidth = 2
            self.intermediateSelectedView.layer.borderWidth = 0
            self.advanceSelectedView.layer.borderWidth = 0
        }
    }
    
    @IBAction func selectIntermediate(_ sender: Any) {
        selectedFrequency = 2
        selectedFrequencyText = "Intermediate"
        UIView.animate(withDuration: 0.3) {
            self.beginnerSelectedView.layer.borderWidth = 0
            self.intermediateSelectedView.layer.borderWidth = 2
            self.advanceSelectedView.layer.borderWidth = 0
        }
    }
    
    
    @IBAction func selectAdvance(_ sender: Any) {
        selectedFrequency = 3
        selectedFrequencyText = "Advanced"
        UIView.animate(withDuration: 0.3) {
            self.beginnerSelectedView.layer.borderWidth = 0
            self.intermediateSelectedView.layer.borderWidth = 0
            self.advanceSelectedView.layer.borderWidth = 2
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        var value = ""
        if selectedFrequency == 1{
            value = "Beginner"
        }else if selectedFrequency == 2{
            value = "Intermediate"
        }else if selectedFrequency == 3{
            value = "Advanced"
        }
        
        let db = Firestore.firestore()
        let userid = (Auth.auth().currentUser?.uid)!
        let collectionRef = db.collection("users/\(userid)/AddHabits/")
        collectionRef.getDocuments { (querySnapshot, err) in
        if let docs = querySnapshot?.documents {
                     for docSnapshot in docs {
                         let habitKey = docSnapshot["HabitKey"] as! String
                         let subHabit = docSnapshot["subHabitsName"] as! String
                         let frequency = docSnapshot["frequency"] as! String
                         let habitName = docSnapshot["habitName"] as! String
                         self.frequencyReminder(frequency: frequency, habitKey: habitKey, subHabit: subHabit,habitName: habitName)
                     }
                     
                     DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                         
                     })
                 }
        }
            
        
        
        
        
        
        db.collection("users/\(userid)/AddHabits").addDocument(data: [
            "frequency": "\(value)",
            "habitName": "\(Habit)",
            "subHabitsName": "\(SubHabit)",
            "HabitKey" : "\(key!)"
            ])
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                let alert = UIAlertController(title: "Saved", message: "Successfully Saved!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                        
                    }}))
                self.present(alert, animated: true, completion: nil)
                print("Document added!")
                self.saveNotificationData()
                //performSegue(withIdentifier: "gotoHome", sender: self)
            }
        }
    }
    func frequencyReminder(frequency: String, habitKey: String, subHabit: String,habitName: String){
          let db = Firestore.firestore()
          let collectionRef = db.collection("habits")
          collectionRef.getDocuments { (querySnapshot, err) in
              if let docs = querySnapshot?.documents {
                  for docSnapshot in docs {
                      let data = docSnapshot["Name"] as? String
                      
                      if data == habitName{
                          
                          let subhabits = docSnapshot["SubHabits"] as! [[String : Any]]
                          for docSnapshot1 in subhabits{
                              
                              let doc = docSnapshot1["Name"]
                              if doc as! String == subHabit{
                                  var freq = 0.0
                                  if frequency == "Beginner" {
                                      freq = docSnapshot1["Frequency_Beginner"] as! Double
                                      
                                  }else if frequency == "Intermediate" {
                                      freq = docSnapshot1["Frequency_Intermediate"] as! Double
                                      
                                  }else if frequency == "Advanced" {
                                      freq = docSnapshot1["Frequency_Advanced"] as! Double
                                  }
                                  
                                  
                                  var value = UserDefaults.standard.double(forKey: "Frequencey")
                                  value = value + freq
                                  UserDefaults.standard.set(value, forKey: "Frequencey")
                                  
                                  return
                              }
                              
                          }
                      }
                  }
              }
          }
      }
    
    func saveNotificationData(){
        let date1 = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date1)
        let month = calendar.component(.month, from: date1)
        let year = calendar.component(.year, from: date1)
        let hour = calendar.component(.hour, from: date1)
        let minute = calendar.component(.minute, from: date1)
        let second = calendar.component(.second, from: date1)
        var str_hour = String(hour)
        var str_minute = String(minute)
        var str_second = String(second)
        if((str_minute.count) == 1) {
            str_minute = "0" + str_minute
        }
        if((str_hour.count) == 1) {
            str_hour = "0" + str_hour
        }
        if((str_second.count) == 1) {
            str_second = "0" + str_second
        }
        var str_month = String(month)
        var str_day = String(day)
        if((str_month.count) == 1) {
            str_month = "0" + str_month
        }
        if((str_day.count) == 1) {
            str_day = "0" + str_day
        }

        let timestamp = "\(year)-\(str_month)-\(str_day) \(str_hour):\(str_minute):\(str_second).000"
        let db = Firestore.firestore()
        
        _ = db.collection("notifications").document().setData([
            "UserID" : userid,
            "Body" : "Habit: Notification for \(SubHabit)",
            "Frequency" : "\(selectedFrequencyText)",
       "HabitKey" : "\(key!)",
            "Sound" : "Enabled",
            "Status" : "Pending",
            "SubHabit" : "\(SubHabit)",
            "SubHabitIndex" : 0,
            "Title": "Habit Reminder Notification",
            "Type" : "Habit",
            "Time" : timestamp
    ]){ err in
            if let err = err {
                CustomToast.showNegativeMessage(message: "Error adding document: \(err)")
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    
}
