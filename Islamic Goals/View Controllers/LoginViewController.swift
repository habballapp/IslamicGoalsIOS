//
//  LoginViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 20/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import CoreLocation
import FirebaseMessaging
import FirebaseAuth

class LoginViewController: UIViewController,UITextFieldDelegate,GIDSignInUIDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailStatusImage: UIImageView!
    @IBOutlet weak var passwordStatusImage: UIImageView!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    
    var emailDone = Bool()
    var passwordDone = Bool()
    let locationManager = CLLocationManager() // create Location Manager object
    var latitude : Double?
    var longitude : Double?
    var userID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        cardView.layer.cornerRadius = 25
        nextButton.layer.cornerRadius = 25
        googleButton.layer.cornerRadius = 25
        facebookButton.layer.cornerRadius = 25
        googleButton.layer.borderWidth = 1
        googleButton.layer.borderColor = lightGreyOutlineColor.cgColor
        
        emailDone = false
        passwordDone = false
       self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        // You will need to update your .plist file to request the authorization
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            print(longitude)
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
    
    @IBAction func checkEmail(_ sender: Any) {
        UserDatabase.checkEmailExsistence(email: self.emailTextField.text!, handleFinish: { (exists:Bool) in
            if (self.emailTextField.text!.isValidEmail() && exists){
                self.emailStatusImage.image = UIImage.init(named: "check copy")
                self.emailDone = true
            } else {
                self.emailStatusImage.image = UIImage.init(named: "cross")
                self.emailDone = false
            }
        })
    }
    
    @IBAction func checkPassword(_ sender: Any) {
        if (passwordTextField.text!.isValidPassword()){
//            passwordStatusImage.image = UIImage.init(named: "check copy")
            passwordDone = true
        } else {
            passwordStatusImage.image = UIImage.init(named: "cross")
            passwordDone = false
        }
    }
    
    
    @IBAction func goAhead(_ sender: Any) {
        
        var authorize = "asdv"
        if emailDone && passwordDone {
            self.showSpinner()
        
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { [weak self] user, error in
                guard self != nil else { return }
                if let error = error {
                    self!.passwordStatusImage.image = UIImage.init(named: "cross")
                    self!.passwordDone = false
                    print(error.localizedDescription)
                    return
                }
                let db = Firestore.firestore()
                let uid = Auth.auth().currentUser!.uid
                
                var type = ""
                var check = false
                let docRef = db.collection("users").document("\(uid)")
                               
                               docRef.getDocument { (document, error) in
                                   if let document = document, document.exists {
                                       type = document["type"] as! String
                                    check = document["check"] as! Bool
                               
                
                
                
                print("the value of check is")
                print(check)
                print("the value of authorize is''''''")
                print(authorize)
                if type == "iOS" {
                    if check == true {
                        self?.removeSpinner()
                        let alert = UIAlertController(title: "Info", message: "You are already logged in on another device. Please logout from that to continue the session. Thanks.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self!.present(alert, animated: true, completion: nil)
                        return
                    }else {
                        
                        let db = Firestore.firestore()
                        if let uid = Auth.auth().currentUser?.uid {
                            _ = db.collection("users").document(uid).updateData([
                                "check": true,
                            ]){ err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                 //  var isLogin = false
                                    print("Document added")
                                }
                            }
                        }
                        
                        print("Success")
                        UserDatabase.getUserObject(userId: (user?.user.uid)!, handleFinish: { (exists, userDatabase) in
                            if exists, let userDatabase = userDatabase {
                                UserDefaults.standard.set(userDatabase.email, forKey: "userEmail")
                                UserDefaults.standard.set(userDatabase.name, forKey: "userName")
                                UserDefaults.standard.set(userDatabase.user_id, forKey: "userId")
                                UserDefaults.standard.set(userDatabase.check, forKey: "check")
                                
                                UserManager.shared.isUserLoggedIn = true
                                UserManager.shared.userDetails = userDatabase
                                                        
                                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
                                let navigationController = UINavigationController(rootViewController: homeViewController)
                                navigationController.isNavigationBarHidden = true
                                
                                self?.removeSpinner()
                                appdelegate.window!.rootViewController = navigationController
                                self?.performSegue(withIdentifier: "gotoTabBar", sender: self)
                            }
                        })
                    
                    }
                    
                                  
                }else {
                    self?.removeSpinner()
                    let alert = UIAlertController(title: "Info", message: "You have been registered in this application through Android version, we are still working on migration of data between different platforms. Wait for the next version. Thanks", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self!.present(alert, animated: true, completion: nil)
                    return

                }
        
                               } else {
                                          print("Document does not exist")
                                      }
                                  }
            }
            
        }
        
    }
    
   // func checkUserInfo() -> Bool{
       // if Auth.auth().currentUser != nil {
        //    if Auth.auth().currentUser?.uid == userID {
         //       print("i am in checkUserInfo")
         //       let alert = UIAlertController(title: "Warning", message: "You have already signed in, try logging out from the previous device", preferredStyle: .alert)
          //      alert.addAction(UIAlertAction(title: "enter different credentials", style: .destructive, handler: {action in
                    
            //        self.emailTextField.text = ""
            //        self.passwordTextField.text = ""
                    
              //  }))
             //   alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: {_ in}))
             //   self.present(alert, animated: true, completion: nil)
             //   return false
           // }
           // else {
           //     return true
           // }
       // }
       // return true
   // }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func googleClicked(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebook(_ sender: Any) {
        let user_location: [String: Any] = [
            "latitude": latitude!,
            "longitude": longitude!,
            ]
        let token = Messaging.messaging().fcmToken
        let timestamp: [String: Any] = [
            ".sv": "timestamp",
            ]
        let type = "iOS"
        let isLogin = false
        let seconds = TimeZone.current.secondsFromGMT()
        let hours = seconds/3600
        let minutes = abs(seconds/60) % 60
        let GMT = String(format: "%+.2d:%.2d", hours, minutes)
        
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                CustomToast.showNegativeMessage(message: error.localizedDescription)
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                CustomToast.showNegativeMessage(message: "Failed to get access token")
                return
            }
            
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            var date = Date()
            
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    CustomToast.showNegativeMessage(message: error.localizedDescription)
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                let db = Firestore.firestore()
                let uid = Auth.auth().currentUser!.uid
                var type = ""
                var isLogin = false
                let docRef = db.collection("users").document("\(uid)")
                
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        type = document["type"] as! String
                    } else {
                        print("Document does not exist")
                    }
                }
                
                if type != "iOS"{
                    let alert = UIAlertController(title: "Info", message: "You have been registered in this application through Android version, we are still working on migration of data between different platforms. Wait for the next version. Thanks", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                
                let habitArray = [String: Any]()
                
                UserDatabase.getUserObject(userId: (user?.user.uid)!, handleFinish: { (exists, userDatabase) in
                    if !exists {
                        let userData = UserDatabase.init(created_at: "\(date)"
                            , account_type: "FACEBOOK",
                              email: (Auth.auth().currentUser?.providerData[0].email)!,
                              name: (user?.user.displayName)!,
                              user_id: (user?.user.uid)!,Record1: 0,Record2: 0,Record3: 0,Record4: 0,
                              user_location: user_location,timestamp: timestamp, ReminderDone: 0, Record1_Day : "",Update_TimeStamp: "", ReminderDone_Day: "", Update_Rem_TimeStamp: "", token: token! ,check: true, GMT: GMT, habitArray: habitArray, ReminderNotDone: 0, type: "iOS")
                        userData.addUserDatabase()
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
                    self.performSegue(withIdentifier: "gotoTabBar", sender: self)
                })
                print("Facebook Authentification Success")

            })
            
        }
    }
    
    
}
