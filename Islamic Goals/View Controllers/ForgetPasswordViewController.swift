//
//  ForgetPasswordViewController.swift
//  Islamic Goals
//
//  Created by Osama Fahim on 07/07/2020.
//  Copyright © 2020 Matz. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var emailStatusImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    
    var emailDone = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailDone = false
        cardView.layer.cornerRadius = 25
        forgetPasswordButton.layer.cornerRadius = 25

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ForgetButtonPressed(_ sender: UIButton) {
        if emailDone {
            Auth.auth().sendPasswordReset(withEmail: emailText.text!) { error in
                if let error = error {
                    print(error)
                    CustomToast.showNegativeMessage(message: "Something went wrong")
                    return
                }
                CustomToast.showPositiveMessage(message: "Please check your Email")
                
            }
            _ = navigationController?.popViewController(animated: true)
            
        }
    }
    

    @IBAction func EmailCheck(_ sender: UITextField) {
        UserDatabase.checkEmailExsistence(email: self.emailText.text!, handleFinish: { (exists:Bool) in
            if (self.emailText.text!.isValidEmail() && exists){
                self.emailStatusImage.image = UIImage.init(named: "check copy")
                self.emailDone = true
            } else {
                self.emailStatusImage.image = UIImage.init(named: "cross")
                self.emailDone = false
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
