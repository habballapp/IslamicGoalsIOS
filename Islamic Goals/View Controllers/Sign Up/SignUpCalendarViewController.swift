//
//  SignUpCalendarViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 19/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import FirebaseMessaging

class SignUpCalendarViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var iphoneCalendarImage: UIImageView!
    @IBOutlet weak var googleCalendarImage: UIImageView!
    
    var emailAddress = String()
    var password = String()
    var fullName = String()
    let locationManager = CLLocationManager() // create Location Manager object
    var latitude : Double?
    var longitude : Double?
    var date = Date()
    let formatter = DateFormatter()



    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 25
        createAccountButton.layer.cornerRadius = 25
        iphoneCalendarImage.layer.cornerRadius = 25
        googleCalendarImage.layer.cornerRadius = 25
        
        iphoneCalendarImage.layer.borderColor = darkGreenColor.cgColor
        googleCalendarImage.layer.borderColor = darkGreenColor.cgColor
        iphoneCalendarImage.layer.borderWidth = 1.0
        googleCalendarImage.layer.borderWidth = 1.0
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        // You will need to update your .plist file to request the authorization
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        // set the value of lat and long
        latitude = location.latitude
        longitude = location.longitude
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goAhead(_ sender: Any) {
        let user_location: [String: Any] = [
            "latitude": latitude ?? 0,
            "longitude": longitude ?? 0,
        ]
        
        
        let habitArray = [String: Any]()
        let type = "iOS"
        
        let seconds = TimeZone.current.secondsFromGMT()
        let hours = seconds/3600
        let minutes = abs(seconds/60) % 60
        let GMT = String(format: "%+.2d:%.2d", hours, minutes)
        
        let token = Messaging.messaging().fcmToken
        let timestamp: [String: Any] = [
            " .sv": "timestamp"
            ]
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            CustomToast.showNegativeMessage(message: signOutError.localizedDescription)
            print ("Error signing out: %@", signOutError)
        }
                
        Auth.auth().createUser(withEmail: self.emailAddress, password: self.password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                CustomToast.showNegativeMessage(message: error.localizedDescription)
              

                return
                
            }
            UserDatabase.checkUserExsistence(userId: (authResult?.user.uid)!, handleFinish: { (exists:Bool) in
                if !exists {
                    self.formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let dateString = self.formatter.string(from: self.date)
                    print(dateString)
                    let userData = UserDatabase.init(created_at: "\(dateString)"
                        , account_type: "EMAIL",
                          email: self.emailAddress,
                          name: self.fullName,
                          user_id: (authResult?.user.uid)!,
                          Record1: 0,Record2: 0,Record3: 0,Record4: 0,
                          user_location: user_location, timestamp: timestamp, ReminderDone: 0, Record1_Day: "", Update_TimeStamp: "", ReminderDone_Day : "", Update_Rem_TimeStamp: "", token: token!, check: true, GMT: GMT, habitArray: habitArray,ReminderNotDone: 0, type: type)
                    userData.addUserDatabase()
                    UserDefaults.standard.set(self.emailAddress, forKey: "userEmail")
                    UserDefaults.standard.set(self.fullName, forKey: "userName")
                    UserDefaults.standard.set((authResult?.user.uid)!, forKey: "userId")
                    
                    UserManager.shared.isUserLoggedIn = true
                    UserManager.shared.userDetails = userData
                                            
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
                    let navigationController = UINavigationController(rootViewController: homeViewController)
                    navigationController.isNavigationBarHidden = true
                    
                    appdelegate.window!.rootViewController = navigationController
                    self.performSegue(withIdentifier: "gotoTabBar", sender: self)

                    
                }
            })
        }
        
    }
}
