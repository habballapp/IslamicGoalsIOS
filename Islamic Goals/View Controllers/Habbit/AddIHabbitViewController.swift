//
//  AddIHabbitViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 28/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddIHabbitViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {

    @IBOutlet weak var withoutTimerSelectedView: UIView!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var iconImageCollectionView: UICollectionView!
    @IBOutlet weak var iconColorCollectionView: UICollectionView!
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var withoutTimerButton: UIButton!
    @IBOutlet weak var setCustomTimeButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var setCustomTimeLabel: UILabel!
    @IBOutlet weak var customTimeSelectedView: UIView!
    @IBOutlet weak var habitTitle: UITextField!
    
    var selectedTime : String = ""
    var type : String = ""
    var date = Date()
    var selectedMinute = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDisplay()
    }
    
    func setDisplay(){
        backgroundCardView.layer.cornerRadius = 25
        backgroundCardView.dropShadow()
        
        withoutTimerButton.layer.cornerRadius = 17.5
        withoutTimerButton.layer.borderWidth = 1
        withoutTimerButton.layer.borderColor = darkGreenColor.cgColor

        setCustomTimeButton.layer.cornerRadius = 17.5
        setCustomTimeButton.layer.borderWidth = 1
        setCustomTimeButton.layer.borderColor = darkGreenColor.cgColor

        withoutTimerSelectedView.layer.cornerRadius = withoutTimerSelectedView.frame.height / 2
        withoutTimerSelectedView.layer.borderWidth = 0
        withoutTimerSelectedView.layer.borderColor = darkGreenColor.cgColor

        customTimeSelectedView.layer.cornerRadius = customTimeSelectedView.frame.height / 2
        customTimeSelectedView.layer.borderWidth = 0
        customTimeSelectedView.layer.borderColor = darkGreenColor.cgColor
        
        saveButton.layer.cornerRadius = 25
        
        timePicker.alpha = 0
        timePicker.backgroundColor = .white
        
    }
    
    @IBAction func didSelectWithoutTimer(_ sender: Any) {
        type = "WithoutTimer"
        self.selectedTime = "0 min"
        self.setCustomTimeLabel.text = "Set Custom Time"
        self.customTimeSelectedView.layer.borderWidth = 0
        self.withoutTimerSelectedView.layer.borderWidth = 2
        for (ind,_) in AddHabbitTimeData.enumerated() {
            let cell = self.timeCollectionView.cellForItem(at: IndexPath(row: ind, section: 0))
            if let cell = cell {
                (cell as! LabelCollectionViewCell).selectedView.layer.borderWidth = 0
            }
        }

    }
    
    @IBAction func didSelectCustomTimer(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.timePicker.alpha = 1
        })
        type = "Custom"
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func setCustomTime(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.timePicker.alpha = 0
        }
        self.withoutTimerSelectedView.layer.borderWidth = 0
        for (ind,_) in AddHabbitTimeData.enumerated() {
            let cell = self.timeCollectionView.cellForItem(at: IndexPath(row: ind, section: 0))
            if let cell = cell {
                (cell as! LabelCollectionViewCell).selectedView.layer.borderWidth = 0
            }
        }
        
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: timePicker.date)
        selectedTime = time
        self.setCustomTimeLabel.text = time
        self.customTimeSelectedView.layer.borderWidth = 2

    }
    // MARK: - Add in Database
    
    @IBAction func didSelectedAddHabbit(_ sender: Any) {
        if UserManager.shared.isUserLoggedIn {
            if (self.habitTitle.text != nil && self.habitTitle.text != "" ){
                if (self.selectedTime != ""){
                    let currentDateTime = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"

                    var time = selectedTime
                    switch selectedTime {
                        
                    case "0 min":
                        time = formatter.string(from: currentDateTime)
                        time = ""
                        break
                    case "5 min":
                        print("HErE")
//                        currentDateTime = currentDateTime.addingTimeInterval(5*60.0)
//                        time = formatter.string(from: currentDateTime)
                        time = "5 Min"
                        selectedMinute = 5
                        break
                    case "10 min":
//                        currentDateTime = currentDateTime.addingTimeInterval(10*60.0)
//                        time = formatter.string(from: currentDateTime)
                        time = "10 Min"
                        selectedMinute = 10
                        break
                    case "30 min":
//                        currentDateTime = currentDateTime.addingTimeInterval(30*60.0)
//                        time = formatter.string(from: currentDateTime)
                        time = "30 Min"
                        selectedMinute = 30
                        break
                    default:
                        break
                    }
                    
                    
                    HabitDatabase.init(habit_title: self.habitTitle.text!, time: time, type: type, timestamp: "\(date)").addHabitDatabase(currentUser: UserManager.shared.userDetails!) { (isAdded) in
                        if (isAdded) {
                            self.saveNotificationData()
                            self.navigationController?.popViewController(animated: true)
                            
                        }
                    }
                } else {
                    CustomToast.showNegativeMessage(message: "select a time to proceed")
                }
            } else {
                CustomToast.showNegativeMessage(message: "habit title can not be empty")
            }
        } else {
            CustomToast.showNegativeMessage(message: "you are not signed in")
        }
    }
    
    func saveNotificationData(){
        let current_date = Date()
//        CustomToast.showNegativeMessage(message: "message: " + String(selectedTime))
        selectedMinute = Int(selectedTime.components(separatedBy: " ")[0]) ?? 0
        let date1 = Calendar.current.date(byAdding: .minute, value: selectedMinute,to: current_date)
        
        let calendar = Calendar(identifier: .gregorian)
        let day = calendar.component(.day, from: date1!)
        let month = calendar.component(.month, from: date1!)
        let year = calendar.component(.year, from: date1!)
        let hour = calendar.component(.hour, from: date1!)
        let minute = calendar.component(.minute, from: date1!)
        let second = calendar.component(.second, from: date1!)
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
        let userid = Auth.auth().currentUser!.uid
        _ = db.collection("notifications").document().setData([
            "UserID" : userid,
            "Body" : "Reminder: \(habitTitle.text!)",
            "Sound" : "Enabled",
            "Status" : "Pending",
            "Title": "\(habitTitle.text!)",
            "Type" : "Reminder",
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
    
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return AddHabbitTimeData.count
        }
        else if collectionView.tag == 1 {
            return AddHabbitColor.count
        }
        return AddHabbitIcon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "time", for: indexPath) as! LabelCollectionViewCell
            cell.selectedView.layer.borderColor = darkGreenColor.cgColor
            cell.selectedView.layer.borderWidth = 0
            cell.selectedView.layer.cornerRadius = 25
            
            cell.label.text = (AddHabbitTimeData[indexPath.row][0] as! String)
            cell.label.backgroundColor = (AddHabbitTimeData[indexPath.row][1] as! UIColor)
            cell.label.layer.cornerRadius = 19
            cell.label.layer.borderWidth = 1
            cell.label.layer.borderColor = darkGreenColor.cgColor
            cell.label.layer.masksToBounds = true
            return cell
        }
        else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "color", for: indexPath) as! LabelCollectionViewCell
            cell.selectedView.layer.borderColor = darkGreenColor.cgColor
            cell.selectedView.layer.borderWidth = 0
            cell.selectedView.layer.cornerRadius = 10
            
            cell.label.layer.masksToBounds = true
            cell.label.text = ""
            cell.label.backgroundColor = AddHabbitColor[indexPath.row]
            cell.label.layer.cornerRadius = 8
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! ImageCollectionViewCell
        cell.selectedView.layer.borderColor = darkGreenColor.cgColor
        cell.selectedView.layer.borderWidth = 0
        cell.selectedView.layer.cornerRadius = 27

        cell.image.layer.masksToBounds = true
        cell.image.image = AddHabbitIcon[indexPath.row]
        cell.image.layer.cornerRadius = 25
        cell.image.contentMode = .scaleAspectFit
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return CGSize(width: timeCollectionView.frame.width * 0.3 , height: 50)
        }
        else if collectionView.tag == 1 {
            return CGSize(width: 20, height: 20)
        }
        return CGSize(width: 54, height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            if collectionView.tag == 0 {
                self.type = "During"
                self.withoutTimerSelectedView.layer.borderWidth = 0
                self.setCustomTimeLabel.text = "Set Custom Time"
                self.customTimeSelectedView.layer.borderWidth = 0
                for (ind,_) in AddHabbitTimeData.enumerated() {
                    let cell = self.timeCollectionView.cellForItem(at: IndexPath(row: ind, section: 0))
                    if let cell = cell {
                        if indexPath.row == ind {
                            (cell as! LabelCollectionViewCell).selectedView.layer.borderWidth = 2
                            self.selectedTime = AddHabbitTimeData[ind][0] as! String
                        } else {
                            (cell as! LabelCollectionViewCell).selectedView.layer.borderWidth = 0
                        }
                    }
                }
            }
            else if collectionView.tag == 1 {
                self.type = "During"
                for (ind,_) in AddHabbitColor.enumerated() {
                    let cell = self.iconColorCollectionView.cellForItem(at: IndexPath(row: ind, section: 0))
                    if let cell = cell {
                        if indexPath.row == ind {
                            (cell as! LabelCollectionViewCell).selectedView.layer.borderWidth = 2
                        } else {
                            (cell as! LabelCollectionViewCell).selectedView.layer.borderWidth = 0
                        }
                    }
                }
            }
            else {
                self.type = "During"
                for (ind,_) in AddHabbitIcon.enumerated() {
                    let cell = self.iconImageCollectionView.cellForItem(at: IndexPath(row: ind, section: 0))
                    if let cell = cell {
                        if indexPath.row == ind {
                            (cell as! ImageCollectionViewCell).selectedView.layer.borderWidth = 2
                        } else {
                            (cell as! ImageCollectionViewCell).selectedView.layer.borderWidth = 0
                        }
                    }
                }
            }
        }
    }
}
