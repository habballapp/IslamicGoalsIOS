//
//  SignUpDataViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 19/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit

class SignUpDataViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var backgoundImage: UIImageView!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var emailStatusImage: UIImageView!
    @IBOutlet weak var passwordStatusImage: UIImageView!
    @IBOutlet weak var confirmPasswordStatusImage: UIImageView!
    
    var emailDone = Bool()
    var passwordDone = Bool()
    var confirmPasswordDone = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 25
        nextButton.layer.cornerRadius = 25
        
        // Do any additional setup after loading the view.
        
        emailDone = false
        passwordDone = false
        confirmPasswordDone = false
        
    }
    
    @IBAction func checkEmail(_ sender: Any) {
        UserDatabase.checkEmailExsistence(email: self.emailTextField.text!, handleFinish: { (exists:Bool) in
            if (self.emailTextField.text!.isValidEmail() && !exists){
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
            passwordStatusImage.image = UIImage.init(named: "check copy")
            passwordDone = true
        } else {
            passwordStatusImage.image = UIImage.init(named: "cross")
            passwordDone = false
        }
    }
    
    @IBAction func checkConfimationPassword(_ sender: Any) {
        if (passwordTextField.text! == confirmPasswordTextField.text! && passwordTextField.text!.isValidPassword()){
            confirmPasswordStatusImage.image = UIImage.init(named: "check copy")
            confirmPasswordDone = true
        } else {
            confirmPasswordStatusImage.image = UIImage.init(named: "cross")
            confirmPasswordDone = false
        }

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
    
    @IBAction func goAhead(_ sender: Any) {
        if (emailDone && passwordDone && confirmPasswordDone) {
            self.performSegue(withIdentifier: "dataToLocation", sender: nil)
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dataToLocation" {
            let destinationVC = segue.destination as! SignUpLocationViewController
            destinationVC.emailAddress = emailTextField.text!
            destinationVC.fullName = emailTextField.text!
            destinationVC.password = passwordTextField.text!

        }
    }
    
}
