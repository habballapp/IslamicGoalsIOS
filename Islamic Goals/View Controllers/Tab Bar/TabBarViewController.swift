//
//  TabBarViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 24/10/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import AudioToolbox

class TabBarViewController: UITabBarController {

    let arrayOfImageNameForUnSelectedState = ["home","calendar","","bar-chart","user"]
    let arrayOfImageNameForSelectedState = ["home-s","calendar-s","","bar-chart-s","user-s"]

    //var window:UIWindow?
    override func viewDidLoad() {
        super.viewDidLoad()
                
       // let paddingBottom : CGFloat = 20.0

        let buttonImage = UIImage.init(named: "plus1")
        let button = UIButton(type: .custom)
//        button.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin]
//        button.frame = CGRect(x: 0.0, y: 0.0, width: (buttonImage?.size.width)! * 1.75, height: (buttonImage?.size.height)! * 1.75)
        button.frame = CGRect(x: (self.view.bounds.width / 2)-25, y: 4, width: (buttonImage?.size.width)! * 1.75, height: (buttonImage?.size.height)! * 1.75)
        button.clipsToBounds = true
        button.setBackgroundImage(buttonImage, for: .normal)
        button.setBackgroundImage(buttonImage, for: .selected)
        button.setBackgroundImage(buttonImage, for: .highlighted)
        button.layer.borderWidth = 0.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = button.frame.height 
        button.dropShadow()
    
//        let rectBoundTabbar = self.tabBar.bounds
//        let xx = rectBoundTabbar.midX
//        let yy = rectBoundTabbar.midY - paddingBottom
//        button.center = CGPoint(x: xx, y: yy)

        self.tabBar.addSubview(button)
        self.tabBar.bringSubviewToFront(button)
//        self.tabBar.items![2].isEnabled = false
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
                let imageNameForUnselectedState = arrayOfImageNameForUnSelectedState[i]

                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
            }
        }

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: midGreenColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: peachColor], for: .selected)

    }
    
   // override func viewDidDisappear(_ animated: Bool) {
        deinit {
            self.dismiss(animated:true, completion: nil)

        }
    //}
    
    @objc func handleTouchTabbarCenter(sender: UIButton!) {
        
        if self.selectedIndex == 2 {
            
            if let topVC = UIApplication.getTopViewController() {
                if topVC is AddViewController {
                    //do nothing
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                    vc.selectedIndex = 0
                    vc.view.backgroundColor = .clear
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: false, completion: nil)
                }
                else{
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                    vc.selectedIndex = 2
                    vc.view.backgroundColor = .clear
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
            
            
        }else{
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.selectedIndex = 2
        }
        
        
    }
    
    
//    @IBAction func plusPressed(_ sender: Any) {
//        
////        button.addTarget(self, action: #selector(handleTouchTabbarCenter), for: .touchUpInside)
//    }
//    
//    
    
}

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
