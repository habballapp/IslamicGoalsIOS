//
//  AddViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 24/10/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import FirebaseAuth
import JZCalendarWeekView

class AddViewController: UIViewController {

    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var reminderImage: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var habitView: UIView!
    @IBOutlet weak var habitImage: UIImageView!
    @IBOutlet weak var habitLabel: UILabel!
    @IBOutlet weak var journalView: UIView!
    @IBOutlet weak var journalImage: UIImageView!
    @IBOutlet weak var journalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView.backgroundColor = UIColor.white
        reminderView.dropShadow(color: .white, opacity: 1, shadowRadius: 2)
        habitView.dropShadow(color: .white, opacity: 1, shadowRadius: 2)
        journalView.dropShadow(color: .white, opacity: 1, shadowRadius: 2)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        habitView.layer.cornerRadius = 50
        reminderView.layer.cornerRadius = 50
        journalView.layer.cornerRadius = 50
        
//        let firstGesture = UILongPressGestureRecognizer(target: self, action: #selector(firstMethod))
//        //this for 1.5
//        let secondGesture = UILongPressGestureRecognizer(target: self, action: #selector(secondMethod))
//        secondGesture.minimumPressDuration = 1.5
//        firstGesture.delegate = self as? UIGestureRecognizerDelegate
//        secondGesture.delegate = self as? UIGestureRecognizerDelegate
//        self.reminderButton.addGestureRecognizer(firstGesture)
//        self.reminderButton.addGestureRecognizer(secondGesture)
    }
    
//    @objc func firstMethod() {
//        debugPrint("short")
//    }
//
//    @objc func secondMethod() {
//        debugPrint("long")
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
//        return true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        journalView.backgroundColor = UIColor(red: 255 / 255, green: 207 / 255.0, blue: 140 / 181, alpha: 1.0)
        journalImage.backgroundColor = UIColor(red: 255 / 255, green: 207 / 255.0, blue: 140 / 181, alpha: 1.0)
        journalLabel.textColor = UIColor.black
        reminderView.backgroundColor = UIColor(red: 255 / 255, green: 207 / 255.0, blue: 140 / 181, alpha: 1.0)
        reminderImage.backgroundColor = UIColor(red: 255 / 255, green: 207 / 255.0, blue: 140 / 181, alpha: 1.0)
        reminderLabel.textColor = UIColor.black
        habitView.backgroundColor = UIColor(red: 255 / 255, green: 207 / 255.0, blue: 140 / 181, alpha: 1.0)
        habitImage.backgroundColor = UIColor(red: 255 / 255, green: 207 / 255.0, blue: 140 / 181, alpha: 1.0)
        habitLabel.textColor = UIColor.black
    }
    
    @IBAction func journalButtonPressed(_ sender: UIButton) {
        journalView.backgroundColor = UIColor(red: 93 / 255, green: 172 / 255.0, blue: 140 / 255.0, alpha: 1.0)
        journalImage.backgroundColor = UIColor.white
        journalLabel.textColor = UIColor.white
    }
    
    @IBAction func reminderButtonPressed(_ sender: UIButton) {
        reminderView.backgroundColor = UIColor(red: 93 / 255, green: 172 / 255.0, blue: 140 / 255.0, alpha: 1.0)
        reminderImage.backgroundColor = UIColor.white
        reminderLabel.textColor = UIColor.white
    }
    
    @IBAction func calendarButtonPressed(_ sender: UIButton) {
        habitView.backgroundColor = UIColor(red: 93 / 255, green: 172 / 255.0, blue: 140 / 255.0, alpha: 1.0)
        habitImage.backgroundColor = UIColor.white
        habitLabel.textColor = UIColor.white
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        vc.selectedIndex = 1
        vc.view.backgroundColor = .clear
        vc.modalPresentationStyle = .overCurrentContext
        self.tabBarController?.tabBar.isHidden = true
        self.present(vc, animated: true, completion: nil)
        
    }

}
