//
//  Toast.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 25/10/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import Foundation
import UIKit

class CustomToast
{
    class private func showAlert(backgroundColor:UIColor, textColor:UIColor, message:String)
    {

        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.text = message
        label.font = UIFont(name: "Helvetica Neue", size: 12)
        label.adjustsFontSizeToFitWidth = true

        label.backgroundColor =  backgroundColor //UIColor.whiteColor()
        label.textColor = textColor //TEXT COLOR

        label.sizeToFit()
        label.numberOfLines = 1
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOffset = CGSize(width: 4, height: 3)
        label.layer.shadowOpacity = 0.3
        label.frame = CGRect(x: 0, y: appDelegate.window!.frame.size.height, width: appDelegate.window!.frame.size.width, height: 25)
        label.alpha = 1

        appDelegate.window!.addSubview(label)
        appDelegate.window!.bringSubviewToFront(label)

        var basketTopFrame: CGRect = label.frame;
        basketTopFrame.origin.y = appDelegate.window!.frame.size.height - 25;

        UIView.animate(withDuration
            :2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                label.frame = basketTopFrame
        },  completion: {
            (value: Bool) in
            UIView.animate(withDuration:2.0, delay: 2.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                label.alpha = 0
            },  completion: {
                (value: Bool) in
                label.removeFromSuperview()
            })
        })
    }

    class func showPositiveMessage(message:String)
    {
        showAlert(backgroundColor: UIColor.green, textColor: UIColor.white, message: message)
    }
    class func showNegativeMessage(message:String)
    {
        showAlert(backgroundColor: warningRedColor, textColor: UIColor.white, message: message)
    }
}
