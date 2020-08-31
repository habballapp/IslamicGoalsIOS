//
//  HomeViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 25/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import Firebase
import FSCalendar
import FirebaseFirestore
import CoreLocation
import FirebaseMessaging
import EventKit
import GoogleSignIn
import GoogleAPIClientForREST
import Charts

var monthArray = [String]()

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
   
    
    var countxx = 0
    @IBOutlet weak var comingSoonView: UIView!
    
    @IBOutlet weak var verticalUpdateConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var greenButton: UIButton!
    
    var dateArray = [String]()
    var journalDiscriptionArray = [String]()
    var timeStampArray = [String]()
    var recordHeadingArray = [String]()
    
    var reminderTimeArray = [String]()
    var reminderDiscriptionArray = [String]()
    var reminderTypeArray = [String]()
    
    var habitArray = [String: Bool]()
    
    let locationManager = CLLocationManager() // create Location Manager object
    var latitude : Double = 0
    var longitude : Double = 0
    
    var userid: String?
    var count = 0
    var count1 = 1
    var rowCount = 1
    var rowCount1 = 0
    var noOfRows = 0
    
    let color = UIColor(red: 191/255, green: 239/255, blue: 187/255, alpha: 1/0)
    
    var record1 = 0
    var record2 = 0
    var record3 = 0
    var record4 = 0
    var habitTimestamp = ""
    
    var selectedRow = -1
    var db: Firestore!
    var habitsArray = [String]()
    var keyArray = [String]()
    var HabitKey = ""
    
    var date = Date()
    var dateCollection = [String]()
    
    fileprivate lazy var calendarService: GTLRCalendarService? = {
        let service = GTLRCalendarService()
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them
        service.shouldFetchNextPages = true
        // Have the service object set tickets to retry temporary error conditions
        // automatically
        service.isRetryEnabled = true
        service.maxRetryInterval = 15
        
        guard let currentUser = GIDSignIn.sharedInstance().currentUser,
            let authentication = currentUser.authentication else {
                return nil
        }
        
        service.authorizer = authentication.fetcherAuthorizer()
        return service
    }()
    
    
  
    @IBOutlet weak var comingSoonHeader: UILabel!
    
    @IBOutlet weak var scrollView1: UIScrollView!
    @IBOutlet weak var comingSoonCard: UIView!
    @IBOutlet weak var comingSoonOutterCard: UIView!
    @IBOutlet weak var comingSoonImage: UIImageView!
    @IBOutlet weak var comingSoonLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var habbitCollectionView: UICollectionView!
    @IBOutlet weak var backgroundCard: UIView!
    
    @IBOutlet weak var journalCard: UIView!
    @IBOutlet weak var writeJournalButton: UIButton!
    @IBOutlet weak var journalTable: UITableView!
    @IBOutlet weak var journalHeadingLabel: UILabel!
    @IBOutlet weak var journalCardBackground: UIImageView!
    @IBOutlet weak var journalHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var comingSoon: NSLayoutConstraint!
    @IBOutlet weak var journalTableHeight: NSLayoutConstraint!
    @IBOutlet weak var comingSoonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var streakNumberLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var journalHeader: UILabel!
    @IBOutlet weak var Day1: UILabel!
    @IBOutlet weak var Day2: UILabel!
    @IBOutlet weak var Day3: UILabel!
    @IBOutlet weak var Day4: UILabel!
    @IBOutlet weak var Day5: UILabel!
    @IBOutlet weak var Day6: UILabel!
    @IBOutlet weak var Day7: UILabel!
    @IBOutlet weak var Day1Label: UILabel!
    @IBOutlet weak var Day2Label: UILabel!
    @IBOutlet weak var Day3Label: UILabel!
    @IBOutlet weak var Day4Label: UILabel!
    @IBOutlet weak var Day5Label: UILabel!
    @IBOutlet weak var Day6Label: UILabel!
    @IBOutlet weak var Day7Label: UILabel!
    
    
    
    
    
    var currentStreakEntry = PieChartDataEntry(value: 0)
    var longestStreakEntry = PieChartDataEntry(value: 0)
    var streakEnteries = [PieChartDataEntry]()
    
    let journalKeys = HomePageJournalData.map {($0.key)}
    let allDoneDates = ["2019/11/08","2019/07/06","2019/07/17", "2015/11/28", "2015/12/21"]
    let someDoneDates = ["2019/11/18", "2019/11/16", "2019/07/20", "2019/07/03"]
    
    

    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        scrollView1.flashScrollIndicators()
        
        pieChart.animate(xAxisDuration: 1.4, easing: .none)
        updateViewConstraints()
        setDisplay()
        getHeadingsData()
        getStreakData()
        getTotalReminder()
        getData()
        updateStreakEntry()

//        Day1.layer.borderColor = lightGreenColor.cgColor
//        Day2.layer.borderColor = lightGreenColor.cgColor
//        Day3.layer.borderColor = lightGreenColor.cgColor
//        Day4.layer.borderColor = lightGreenColor.cgColor
//        Day5.layer.borderColor = lightGreenColor.cgColor
//        Day6.layer.borderColor = lightGreenColor.cgColor
//        Day7.layer.borderColor = lightGreenColor.cgColor
        
        pieChart.delegate = self as? ChartViewDelegate
        
        habbitCollectionView.delegate = self
        habbitCollectionView.dataSource = self
    }
    
   
    
    
    
   
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
       
        //journalTable.layoutIfNeeded()
        //journalHeightConstraint.constant = (journalTable.contentSize.height)
        
        count = 0
        count1 = 1
        rowCount = 1
        rowCount1 = 0
        getCalendarData()
        getGoogleCalendarData()
        getHabbitData()
        updateToken()
        getData()
        
        let last7Days = Date.getDates(forLastNDays: 6)
        for (_,value) in last7Days.enumerated() {
            let substring = value.prefix(2)
            dateCollection.append(String(substring))
        }
        
        Day1Label.text = "\(monthArray[0]) \(dateCollection[0])"
        Day2Label.text = "\(monthArray[1]) \(dateCollection[1])"
        Day3Label.text = "\(monthArray[2]) \(dateCollection[2])"
        Day4Label.text = "\(monthArray[3]) \(dateCollection[3])"
        Day5Label.text = "\(monthArray[4]) \(dateCollection[4])"
        Day6Label.text = "\(monthArray[5]) \(dateCollection[5])"
        Day7Label.text = "\(monthArray[6]) \(dateCollection[6])"
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        // You will need to update your .plist file to request the authorization
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            setUserData()
        }
        
        
        if countxx == 1 {
        
            updateTheConstraints(countxx: countxx)
        }
        
    }
    
    func updateTheConstraints(countxx: Int) {
        let heightConstraint = NSLayoutConstraint(item: comingSoonCard, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 0)
              view.addConstraints([heightConstraint])
              let frm: CGRect = comingSoonOutterCard.frame
              let xPosition = self.backgroundCard.frame.origin.x
              
              let frm1 = journalCard.frame.origin.y - comingSoonOutterCard.frame.height
              let xPosition1 = self.journalCard.frame.origin.x
              
              UIView.animate(withDuration: 1.0, animations: {
                  self.backgroundCard.frame = CGRect(x: xPosition, y: frm.origin.y + 5, width: self.backgroundCard.frame.width, height: self.backgroundCard.frame.height)
              })
              
              UIView.animate(withDuration: 1.0, animations: {
                  self.journalCard.frame = CGRect(x: xPosition1, y: frm1 - 10, width: self.journalCard.frame.width, height: self.journalCard.frame.height)
              })
              super.updateViewConstraints()
    }
    
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        count = 0
        count1 = 0
        rowCount = 0
        rowCount1 = 0
        noOfRows = 0
        dateArray.removeAll()
        journalDiscriptionArray.removeAll()
        reminderDiscriptionArray.removeAll()
        reminderTimeArray.removeAll()
        habitsArray.removeAll()
            }
    
    @objc func update() {
//        getStreakData()
        let last7Days = Date.getDates(forLastNDays: 6)
        for (_,value) in last7Days.enumerated() {
            let substring = value.prefix(2)
            dateCollection.append(String(substring))
        }
        
        for (_,value) in habitArray.reversed().enumerated() {
            
            for (j,_) in monthArray.enumerated(){
                if "\(monthArray[j]) \(dateCollection[j])" == value.0{
                    //print("Value of i is \(i)")
                    if value.1 == true {
                        if j == 0{
                            Day1.backgroundColor = color
                        }else if j == 1{
                            Day2.backgroundColor = color
                        }else if j == 2{
                            Day3.backgroundColor = color
                        }else if j == 3{
                            Day4.backgroundColor = color
                        }else if j == 4{
                            Day5.backgroundColor = color
                        }else if j == 5{
                            Day6.backgroundColor = color
                        }else if j == 6{
                            Day7.backgroundColor = color
                        }
                    }else{
                        
                    }
                }
            }
        }
    }
    
    func updateStreakEntry(){
        
        print("im in updateStreakEntry")
        let chartDataSet = PieChartDataSet(entries: streakEnteries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [lightGreenColor,lightGreyOutlineColor]
        chartDataSet.colors = colors
        
        let formatter:ChartFormatter = ChartFormatter()
        chartData.setValueFormatter(formatter)
        
        pieChart.data = chartData
        pieChart.animate(xAxisDuration: 1.4, easing: .none)
        pieChart.legend.enabled = false
        pieChart.holeRadiusPercent = 0.8
        pieChart.isUserInteractionEnabled = false
    }
    
    @IBAction func ProgressPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        //self.definesPresentationContext = true
        vc.selectedIndex = 3
        vc.view.backgroundColor = .clear
        vc.modalPresentationStyle = .overCurrentContext
        //vc.tabBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.present(vc, animated: true, completion: nil)

    }
    
    public class ChartFormatter: NSObject, IValueFormatter{
        public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            return ""
        }
    }
    
    
    func setUserData () {
        let user_location: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude,
            ]
        let token = Messaging.messaging().fcmToken
        let timestamp: [String: Any] = [
            ".sv": "timestamp"
            ]
        let seconds = TimeZone.current.secondsFromGMT()
        let hours = seconds/3600
        let minutes = abs(seconds/60) % 60
        let GMT = String(format: "%+.2d:%.2d", hours, minutes)
        
        let userEmail = UserDefaults.standard.value(forKey: "userEmail") as! String
        let userName = UserDefaults.standard.value(forKey: "userName") as! String
        let userID = UserDefaults.standard.value(forKey: "userId") as! String
        let date = Date()
        
        let habitArray = [String: Any]()
        //let Record1_Day = ""
        
        UserManager.shared.isUserLoggedIn = true
        UserManager.shared.userDetails = UserDatabase.init(created_at: "\(date)", account_type: "", email: userEmail, name: userName, user_id: userID,Record1: 0,Record2: 0,Record3: 0,Record4: 0,
                                                           user_location: user_location,timestamp: timestamp, ReminderDone: 0, Record1_Day : "" ,Update_TimeStamp : "", ReminderDone_Day: "", Update_Rem_TimeStamp: "",token: token! , check: true,  GMT: GMT,habitArray: habitArray,ReminderNotDone: 0,type: "iOS")
        
        UserDatabase.getUserObject(userId: userID) { (exists, user) in
            if (exists){
                UserManager.shared.userDetails = user
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        // set the value of lat and long
        latitude = location.latitude
        longitude = location.longitude
        
    }
    
    
    
    
    func setDisplay(){
        comingSoonCard.layer.cornerRadius = 25
        comingSoonCard.dropShadow()
        
        journalCard.layer.cornerRadius = 25
        //journalCardBackground.layer.cornerRadius = 25
        writeJournalButton.layer.cornerRadius = 25
        //journalCard.dropShadow()
        
        habbitCollectionView.layoutIfNeeded()
        backgroundCard.layer.cornerRadius = 25
        backgroundCard.dropShadow()
        
        mainView.layer.cornerRadius = 25
        mainView.dropShadow()
        
        Day1.layer.cornerRadius = 10
        //Day1.layer.borderWidth = 1
        Day2.layer.cornerRadius = 10
        //Day2.layer.borderWidth = 1
        Day3.layer.cornerRadius = 10
        //Day3.layer.borderWidth = 1
        Day4.layer.cornerRadius = 10
        //Day4.layer.borderWidth = 1
        Day5.layer.cornerRadius = 10
        //Day5.layer.borderWidth = 1
        Day6.layer.cornerRadius = 10
       // Day6.layer.borderWidth = 1
        Day7.layer.cornerRadius = 10
        //Day7.layer.borderWidth = 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if habitsArray.count > 5 {
            return 6
        }
        return habitsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 5{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitCategory", for: indexPath) as! habitCollectionViewCell2
            cell.habitLabel.text = "MORE"
            cell.backgroundCard.layer.cornerRadius = 25
            cell.backgroundCard.layer.borderColor = darkGreenColor.cgColor
            cell.backgroundCard.layer.borderWidth = 1
            cell.backgroundCard.backgroundColor = .white
            cell.backgroundCard.dropShadow()
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitCategory", for: indexPath) as! habitCollectionViewCell2
        cell.habitLabel.text = habitsArray[indexPath.row]
        cell.backgroundCard.layer.cornerRadius = 25
        cell.backgroundCard.layer.borderColor = darkGreenColor.cgColor
        cell.backgroundCard.layer.borderWidth = 1
        cell.backgroundCard.backgroundColor = .white
        cell.backgroundCard.dropShadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: habbitCollectionView.frame.width * 0.45, height: habbitCollectionView.frame.width * 0.45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 5{
            self.performSegue(withIdentifier: "goToAllHabits", sender: self)
        }else{
            selectedRow = indexPath.row
            self.performSegue(withIdentifier: "showSpecificHabbitCategory", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSpecificHabbitCategory" {
            let destinationVC = segue.destination as! habbitSpecificViewController
            print("the selected row in  home view controller is")
            print(selectedRow)
            destinationVC.specificHabbit = habitsArray[selectedRow]
            destinationVC.key = keyArray[selectedRow]
            
        }
    }
    
    override func updateViewConstraints() {
        journalTable.layoutIfNeeded()
//        journalTableHeight.constant = (journalTable.contentSize.height)
        //reminderTableHeight.constant = (reminderTableHeight.contentSize.height)
        super.updateViewConstraints()
    }
    

   
    
    
   
    
    @IBAction func writeJournalButton(_ sender: Any) {
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dateArray.count == 0{
                return 1
        }else{
                updateViewConstraints()
                return 1
            }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        journalHeightConstraint.constant = journalTable.contentSize.height
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.noOfRows == 0{
            return 1
        }
        if self.noOfRows == 1 {
            return 1
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        //headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        //headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if noOfRows == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "journalBody", for: indexPath) as! journalHomeBodyTableViewCell
            updateViewConstraints()
            cell.bodyTextLabel.text = "No Journal here! Please Add one"

            count1 = count1 + 1
            return cell
        
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "journalBody", for: indexPath) as! journalHomeBodyTableViewCell
            updateViewConstraints()
            cell.bodyTextLabel.text = "\(journalDiscriptionArray[indexPath.section])"

            count1 = count1 + 1
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
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
    
    // MARK: - Other Functions
    func getData(){
        db = Firestore.firestore()
        userid = Auth.auth().currentUser?.uid
        let collectionRef = db.collection("users").document(Auth.auth().currentUser!.uid).collection("AddJournal")
        collectionRef.order(by: "timestamp",descending: true).getDocuments { (querySnapshot, err) in
            if let docs = querySnapshot?.documents {
                for docSnapshot in docs {
                    let date = docSnapshot["dateJournal"] as! String
                    let discription = docSnapshot["jDescription"] as! String
                    let time = docSnapshot["timestamp"] as! String


                    print("discription")
                    print(discription)

                    self.dateArray.append(date)
                    self.journalDiscriptionArray.append(discription)
                    self.timeStampArray.append(time)
                    self.noOfRows = self.noOfRows + 1
                    self.journalTable.reloadData()
                }
            }
        }
    }
    
//    func getReminderData(){
//        db = Firestore.firestore()
//        userid = (Auth.auth().currentUser?.uid)!
//        let collectionRef = db.collection("users/\(userid)/AddReminder/")
//        collectionRef.order(by: "timestamp",descending: true).getDocuments { (querySnapshot, err) in
//            if let docs = querySnapshot?.documents {
//                for docSnapshot in docs {
//                    let type = docSnapshot["TypeOfReminder"] as! String
//                    let discription = docSnapshot["Name"] as! String
//
//
//                    if type != "WithoutTimer" {
//                        let time = docSnapshot["Time"] as! String
//                        self.reminderTimeArray.append(time)
//                        self.reminderTypeArray.append(type)
//                        self.reminderDiscriptionArray.append(discription)
//                    }else{
//                        let time = "Without Timer"
//                        self.reminderTimeArray.append(time)
//                        self.reminderTypeArray.append(type)
//                        self.reminderDiscriptionArray.append(discription)
//                    }
//
//
//                    self.reminderTableView.reloadData()
//                }
//            }
//        }
//    }
    
    func getHeadingsData(){
        db = Firestore.firestore()
        let collectionRef = db.collection("home")
        collectionRef.getDocuments { (querySnapshot, err) in
            if let docs = querySnapshot?.documents {
                for docSnapshot in docs {
                    self.comingSoonHeader.text = docSnapshot["Coming_Soon_Heading"] as? String
                    self.comingSoonLabel.text = docSnapshot["Coming_Soon_Text"] as? String
                    self.journalHeader.text = docSnapshot["Reminder_Heading"] as? String
                    if let data = docSnapshot["Journal_Heading"] as? String {
                        self.journalHeadingLabel.text = "\(data)"
                    }
                    
                    if let data = docSnapshot["Journal_Button"] as? String {
                        self.writeJournalButton.setTitle(data, for: .normal)
                    }
                    
                }
            }
        }
    }
    
    func getCalendarData(){
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
        let calenderid = [] as [String]
        for calendar in calendars {
                let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])

                let events = eventStore.events(matching: predicate)
                for event in events {
                    titles.append(event.title)
                    discriptions.append("")
                    let startdate = event.startDate.description
                    let extractStartDate = startdate.prefix(19)
                    
                    let enddate = event.endDate.description
                    let extractEndDate = enddate.prefix(19)
                    
                    startDates.append(String(extractStartDate))
                    endDates.append(String(extractEndDate))
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
        
        
        let db = Firestore.firestore()
        let user_id = Auth.auth().currentUser?.uid
        do {
        _ = db.collection("calendar").document(user_id!).setData([
            "title": titles,
            "start_date": startDates,
            "end_date": endDates,
            "calenderid" : calenderid,
            "description" : discriptions,
        ]){ err in
            if let err = err {
                CustomToast.showNegativeMessage(message: "Error adding document: \(err)")
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
        catch {
        print("Error adding document:")
        }
        
    }
    
    func getGoogleCalendarData(){
//        guard let service = self.calendarService else {
//            return
//        }
//
//        // You can pass start and end dates with function parameters
//        let startDateTime = GTLRDateTime(date: Calendar.current.startOfDay(for: Date()))
//        let endDateTime = GTLRDateTime(date: Date().addingTimeInterval(60*60*24))
//
//        let eventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarId)
//        eventsListQuery.timeMin = startDateTime
//        eventsListQuery.timeMax = endDateTime
//
//        _ = service.executeQuery(eventsListQuery, completionHandler: { (ticket, result, error) in
//            guard error == nil, let items = (result as? GTLRCalendar_Events)?.items else {
//                return
//            }
//
//            if items.count > 0 {
//                print(items)
//                // Do stuff with your events
//            } else {
//                // No events
//            }
//        })
    }
    
    func getHabbitData(){
        db = Firestore.firestore()
        let collectionRef = db.collection("habits")
        collectionRef.getDocuments { (querySnapshot, err) in
            if let docs = querySnapshot?.documents {
                for docSnapshot in docs {
                    let data = docSnapshot["Name"] as? String
                    self.HabitKey = docSnapshot["HabitKey"] as! String
                    self.habitsArray.append(data!)
                    self.keyArray.append(self.HabitKey)
                    self.habbitCollectionView.reloadData()
                }
            }
        }
    }
    
    func updateToken(){
        let token = Messaging.messaging().fcmToken
        let db = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid {
            _ = db.collection("users").document(uid).updateData([
                "token": token,
                "isLogin": true
            ]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                }
            }
        }
    }
    
    
    func getStreakData(){
       print("the value of current streak entry is 1")
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        
        print(uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.currentStreakEntry.value = document["Record2"] as! Double
                self.longestStreakEntry.value = document["Record3"] as! Double

                print("the value of current streak entry is 2")
                print(self.currentStreakEntry)
//                self.completedStreakLabel.text = document["Graph2Text"] as! String
                
                
                
                if self.currentStreakEntry.value == 0 && self.longestStreakEntry.value == 0{
                    self.longestStreakEntry.value = 1
                    self.streakEnteries = [self.currentStreakEntry,self.longestStreakEntry]
                    self.streakNumberLabel.text = "0"
                }else{
                    let greenvalue = (self.currentStreakEntry.value/self.longestStreakEntry.value) * 100
                    self.streakNumberLabel.text = "\(self.currentStreakEntry.value.clean)"
                  
                    self.currentStreakEntry.value = greenvalue
                    self.streakEnteries = [self.currentStreakEntry,self.longestStreakEntry]
                }

                
                self.updateStreakEntry()
                
//                self.habitArray = document["habitArray"] as! [String: Bool]
//
////                let date1 = Date()
////                let formatter = DateFormatter()
////                formatter.dateFormat = "dd"
////                let month = date1.monthAsStringg()
////                let day = formatter.string(from: date1)
//
//               // self.habitArray.updateValue(true, forKey: "\(month) \(day)")
//
//                if let uid = Auth.auth().currentUser?.uid {
//                    _ = db.collection("users").document(uid).updateData([
//                        "habitArray": self.habitArray
//                    ]){ err in
//                        if let err = err {
//                            print("Error adding document: \(err)")
//                        } else {
//                           // print("Document added")
//                        }
//                    }
//                }
                
//                self.updateStreakEntry()
            } else {
                print("Document does not exist")
            }
        }
        
        
    }
    
    func getTotalReminder(){
        let db = Firestore.firestore()
        var count = 0
        UserDefaults.standard.removeObject(forKey: "Frequencey")
        UserDefaults.standard.removeObject(forKey: "Total")
        let userid = Auth.auth().currentUser?.uid
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
            }
            UserDefaults.standard.set(count, forKey: "Total")
        }
    }
    
    func frequencyReminder(frequency: String, habitKey: String, subHabit: String,habitName: String){
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
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    static func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = Calendar.current
        // start with today
        var date = Date()
        
        var arrDates = [String]()
        
        //current date
        date = cal.date(byAdding: Calendar.Component.day, value: 0, to: date)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let month = date.monthAsStringg()
        monthArray.append(month)
        
        let dateString = dateFormatter.string(from: date)
        arrDates.append(dateString)
        
        for _ in 0 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let month = date.monthAsStringg()
            monthArray.append(month)
            
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        return arrDates
    }
    
    
    func monthAsStringg() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
}
