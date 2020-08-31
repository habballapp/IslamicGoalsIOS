//
//  ProfileViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 20/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmaillabel: UILabel!
    @IBOutlet weak var userCard: UIView!
    @IBOutlet weak var lockModeView: UIView!
    @IBOutlet weak var exploreCard: UITableView!
    @IBOutlet weak var settingsCard: UITableView!
    @IBOutlet weak var settingCardView: UIView!
    @IBOutlet weak var exploreCardView: UIView!
    @IBOutlet weak var lockImageView: UIView!
    
    var exploreArray = [String]()
    var exploreDiscriptionArray = [String]()
    var settingsArray = [String]()
    var settingsDiscriptionArray = [String]()
    var username  = ""
    
    let pageData : [[[Any]]] = [[["EXPLORE",greyFontColor,false],["Upgrade to Premium",darkGreenColor,true],["Rate Us",lightGreyOutlineColor,true],["Restore Premium Access",lightGreyOutlineColor,true]],[["SETTINGS",greyFontColor,true],["Get Full Permission",darkGreenColor,true],["Keep App in Order",lightGreyOutlineColor,true],["Keep App in Order",lightGreyOutlineColor,true],["Change Profile Name",lightGreyOutlineColor,true],["Sign Out",darkGreenColor,false]]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCard.layer.cornerRadius = 25
        lockModeView.layer.cornerRadius = 25
        lockModeView.dropShadow()
        lockImageView.layer.cornerRadius = 25
        lockImageView.dropShadow()
        exploreCardView.layer.cornerRadius = 25
        settingCardView.layer.cornerRadius = 25
        userCard.dropShadow()
        exploreCardView.dropShadow()
        settingCardView.dropShadow()
        
        userNameLabel.text = UserManager.shared.userDetails!.name
        userEmaillabel.text = UserManager.shared.userDetails!.email
        
        exploreCard.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: exploreCardView.frame.size.width, height: 1))

        settingsCard.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: settingsCard.frame.size.width, height: 2))
        
        
        
        getProfileScreenData()
        getUsernameData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0{
            return exploreArray.count
        }else{
            return settingsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(tableView.tag+1)", for: indexPath) as! ProfileTableViewCell
        
        if tableView.tag == 0 && indexPath.row < 2{
            cell.bodyLabel.text = exploreArray[indexPath.row]
            cell.bodyLabel.textColor = greyFontColor
        }else if tableView.tag == 0 {
            cell.bodyLabel.text = exploreArray[indexPath.row]
            cell.bodyLabel.textColor = UIColor.gray
        }else if tableView.tag == 1 && indexPath.row < 3{
            cell.bodyLabel.text = settingsArray[indexPath.row]
            cell.bodyLabel.textColor = greyFontColor
        }else{
            cell.bodyLabel.text = settingsArray[indexPath.row]
            cell.bodyLabel.textColor = UIColor.gray
        }
        
//        if (pageData[tableView.tag][indexPath.row][2] as! Bool) {
//            cell.accessoryType = .disclosureIndicator
//        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("table view")
        if (indexPath.row == 1 && tableView.tag == 0){
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "tryPremium") as! TryPremiumViewController
            //vc.selectedIndex = 1
//            vc.view.backgroundColor = .clear
//            vc.modalPresentationStyle = .overCurrentContext
            //self.tabBarController?.tabBar.isHidden = true
            self.present(vc, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "tryPremium", sender: self)
        }
        else if (indexPath.row == settingsArray.count - 1 && tableView.tag == 1){
            print("table view else if")
            signOut()
        }
        else if (indexPath.row == settingsArray.count - 2 && tableView.tag == 1){
            //self.performSegue(withIdentifier: "goToPrivacyScreen", sender: self)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "privacy") as! Privacy_TermsViewController
            //vc.selectedIndex = 1
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .overCurrentContext
            //self.tabBarController?.tabBar.isHidden = true
            self.present(vc, animated: true, completion: nil)
        }
        else if (tableView.tag == 0 && indexPath.row == 0) || (tableView.tag == 1 && indexPath.row == 0) || (tableView.tag == 1 && indexPath.row == 1) || (tableView.tag == 1 && indexPath.row == settingsArray.count - 2){
            // do nothing
        }
        else if tableView.tag == 1 && indexPath.row == 2 {
            let alertController = UIAlertController(title: "Profile Name", message: "", preferredStyle: UIAlertController.Style.alert)
            let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                self.userNameLabel.text = firstTextField.text
                self.username = firstTextField.text!
                self.saveUsernameData()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
                (action : UIAlertAction!) -> Void in })
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter new profile name"
            }
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            if tableView.tag == 0{
                let alert = UIAlertController(title: exploreArray[indexPath.row], message: exploreDiscriptionArray[indexPath.row] , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else{
                let alert = UIAlertController(title: settingsArray[indexPath.row], message: settingsDiscriptionArray[indexPath.row], preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    
    
    func signOut(){
        
        let timestamp: [String: Any] = [
            " .sv": "timestamp",
            ]
        
        print("in signout")
       
        let db = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid {
            _ = db.collection("users").document(uid).updateData([
                "timestamp" : timestamp,
                "check": false,
                "token": ""
            ]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                 //  var isLogin = false
                    print("Document added")
                }
            }
        }
        
        let firebaseAuth = Auth.auth()
        do {
            
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            CustomToast.showNegativeMessage(message: signOutError.localizedDescription)
            print ("Error signing out: %@", signOutError)
            return
        }
        
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userId")
        
        UserManager.shared.isUserLoggedIn = false
        UserManager.shared.userDetails = nil
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "pageBarVC")
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.isNavigationBarHidden = true
        
        appdelegate.window!.rootViewController = navigationController
        navigationController.popToRootViewController(animated: true)

    }
    
    func getSettings (){
        
//        Firestore.firestore().collection("profile_settings").getDocuments(completion: { (snapshot, error) in
//            snapshot!.documents.forEach({ (document) in
//                let Description = document.data()["Description"]
//                let name = document.data()["Name"]
//
//                let alert = UIAlertController(title: name as! String, message: Description as! String, preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//
//                self.present(alert, animated: true)
//            })
//        })
    }
    
    func getProfileScreenData(){
        exploreArray.append("EXPLORE")
        exploreDiscriptionArray.append("")
        exploreArray.append("Upgrade to Premium")
        exploreDiscriptionArray.append("")
        
        settingsArray.append("SETTINGS")
        settingsDiscriptionArray.append("")
        settingsArray.append("Get Full Permission")
        settingsDiscriptionArray.append("")
        settingsArray.append("Change Profile Name")
        settingsDiscriptionArray.append("")
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("profile_settings")
        collectionRef.getDocuments { (querySnapshot, err) in
            if let docs = querySnapshot?.documents {
                for docSnapshot in docs {
                    let type = docSnapshot["Type"] as? String
                    
                    if type == "Explore"{
                        let Name = docSnapshot["Name"] as? String
                        let Text = docSnapshot["Description"] as? String
                        self.exploreArray.append(Name!)
                        self.exploreDiscriptionArray.append(Text!)
                    }else{
                        let Name = docSnapshot["Name"] as? String
                        let Text = docSnapshot["Description"] as? String
                        self.settingsArray.append(Name!)
                        self.settingsDiscriptionArray.append(Text!)
                    }
                   
                    //self.habbitCollectionView.reloadData()
                }
                
                self.settingsArray.append("Privacy & Terms")
                self.settingsDiscriptionArray.append("")
                self.settingsArray.append("Log Out")
                self.settingsDiscriptionArray.append("")
                
                self.exploreCard.reloadData()
                self.settingsCard.reloadData()
            }
        }

    }
    
    func getUsernameData(){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        let docRef = db.collection("users").document("\(uid)")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userNameLabel.text = document["name"] as! String
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func saveUsernameData(){
        let db = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid {
            _ = db.collection("users").document(uid).updateData([
                "name" : username,
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
}





