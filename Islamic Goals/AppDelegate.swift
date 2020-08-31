//
//  AppDelegate.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 18/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import Toast_Swift
import GoogleAPIClientForREST
import CoreLocation
import FirebaseMessaging



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate,CLLocationManagerDelegate {
    
   override init() {
           FirebaseApp.configure()
   }

    private let scopes = [kGTLRAuthScopeCalendar]
    private let service = GTLRCalendarService()
    let locationManager = CLLocationManager() // create Location Manager object
    var latitude : Double?
    var longitude : Double?
    var Record1 = 0.0
    var Record2 = 0.0
    var Record3 = 0.0
    var Record4 = 0.0
    var saveDate = ""
    var Record1Day = ""
    var Update_TimeStamp = ""
    var ReminderDone_Day = ""
    var ReminderDone = 0.0
    var ReminderNotDone = 0.0
    var Update_Rem_TimeStamp = ""
    
    var habitArray = [String: Bool]()
    
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        // set the value of lat and long
        latitude = location.latitude
        longitude = location.longitude
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        let user_location: [String: Any] = [
            "latitude": 0,
            "longitude": 0,
            ]
        
        let seconds = TimeZone.current.secondsFromGMT()
        let hours = seconds/3600
        let minutes = abs(seconds/60) % 60
        let GMT = String(format: "%+.2d:%.2d", hours, minutes)
        
        let token = Messaging.messaging().fcmToken
        let timestamp: [String: Any] = [
            ".sv": "timestamp",
            ]
        // ...
        if (error) != nil {
            print("An error occured during Google Authentication")
            CustomToast.showNegativeMessage(message: error!.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        self.service.authorizer = user.authentication.fetcherAuthorizer()
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        var date = Date()
        Auth.auth().signIn(with: credential) { (user, error) in
            if (error) != nil {
                CustomToast.showNegativeMessage(message: error!.localizedDescription)
                print("Google Authentification Fail")
            } else {
                
                
                UserDatabase.getUserObject(userId: (user?.user.uid)!, handleFinish: { (exists, userDatabase) in
                    
                    let locationManager1 = CLLocationManager()
                    func locationManager1(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
                        // set the value of lat and long
                        self.latitude = location.latitude
                        self.longitude = location.longitude
                        
                    }
                    
                    if let latitude1 =  self.latitude{
                        self.latitude = latitude1
                        self.longitude = self.longitude! + 0
                    }else{
                        self.latitude = 0.0
                        self.longitude = 0.0
                    }
                    
                    let user_location: [String: Any] = [
                        "latitude": self.latitude,
                        "longitude": self.longitude,
                        ]
                    //let Record1_Day = ""
                    
                    let habitArray = [String: Any]()
                    
                    if !exists {
                        let userData = UserDatabase.init(created_at: "\(date)"
                            , account_type: "GOOGLE", email: (Auth.auth().currentUser?.providerData[0].email)!, name: (user?.user.displayName)!,
                              user_id: (user?.user.uid)!,Record1: 0,Record2: 0,Record3: 0,Record4: 0,
                              user_location: user_location,timestamp: timestamp,ReminderDone: 0, Record1_Day : "", Update_TimeStamp: "", ReminderDone_Day: "", Update_Rem_TimeStamp: "",token: token!, check: true, GMT: GMT,habitArray: habitArray, ReminderNotDone: 0, type: "iOS")
                        userData.addUserDatabase()
                        UserDefaults.standard.set(Auth.auth().currentUser?.providerData[0].email, forKey: "userEmail")
                        UserDefaults.standard.set(user?.user.displayName, forKey: "userName")
                        UserDefaults.standard.set(user?.user.uid, forKey: "userId")
                        UserManager.shared.isUserLoggedIn = true
                        UserManager.shared.userDetails = userData
                    }
                    else if let userDatabase = userDatabase {
                        UserDefaults.standard.set(userDatabase.email, forKey: "userEmail")
                        UserDefaults.standard.set(userDatabase.name, forKey: "userName")
                        UserDefaults.standard.set(userDatabase.user_id, forKey: "userId")
                        UserManager.shared.isUserLoggedIn = true
                        UserManager.shared.userDetails = userDatabase
                    }
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
                    let navigationController = UINavigationController(rootViewController: homeViewController)
                    navigationController.isNavigationBarHidden = true
                    
                    appdelegate.window!.rootViewController = navigationController
                    navigationController.popToRootViewController(animated: true)
                }
                )
                print("Google Authentification Success")
                //                GoogleCalendar.fetchEvents(userId: (user?.user.uid)!, service: self.service, delegate: self)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        var style = ToastStyle()
        style.messageColor = midGreenColor
        ToastManager.shared.style = style
        
     
        
        //getData()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        
        
        if UserDefaults.standard.value(forKey: "userId") != nil {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
            let navigationController = UINavigationController(rootViewController: homeViewController)
            navigationController.isNavigationBarHidden = true
            
            appdelegate.window!.rootViewController = navigationController
        }
        else {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "pageBarVC") as! PageViewController
            
            let navigationController = UINavigationController(rootViewController: homeViewController)
            navigationController.isNavigationBarHidden = true
            
            appdelegate.window!.rootViewController = navigationController
        }
        
        
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        let token = Messaging.messaging().fcmToken
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        getData()
        
        let aps = userInfo["aps"] as? NSDictionary
        
        var body = ""
        var title = ""
        
        if let aps = aps {
            let alert = aps["alert"] as! NSDictionary
            body = alert["body"] as! String
            title = alert["title"] as! String
        }
        
        
        let substring = body.prefix(5)
        
        //Habit
        if substring == "Habit"{
            let alertt = UIAlertController(title: "\(title)", message: "Did you perform \(body)?", preferredStyle: .alert)
            alertt.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.habitYesButtonPressed()
                //HomeViewController.getData(HomeViewController)
            }))
            
            alertt.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                self.habitNoButtonPressed()
            }))
            self.window?.rootViewController?.present(alertt, animated: true, completion: nil)
        }
        
        else{
            let alertt = UIAlertController(title: "\(title)", message: "Did you perform \(body)?", preferredStyle: .alert)
            alertt.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.reminderYesButtonPressed()
            }))
            
            alertt.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            self.window?.rootViewController?.present(alertt, animated: true, completion: nil)
        }
        
        
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //
    }
    
    //Notifications
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    
    func getData(){
        let db = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid {
            let docRef = db.collection("users").document("\(uid)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.Record1 = document["Record1"] as! Double
                    self.Record2 = document["Record2"] as! Double
                    self.Record3 = document["Record3"] as! Double
                    self.Record4 = document["Record4"] as! Double
                    self.Record1Day = document["Record1_Day"] as! String
                    self.ReminderDone_Day = document["ReminderDone_Day"] as! String
                    self.ReminderDone = document["ReminderDone"] as! Double
                    self.ReminderNotDone = document["ReminderNotDone"] as! Double
                    self.habitArray = document["habitArray"] as! [String: Bool]
                    
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        
    }
    
    func habitYesButtonPressed(){
        Record2 = Record2 + 1
        
        if Record2 > Record3 {
            Record3 = Record2
        }
        
        Record4 = Record4 + 1
        let date1 = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date1)
        let month = calendar.component(.month, from: date1)
        let year = calendar.component(.year, from: date1)
        
        saveDate = "\(year)/\(month)/\(day)"
        if Record1Day != saveDate {
            Record1 = Record1 + 1
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            let month = date1.monthAsStringg()
            let day = formatter.string(from: date1)
            
            self.habitArray.updateValue(true, forKey: "\(month) \(day)")
            
            ReminderDone = ReminderDone + 1
            ReminderDone_Day = saveDate
            Record1Day = saveDate
        }

        let hour = calendar.component(.hour, from: date1)
        let minute = calendar.component(.minute, from: date1)
        let second = calendar.component(.second, from: date1)
        Update_TimeStamp = "\(day)/\(month)/\(year) at \(hour):\(minute):\(second)"
        saveData()
    }
    
    func habitNoButtonPressed(){
        Record2 = 0
        
        let date1 = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date1)
        let month = calendar.component(.month, from: date1)
        let year = calendar.component(.year, from: date1)
        
        saveDate = "\(year)/\(month)/\(day)"
        if Record1Day != saveDate {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            let month = date1.monthAsStringg()
            let day = formatter.string(from: date1)
            
            self.habitArray.updateValue(false, forKey: "\(month) \(day)")
            
            ReminderNotDone = ReminderNotDone + 1
        }
        
        saveData()
    }
    
    func saveData(){
        let db = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid {
            _ = db.collection("users").document(uid).updateData([
                "Record1" : Record1,
                "Record2" : Record2,
                "Record3" : Record3,
                "Record4" : Record4,
                "Update_TimeStamp" : Update_TimeStamp,
                "Record1_Day" : Record1Day,
                "ReminderDone" : ReminderDone,
                "Update_Rem_TimeStamp" : Update_Rem_TimeStamp,
                "ReminderDone_Day" : ReminderDone_Day,
                "habitArray": habitArray
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
    
    
    func reminderYesButtonPressed(){
        ReminderDone = ReminderDone + 1
        let date1 = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date1)
        let month = calendar.component(.month, from: date1)
        let year = calendar.component(.year, from: date1)
        let hour = calendar.component(.hour, from: date1)
        let minute = calendar.component(.minute, from: date1)
        let second = calendar.component(.second, from: date1)
        Update_Rem_TimeStamp = "\(day)/\(month)/\(year) at \(hour):\(minute):\(second)"
        
        ReminderDone_Day = "\(year)/\(month)/\(day)"
        saveData()
    }
    
}

