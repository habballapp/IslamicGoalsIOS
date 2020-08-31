//
//  LoginSignUpViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 19/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit

class LoginSignUpViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 25
        SignUpButton.layer.cornerRadius = 25
    }
    
}
