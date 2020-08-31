//
//  util.swift
//  Islamic Goals
//
//  Created by Hamza on 18/08/2020.
//  Copyright © 2020 Matz. All rights reserved.
//

import Foundation
import UIKit

//code responsible for the activity indicator at the login screen


fileprivate var aView: UIView?

extension LoginViewController {

    func showSpinner() {
        aView = UIView.init(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
    
    
}
