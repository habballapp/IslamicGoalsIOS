//
//  CalendarViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 29/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import iOSDropDown
import FSCalendar
import Firebase
import FirebaseFirestore
import JZCalendarWeekView
import EventKit

class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var DateLabel: UILabel!
    
    @IBOutlet weak var calendarTitleCard: UIView!
    @IBOutlet weak var addReminderButton: UIButton!
    @IBOutlet weak var monthTextField: DropDown!
    @IBOutlet weak var calendarViewTextField: DropDown!
    
    @IBOutlet weak var calendarCard: UIView!
    @IBOutlet weak var monthlyCalendar: FSCalendar!
    @IBOutlet weak var weeklyDailyCalendar: WeekView!
    
    @IBOutlet weak var addEntryButton: UIButton!
    
    @IBOutlet weak var calendarHeadingLabel: UILabel!
    
    @IBOutlet weak var dayHeaderView: UIView!
    
    @IBOutlet weak var dayDateLabel: UILabel!
    @IBOutlet weak var dayLeftButton: UIButton!
    @IBOutlet weak var dayRightButton: UIButton!
    
    var keepCheckOfDate = 1
    
    let currentDate = Date()
    var dateComponent = DateComponents()
    var futureDate: Date?
    var updateDate: Date?
    var flag = true
 

    @IBAction func rightButtonPressed(_ sender: UIButton) {
        
        
        if keepCheckOfDate == 1 {
        
        dateComponent.day = keepCheckOfDate
        futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "eeee, MMMM d"
            self.dayDateLabel.text = dateFormatter.string(from: futureDate!)
            keepCheckOfDate = 0
        
        }else {
        
        futureDate = Calendar.current.date(byAdding: .day, value: 1, to: futureDate!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "eeee, MMMM d"
        self.dayDateLabel.text = dateFormatter.string(from: futureDate!)
        
        }
        
    }
    

    @IBAction func leftButtonPressed(_ sender: UIButton) {
        
        if flag == true {
        dateComponent.day = -1
        futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "eeee, MMMM d"
            self.dayDateLabel.text = dateFormatter.string(from: futureDate!)
            flag = false
            
            
        }
        else {
        futureDate = Calendar.current.date(byAdding: .day, value: -1, to: futureDate!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "eeee, MMMM d"
                self.dayDateLabel.text = dateFormatter.string(from: futureDate!)
        }
    }
    















    var allDoneDates = ["2019/11/15","2019/11/17","2019/07/17", "2019/07/28", "2019/06/30","2015/08/01"]
    
    var titlearray = [String]()
    var startDateArray = [String]()
    var startDateArray1 = [String]()
    let viewModel = DefaultViewModel()
    var events1 : [DefaultEvent] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getdata()
        self.newView.isHidden = true
        newView.layer.cornerRadius = 25
        self.dayHeaderView.isHidden = true
        if UserDefaults.standard.object(forKey: "StartDate") != nil {
            allDoneDates = UserDefaults.standard.array(forKey: "StartDate") as! [String]
        }else{
            allDoneDates = []
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        vc.selectedIndex = 2
        
        setUI()
        setMonthDropDown()
        setCalendarViewDropDown()
        getWeekEvents()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getdata()
//        allDoneDates = UserDefaults.standard.array(forKey: "StartDate") as! [String]
//       titlearray = UserDefaults.standard.array(forKey: "titleArray") as! [String]
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let string = formatter.string(from: date)
        let newString = string.replacingOccurrences(of: "-", with: "/", options: .literal, range: nil)
        
        for (index,_) in allDoneDates.enumerated() {
            if newString == allDoneDates[index]{
                let alert = UIAlertController(title: titlearray[index], message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        print("Selected date is \(string)")
    }
    
    func setUI() {
        calendarTitleCard.layer.cornerRadius = 25
        calendarTitleCard.dropShadow()
        calendarCard.layer.cornerRadius = 25
        calendarCard.dropShadow()
        //addReminderButton.layer.cornerRadius = 25
        //addReminderButton.dropShadow()
        //addEntryButton.layer.cornerRadius = 25
        //addEntryButton.dropShadow()
        weeklyDailyCalendar.alpha = 0
    }
    
    func setMonthDropDown(){
        self.monthlyCalendar.pagingEnabled = false
        monthTextField.optionArray = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        monthTextField.selectedIndex = Calendar.current.component(.month, from: Date()) - 1
        monthTextField.text = monthTextField.optionArray[monthTextField.selectedIndex!]
       
        monthTextField.didSelect { (selectedText , index ,id) in
            let year = Calendar.current.component(.year, from: Date())
            let month = index + 1
            
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = 1
            
            // Create date from components
            let userCalendar = Calendar.current // user calendar
            let someDateTime = userCalendar.date(from: dateComponents)
            
            self.monthlyCalendar.select(someDateTime, scrollToDate: true)
            
            let numberOfDays = self.calendarViewTextField.selectedIndex == 0 ? 1 : 7
            
//            if self.viewModel.currentSelectedData != nil {
//                self.setupCalendarViewWithSelectedData()
//                return
//            }
            
            let eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: self.events1)
            
            self.weeklyDailyCalendar.setupCalendar(numOfDays: numberOfDays, setDate: someDateTime!, allEvents: eventsByDate, scrollType: .pageScroll)
            
            //self.weeklyDailyCalendar.select(someDateTime)
            
        }
        
    }
    
//    private func setupCalendarViewWithSelectedData() {
//        guard let selectedData = viewModel.currentSelectedData else { return }
//        weeklyDailyCalendar.setupCalendar(numOfDays: selectedData.numOfDays,
//                                       setDate: selectedData.date,
//                                       allEvents: viewModel.eventsByDate,
//                                       scrollType: selectedData.scrollType,
//                                       firstDayOfWeek: selectedData.firstDayOfWeek)
//        weeklyDailyCalendar.updateFlowLayout(JZWeekViewFlowLayout(hourGridDivision: selectedData.hourGridDivision))
//    }
    
    func setCalendarViewDropDown(){
        events1.removeAll()
        getWeekEvents()
        
        
        let eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: self.events1)
        
        var currentSelectedData: OptionsSelectedData!
        calendarViewTextField.optionArray = ["Daily View","Weekly View","Monthly View"]
        calendarViewTextField.selectedIndex = 2
        monthlyCalendar.scope = .month
        
        calendarViewTextField.text = calendarViewTextField.optionArray[calendarViewTextField.selectedIndex!]
        
        weeklyDailyCalendar.setupCalendar(numOfDays: 7, setDate: Date(), allEvents: eventsByDate , scrollType: .pageScroll)
        
        calendarViewTextField.didSelect { (selectedText , index ,id) in
            
            let year = Calendar.current.component(.year, from: Date())
            let month = self.monthTextField.selectedIndex! + 1
            
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = 1
            
            // Create date from components
            let userCalendar = Calendar.current // user calendar
            let someDateTime = userCalendar.date(from: dateComponents)
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            switch (index){
            case 0:
               

                UIView.animate(withDuration: 0.3) {
                    self.dayHeaderView.layer.cornerRadius = 20
                    
                    self.dayHeaderView.layer.shadowPath =
                          UIBezierPath(roundedRect: self.dayHeaderView.bounds,
                          cornerRadius: self.dayHeaderView.layer.cornerRadius).cgPath
                    self.dayHeaderView.layer.shadowColor = UIColor.black.cgColor
                    self.dayHeaderView.layer.shadowOpacity = 0.5
                    self.dayHeaderView.layer.shadowOffset = CGSize(width: 3, height: 3)
                    self.dayHeaderView.layer.shadowRadius = 0
                    self.dayHeaderView.layer.masksToBounds = false
      
                    let now = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "eeee, MMMM d"
                    self.dayDateLabel.text = dateFormatter.string(from: now)
                    
                    self.dayHeaderView.isHidden = false
                    self.weeklyDailyCalendar.setupCalendar(numOfDays: 1, setDate: Date(), allEvents: eventsByDate, scrollType: .pageScroll)
                    self.weeklyDailyCalendar.alpha = 1
                    self.monthlyCalendar.alpha = 0
                    self.newView.isHidden = false
                    

            
                    print("im in daily view")
                    
                }
                break
            case 1:
                self.dayHeaderView.isHidden = true

                UIView.animate(withDuration: 0.3) {
                    self.weeklyDailyCalendar.setupCalendar(numOfDays: 7, setDate: Date(), allEvents: eventsByDate, scrollType: .pageScroll)
                    self.weeklyDailyCalendar.alpha = 1
                    self.monthlyCalendar.alpha = 0
                    self.newView.isHidden = true
                }
                break
            case 2:
                self.dayHeaderView.isHidden = true

                UIView.animate(withDuration: 0.3) {
                    self.weeklyDailyCalendar.alpha = 0
                    self.monthlyCalendar.alpha = 1
                    self.newView.isHidden = true
                }
                break
            default: break
            }
        }
        
    }
    
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
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return (allDoneDates.contains(self.dateFormatter1.string(from: date))) ? lightGreenColor : nil
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        if allDoneDates.contains(self.dateFormatter1.string(from: date)){
//            return "Osama gghhjh hjhjhj hjjh"
//        }else{
        
            return nil
        //}
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 2
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        if self.allDoneDates.contains(dateString) {
            return 1
        }
        return 0
    }
    
    func getdata(){
        let db = Firestore.firestore()
        let userid = Auth.auth().currentUser!.uid
        let docRef = db.collection("calendar").document("\(userid)")
        
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.titlearray = document["title"] as! [String]
            } else {
                print("Document does not exist")
            }
        }

    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func getWeekEvents(){
        var titles : [String] = []
        var startDates : [String] = []
        var endDates : [String] = []
        var discriptions : [String] = []
        let eventStore = EKEventStore()
        
        
        eventStore.requestAccess(to: .event, completion: {(accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                print("Access Has Been Granted")
            }
            else {
                print("Change Settings to Allow Access")
            }
        })
        
        
        let calendars = eventStore.calendars(for: .event)
        let oneMonthAgo = NSDate(timeIntervalSinceNow: -120*24*3600)
        let oneMonthAfter = NSDate(timeIntervalSinceNow: +120*24*3600)
        //let calenderid = [] as [String]
        for calendar in calendars {
            let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
            
            let events = eventStore.events(matching: predicate)
            for event in events {
                titles.append(event.title)
                discriptions.append("")
                let startdate = event.startDate
                //let extractStartDate = startdate.prefix(19)
                
                let enddate = event.endDate
                //let extractEndDate = enddate.prefix(19)
                
                //startDates.append(String(extractStartDate))
                //endDates.append(String(extractEndDate))
                
                let newEvent =
                    DefaultEvent(id: "0", title: "\(event.title!)", startDate: startdate! , endDate: enddate!)
                events1.append(newEvent)
            }
            
            var startDateArray1 = [String]()
            for i in startDates {
                let string = i.prefix(10)
                let newString = string.replacingOccurrences(of: "-", with: "/", options: .literal, range: nil)
                startDateArray1.append(newString)
            }
            
            
            
            UserDefaults.standard.set(titles, forKey: "titleArray")
            UserDefaults.standard.set(startDateArray1, forKey: "StartDate")
            
        }
    }
    
    
    
    
}



extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
