//
//  Date Helper.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 25/10/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import Foundation

class UserManager {
    
    static let shared = UserManager()

    var isUserLoggedIn = false
    var userDetails : UserDatabase? = nil
    
    init() {
    }
    
}
