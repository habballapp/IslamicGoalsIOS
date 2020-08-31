//
//  JournalSpecificViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 28/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import Toast_Swift
import Firebase
import FirebaseFirestore

class JournalSpecificViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subheadingLabel: UILabel!
    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var journalTable: UITableView!
    @IBOutlet weak var newJournalView: UIView!
    @IBOutlet weak var newJournal: UITextView!
    @IBOutlet weak var newJournalTodaysDate: UILabel!
    var header = "Journal of Shukr"
    
    var journalData = [String:[String]]()
    var journalKeys = [String]()
    var isDataLoaded = false
    var date = Date()
    var calendar = Calendar.current
    var placeholder = " Start Typing"
    override func viewDidAppear(_ animated: Bool) {
        self.view.makeToastActivity(.center)
        JournalDatabase.getAllJournalOfAUser(currentUser: UserManager.shared.userDetails!) { (exists, data) in
            self.journalData = data
            self.journalKeys = data.map {($0.key)}
            self.view.hideToastActivity()
            self.journalTable.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        newJournalView.isHidden = true
        initialView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        newJournalView.isHidden = true
        newJournal.text = placeholder
        let day = calendar.component(.day, from: date)
        //let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd,  yyyy"
        newJournalTodaysDate.text = dateFormatter.string(from: date)
        initialView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = header
        backgroundCard.layer.cornerRadius = 25
        backgroundCard.dropShadow()
        addButton.layer.cornerRadius = 25
        newJournal.layer.cornerRadius = 25
        
        newJournal.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    
    func getHeadingData(){
         let db = Firestore.firestore()
         let collectionRef = db.collection("journal")
         collectionRef.getDocuments { (querySnapshot, err) in
             if let docs = querySnapshot?.documents {
                 for docSnapshot in docs {
                    self.subheadingLabel.text = "\(docSnapshot["SubHeading"] as! String): "
                 }
             }
         }
     }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Add Journal
    
    @IBAction func addJournalEntry(_ sender: Any) {
        // self.performSegue(withIdentifier: "addJournal", sender: self)
        if newJournalView.isHidden == true {
            newJournalView.isHidden = false
            
            let modelName = UIDevice.current.modelName
            
            if modelName == "1" {
                let heightConstraint = NSLayoutConstraint(item: journalTable, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 225)
                view.addConstraints([heightConstraint])
            }else if modelName == "2" {
                let heightConstraint = NSLayoutConstraint(item: journalTable, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 275)
                view.addConstraints([heightConstraint])
            }else if modelName == "3" {
                let heightConstraint = NSLayoutConstraint(item: journalTable, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300)
                view.addConstraints([heightConstraint])
            }else if modelName == "4" {
                let heightConstraint = NSLayoutConstraint(item: journalTable, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 375)
                view.addConstraints([heightConstraint])
            }else if modelName == "5" {
                let heightConstraint = NSLayoutConstraint(item: journalTable, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 370)
                view.addConstraints([heightConstraint])
            }else {
                let heightConstraint = NSLayoutConstraint(item: journalTable, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
                view.addConstraints([heightConstraint])
            }
            
            
            
        }
        else{
            if UserManager.shared.isUserLoggedIn {
                if newJournal.text != nil && newJournal.text != "" {
                    let currentDateTime = Date()
                    let formatter = DateFormatter()
                    formatter.timeStyle = .none
                    formatter.dateStyle = .long
                    let formatedDate = formatter.string(from: currentDateTime)
                    JournalDatabase.init(dateJournal: formatedDate, jDescription: newJournal.text, timestamp: "\(date)").addJournalDatabase(currentUser: UserManager.shared.userDetails!, handleFinish: { (isAdded) in
                        if (isAdded) {
                            self.navigationController?.popViewController(animated: true)
                            
                        }
                    })
                }
                else {
                    CustomToast.showNegativeMessage(message: "no data is there to add")
                }
            }
            else {
                CustomToast.showNegativeMessage(message: "you are not signed in")
            }
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray || textView.text == placeholder {
            textView.text = nil
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func initialView(){
        let modelName = UIDevice.current.modelName
        if modelName == "1" {
            let heightConstraint = NSLayoutConstraint(item: journalTable, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 350)
            view.addConstraints([heightConstraint])
        }else if modelName == "2" {
            let heightConstraint = NSLayoutConstraint(item: journalTable, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 400)
            view.addConstraints([heightConstraint])
        }else if modelName == "3" {
            let heightConstraint = NSLayoutConstraint(item: journalTable, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 425)
            view.addConstraints([heightConstraint])
        }else if modelName == "4" {
            let heightConstraint = NSLayoutConstraint(item: journalTable, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 500)
            view.addConstraints([heightConstraint])
        }else if modelName == "5" {
            let heightConstraint = NSLayoutConstraint(item: journalTable, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 505)
            view.addConstraints([heightConstraint])
        }else {
            let heightConstraint = NSLayoutConstraint(item: journalTable, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 350)
            view.addConstraints([heightConstraint])
        }
    }
    
    
    // MARK: - Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return journalData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journalData[journalKeys[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalBody", for: indexPath) as! journalHomeBodyTableViewCell
        cell.bodyTextLabel.text = journalData[journalKeys[indexPath.section]]![indexPath.row]
        cell.bodyTextLabel.sizeToFit()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "journalDateHeader") as! journalDateHeaderTableViewCell
        header.dateLabel.text = (journalKeys[section])
        return header.contentView
    }
    
    func getData(){
        let db = Firestore.firestore()
        let collectionRef = db.collection("AddJournal").order(by: "timestamp", descending: true)
        collectionRef.getDocuments { (querySnapshot, err) in
            if let docs = querySnapshot?.documents {
                for docSnapshot in docs {
                    self.headerLabel.text = docSnapshot["Heading"] as? String
                    self.subheadingLabel.text = docSnapshot["SubHeading"] as? String
                }
            }
        }
    }
    
}

public extension UIDevice {
    
    /// pares the deveice name as the standard name
    var modelName: String {
        
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        #endif
        
        switch identifier {
        case "iPhone7,2":                               return "1"
        case "iPhone7,1":                               return "2"
        case "iPhone8,1":                               return "1"
        case "iPhone8,2":                               return "2"
        case "iPhone9,1", "iPhone9,3":                  return "1"
        case "iPhone9,2", "iPhone9,4":                  return "2"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "1"
        case "iPhone10,2", "iPhone10,5":                return "2"
        case "iPhone10,3", "iPhone10,6":                return "3"
        case "iPhone11,2":                              return "3"
        case "iPhone11,4", "iPhone11,6":                return "5"
        case "iPhone11,8":                              return "4"
        case "iPhone12,1":                              return "4"
        case "iPhone12,3":                              return "3"
        case "iPhone12,5":                              return "5"
            
        default:                                        return identifier
        }
    }
    
}
