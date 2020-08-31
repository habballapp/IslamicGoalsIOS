//
//  ProgressViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 20/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseFirestore
import FSCalendar

class ProgressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var dailyGoalsLabel: UILabel!
    
    @IBOutlet weak var MainHeadingLabel: UILabel!
    @IBOutlet weak var Graph1HeadingLabel: UILabel!
    @IBOutlet weak var Graph1TextHeadingLabel: UILabel!
    @IBOutlet weak var Graph1DescHeadingLabel: UILabel!
    
    @IBOutlet weak var StreakHeadingLabel: UILabel!
    @IBOutlet weak var currentStreakLabel: UILabel!
    @IBOutlet weak var LongestStreakHeadingLabel: UILabel!
    
    
    @IBOutlet weak var trackerCard: UIView!
    @IBOutlet weak var dailyGoalCard: UIView!
    @IBOutlet weak var streakCard: UIView!
    @IBOutlet weak var completedReminderLabel: UILabel!
    @IBOutlet weak var totalReminderLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var longestStreakLabel: UILabel!
    
    @IBOutlet weak var completedStreakLabel: UILabel!
    
    @IBOutlet weak var dailyGoalChart: PieChartView!
    @IBOutlet weak var streakChart: PieChartView!
    
    @IBOutlet weak var recordHeading: UILabel!
    @IBOutlet weak var recordCard: UIView!
    @IBOutlet weak var recordTableView: UITableView!
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dailyGoalsCard: UIView!
    @IBOutlet weak var dailyGoalHeaing: UILabel!
    @IBOutlet weak var allDoneColorLabel: UILabel!
    @IBOutlet weak var someDoneColorLabel: UILabel!
    @IBOutlet weak var dailyGoalMonthlyCalendar: FSCalendar!
    
    var reminderCompletedEntry = PieChartDataEntry(value: 0)
    var reminderRemaingEntry = PieChartDataEntry(value: 0)
    
    var reminderEnteries = [PieChartDataEntry]()
    
    var currentStreakEntry = PieChartDataEntry(value: 0)
    var longestStreakEntry = PieChartDataEntry(value: 0)

    var streakEnteries = [PieChartDataEntry]()
    
    var recordHeadingArray = [String]()
    var record1 = 0
    var record2 = 0
    var record3 = 0
    var record4 = 0
    var habitTimestamp = ""
    
    let allDoneDates = ["2019/11/08","2019/07/06","2019/07/17", "2015/11/28", "2015/12/21"]
    let someDoneDates = ["2019/11/18", "2019/11/16", "2019/07/20", "2019/07/03"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerCard.layer.cornerRadius = 25
        dailyGoalCard.layer.cornerRadius = 25
        streakCard.layer.cornerRadius = 25
        recordCard.layer.cornerRadius = 25
        //recordCard.height
        dailyGoalsCard.layer.cornerRadius = 25
        allDoneColorLabel.layer.cornerRadius = 10
        someDoneColorLabel.layer.cornerRadius = 10
        someDoneColorLabel.layer.borderWidth = 1
        someDoneColorLabel.layer.borderColor = lightGreenColor.cgColor
        
        recordCard.dropShadow()
        trackerCard.dropShadow()
        dailyGoalCard.dropShadow()
        streakCard.dropShadow()
        dailyGoalsCard.dropShadow()
        
      //  self.tabBarController?.tabBar.isHidden = true
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        //vc.selectedIndex = 3
        
        let date = Date()
        let value = date.monthAsString()
        monthLabel.text = "\(value) - Nothing done yet"
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        streakChart.delegate = self as? ChartViewDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _ = Timer.scheduledTimer(timeInterval: 35, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        updateReminderChart()
        updateStreakEntry()
        getTotalReminder()
        getHeadingData()
        getStreakData()
        getRecordValueData()
        getHeadingsData()
    }
    
    @objc func update() {
        let date1 = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date1)
        let minutes = calendar.component(.minute, from: date1)
        
        let remainingHours = 23 - hour
        let remainingMins = 59 - minutes
        
        print(hour)
        timeRemainingLabel.text = "\(remainingHours) : \(remainingMins)"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        recordHeadingArray.removeAll()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordHeadingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "record", for: indexPath) as! recordHomeTableViewCell
        cell.titleLabel.text = "\(recordHeadingArray[indexPath.row])"
        cell.dateLabel.text = habitTimestamp
        if indexPath.row == 0{
            cell.numberLabel.text = "\(record1)"
            cell.backCard.backgroundColor = UIColor(red: 255 / 255, green: 137 / 255.0, blue: 137 / 255.0, alpha: 1.0)
        }else if indexPath.row == 1{
            cell.numberLabel.text = "\(record2)"
            cell.backCard.backgroundColor = UIColor(red: 250 / 255, green: 240 / 255.0, blue: 152 / 255.0, alpha: 1.0)
        }else if indexPath.row == 2{
            cell.numberLabel.text = "\(record3)"
            cell.backCard.backgroundColor = UIColor(red: 134 / 255, green: 189 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        }else if indexPath.row == 3{
            cell.numberLabel.text = "\(record4)"
            cell.backCard.backgroundColor = UIColor(red: 191 / 255, green: 239 / 255.0, blue: 187 / 255.0, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func updateReminderChart(){
        
        let chartDataSet = PieChartDataSet(entries: reminderEnteries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [peachColor,lightGreyOutlineColor]
        chartDataSet.colors = colors

        let formatter:ChartFormatter = ChartFormatter()
        chartData.setValueFormatter(formatter)
        
        dailyGoalChart.data = chartData
        dailyGoalChart.animate(xAxisDuration: 1.4, easing: .none)
        dailyGoalChart.legend.enabled = false
        dailyGoalChart.holeRadiusPercent = 0.8
        dailyGoalChart.isUserInteractionEnabled = false
        
    }
    
    func updateStreakEntry(){
        
        let chartDataSet = PieChartDataSet(entries: streakEnteries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [lightGreenColor,lightGreyOutlineColor]
        chartDataSet.colors = colors
        
        let formatter:ChartFormatter = ChartFormatter()
        chartData.setValueFormatter(formatter)
        
        streakChart.data = chartData
        
        streakChart.animate(xAxisDuration: 1.4, easing: .none)
        streakChart.legend.enabled = false
        streakChart.holeRadiusPercent = 0.8
        streakChart.isUserInteractionEnabled = false
    }
    
    public class ChartFormatter: NSObject, IValueFormatter{
        public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            return ""
        }
    }
    
    

    func getData() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        let docRef = db.collection("users").document("\(uid)")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.reminderCompletedEntry.value = document["ReminderDone"] as! Double
                //self.reminderCompletedEntry.value = 2
                let notDone = document["ReminderNotDone"] as! Double
                
                let count = UserDefaults.standard.double(forKey: "Frequencey")
                let total = UserDefaults.standard.double(forKey: "Total")
                self.reminderRemaingEntry.value = count
                self.completedReminderLabel.text = "\(self.reminderCompletedEntry.value.clean)"
                self.totalReminderLabel.text = "\(total - notDone - self.reminderCompletedEntry.value)"
                self.timeLabel.text = "\(00):\(00)"
                
                if self.reminderCompletedEntry.value == 0 && self.reminderRemaingEntry.value == 0 {
                    self.reminderRemaingEntry.value = 1
                    self.reminderEnteries = [self.reminderCompletedEntry,self.reminderRemaingEntry]
                }else{
                    self.reminderEnteries = [self.reminderCompletedEntry,self.reminderRemaingEntry]
                }
                self.updateReminderChart()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getHeadingData(){
        let db = Firestore.firestore()
        let collectionRef = db.collection("graphs")
        collectionRef.getDocuments { (querySnapshot, err) in
            if let docs = querySnapshot?.documents {
                for docSnapshot in docs {
                    self.MainHeadingLabel.text = docSnapshot["MainHeading"] as? String
                    self.Graph1HeadingLabel.text = docSnapshot["Graph1Heading"] as? String
                    var string = docSnapshot["Graph1Text"] as? String
                    var newString = string!.replacingOccurrences(of: " ", with: "\n", options: .literal, range: nil)
                    self.Graph1TextHeadingLabel.text = newString
                    self.Graph1DescHeadingLabel.text = "\(docSnapshot["Graph1Desc"] as! String): "
                    
                    self.StreakHeadingLabel.text = docSnapshot["Graph2Heading"] as? String
                    string = docSnapshot["Graph2Text"] as? String
                    newString = string!.replacingOccurrences(of: " ", with: "\n", options: .literal, range: nil)
                    self.currentStreakLabel.text = newString
                    self.LongestStreakHeadingLabel.text = "\(docSnapshot["Graph2Desc"] as! String): "
                }
            }
        }
    }
    
    func getStreakData(){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        var docRef = db.collection("users").document("\(uid)")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.currentStreakEntry.value = document["Record2"] as! Double
                self.longestStreakEntry.value = document["Record3"] as! Double

//                print("the value of current streak entry is")
//                print(self.currentStreakEntry)
               // self.completedStreakLabel.text = document["Graph2Text"] as! String
                
                
                if self.currentStreakEntry.value == 0 && self.longestStreakEntry.value == 0{
                    self.longestStreakEntry.value = 1
                    self.streakEnteries = [self.currentStreakEntry,self.longestStreakEntry]
                    self.longestStreakLabel.text = "0"
                }else{
                    let greenvalue = (self.currentStreakEntry.value/self.longestStreakEntry.value) * 100
                    self.currentStreakEntry.value = greenvalue
                    self.streakEnteries = [self.currentStreakEntry,self.longestStreakEntry]
                    self.longestStreakLabel.text = "\(self.longestStreakEntry.value.clean)"
                }
                
                
                self.updateStreakEntry()
            } else {
                print("Document does not exist")
            }
        }
        
        

                
        
        
        
    }
    
    func getHeadingsData(){
        let db = Firestore.firestore()
        let collectionRef = db.collection("graphs")
        collectionRef.getDocuments { (querySnapshot, err) in
            if let docs = querySnapshot?.documents {
                for docSnapshot in docs {
                    self.dailyGoalHeaing.text = docSnapshot["Calendar"] as? String
                    self.recordHeading.text = docSnapshot["Record"] as? String
                    self.dailyGoalsLabel.text = docSnapshot["Graph1Text"] as? String
                    if let data = docSnapshot["Record1"] as? String {
                        self.recordHeadingArray.append(data)
                        self.recordTableView.reloadData()
                    }
                    if let data = docSnapshot["Record2"] as? String {
                        self.recordHeadingArray.append(data)
                        self.recordTableView.reloadData()
                    }
                    if let data = docSnapshot["Record3"] as? String {
                        self.recordHeadingArray.append(data)
                        self.recordTableView.reloadData()
                    }
                    if let data = docSnapshot["Record4"] as? String {
                        self.recordHeadingArray.append(data)
                        self.recordTableView.reloadData()
                    }
                    
                }
            }
        }
    }
    
    func getRecordValueData(){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        let docRef = db.collection("users").document("\(uid)")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.record1 = document["Record1"] as! Int
                self.record2 = document["Record2"] as! Int
                self.record3 = document["Record3"] as! Int
                self.record4 = document["Record4"] as! Int
                self.habitTimestamp = document["Update_TimeStamp"] as! String
                self.recordTableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    // MARK : - Date Formatter
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK: - Calendar
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return (allDoneDates.contains(self.dateFormatter1.string(from: date))) ? lightGreenColor : nil
        
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        return (someDoneDates.contains(self.dateFormatter1.string(from: date))) ? lightGreenColor : nil
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 1.0
    }
    
    func getTotalReminder(){
        let db = Firestore.firestore()
        var count = 0
        UserDefaults.standard.removeObject(forKey: "Frequencey")
        UserDefaults.standard.removeObject(forKey: "Total")
        let userid = (Auth.auth().currentUser?.uid)!
        let collectionRef = db.collection("users/\(userid)/AddHabits/")
        collectionRef.getDocuments { (querySnapshot, err) in
            if let docs = querySnapshot?.documents {
                for docSnapshot in docs {
                    let habitKey = docSnapshot["HabitKey"] as! String
                    let subHabit = docSnapshot["subHabitsName"] as! String
                    let frequency = docSnapshot["frequency"] as! String
                    let habitName = docSnapshot["habitName"] as! String
                    count = count + 1
                    self.frequencyReminder(frequency: frequency, habitKey: habitKey, subHabit: subHabit,habitName: habitName)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                    self.getData()
                })
            }
            
            UserDefaults.standard.set(count, forKey: "Total")
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

}

extension Date {
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
}

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
