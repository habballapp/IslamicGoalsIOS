//
//  ScheduleViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 28/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {

    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var dailySelectedView: UIView!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklySelectedView: UIView!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlySelectedView: UIView!
    @IBOutlet weak var monthlyButton: UIButton!
    
    @IBOutlet weak var d1: UIButton!
    @IBOutlet weak var d2: UIButton!
    @IBOutlet weak var d3: UIButton!
    @IBOutlet weak var d4: UIButton!
    @IBOutlet weak var d5: UIButton!
    
    @IBOutlet weak var morningSelectedView: UIView!
    @IBOutlet weak var morningButton: UIButton!
    @IBOutlet weak var afternoonSelectedView: UIView!
    @IBOutlet weak var afternoonButton: UIButton!
    @IBOutlet weak var eveningSelectedView: UIView!
    @IBOutlet weak var eveningButton: UIButton!
    @IBOutlet weak var anytimeSelectedView: UIView!
    @IBOutlet weak var anytimeButton: UIButton!
    
    @IBOutlet weak var numberOfDaysLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDisplay()
        // Do any additional setup after loading the view.
    }
    
    func setDisplay(){
        backgroundCardView.layer.cornerRadius = 25
        backgroundCardView.dropShadow()
        saveButton.layer.cornerRadius = 25
        saveButton.dropShadow()

        setButton(view: dailySelectedView, border: 0)
        setButton(view: dailyButton, border: 1)
        setButton(view: weeklyButton, border: 1)
        setButton(view: weeklySelectedView, border: 0)
        setButton(view: monthlyButton, border: 1)
        setButton(view: monthlySelectedView, border: 0)
        setButton(view: morningButton, border: 1)
        setButton(view: morningSelectedView, border: 0)
        setButton(view: afternoonButton, border: 1)
        setButton(view: afternoonSelectedView, border: 0)
        setButton(view: eveningButton, border: 1)
        setButton(view: eveningSelectedView, border: 0)
        setButton(view: anytimeButton, border: 1, radius: anytimeButton.frame.height / 2)
        setButton(view: anytimeSelectedView, border: 0, radius: anytimeSelectedView.frame.height / 2)
        
        setButton(view: d1, border: 0, radius: 12.5)
        setButton(view: d2, border: 0, radius: 12.5)
        setButton(view: d3, border: 0, radius: 12.5)
        setButton(view: d4, border: 0, radius: 12.5)
        setButton(view: d5, border: 0, radius: 12.5)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dailySelect(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.dailySelectedView.layer.borderWidth = 2
            self.weeklySelectedView.layer.borderWidth = 0
            self.monthlySelectedView.layer.borderWidth = 0
        }
    }
    @IBAction func weeklySelect(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.dailySelectedView.layer.borderWidth = 0
            self.weeklySelectedView.layer.borderWidth = 2
            self.monthlySelectedView.layer.borderWidth = 0
        }
    }
    @IBAction func monthlySelect(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.dailySelectedView.layer.borderWidth = 0
            self.weeklySelectedView.layer.borderWidth = 0
            self.monthlySelectedView.layer.borderWidth = 2
        }
    }
    
    @IBAction func d1Select(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.numberOfDaysLabel.text = "1 day a week"
            self.d1.backgroundColor = lightGreenColor
            self.d2.backgroundColor = .clear
            self.d3.backgroundColor = .clear
            self.d4.backgroundColor = .clear
            self.d5.backgroundColor = .clear
            self.d1.layer.borderWidth = 1
            self.d2.layer.borderWidth = 0
            self.d3.layer.borderWidth = 0
            self.d4.layer.borderWidth = 0
            self.d5.layer.borderWidth = 0
        }
    }
    @IBAction func d2Select(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.numberOfDaysLabel.text = "2 days a week"
            self.d1.backgroundColor = .clear
            self.d2.backgroundColor = lightGreenColor
            self.d3.backgroundColor = .clear
            self.d4.backgroundColor = .clear
            self.d5.backgroundColor = .clear
            self.d1.layer.borderWidth = 0
            self.d2.layer.borderWidth = 1
            self.d3.layer.borderWidth = 0
            self.d4.layer.borderWidth = 0
            self.d5.layer.borderWidth = 0
        }
    }
    @IBAction func d3Select(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.numberOfDaysLabel.text = "3 days a week"
            self.d1.backgroundColor = .clear
            self.d2.backgroundColor = .clear
            self.d3.backgroundColor = lightGreenColor
            self.d4.backgroundColor = .clear
            self.d5.backgroundColor = .clear
            self.d1.layer.borderWidth = 0
            self.d2.layer.borderWidth = 0
            self.d3.layer.borderWidth = 1
            self.d4.layer.borderWidth = 0
            self.d5.layer.borderWidth = 0
        }
    }
    @IBAction func d4Select(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.numberOfDaysLabel.text = "4 days a week"
            self.d1.backgroundColor = .clear
            self.d2.backgroundColor = .clear
            self.d3.backgroundColor = .clear
            self.d4.backgroundColor = lightGreenColor
            self.d5.backgroundColor = .clear
            self.d1.layer.borderWidth = 0
            self.d2.layer.borderWidth = 0
            self.d3.layer.borderWidth = 0
            self.d4.layer.borderWidth = 1
            self.d5.layer.borderWidth = 0
        }
    }
    @IBAction func d5Select(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.numberOfDaysLabel.text = "5 days a week"
            self.d1.backgroundColor = .clear
            self.d2.backgroundColor = .clear
            self.d3.backgroundColor = .clear
            self.d4.backgroundColor = .clear
            self.d5.backgroundColor = lightGreenColor
            self.d1.layer.borderWidth = 0
            self.d2.layer.borderWidth = 0
            self.d3.layer.borderWidth = 0
            self.d4.layer.borderWidth = 0
            self.d5.layer.borderWidth = 1
        }
    }
   
    @IBAction func morningSelect(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.morningSelectedView.layer.borderWidth = 2
            self.afternoonSelectedView.layer.borderWidth = 0
            self.eveningSelectedView.layer.borderWidth = 0
            self.anytimeSelectedView.layer.borderWidth = 0
        }
    }
    @IBAction func afternoonSelect(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.morningSelectedView.layer.borderWidth = 0
            self.afternoonSelectedView.layer.borderWidth = 2
            self.eveningSelectedView.layer.borderWidth = 0
            self.anytimeSelectedView.layer.borderWidth = 0
        }
    }
    @IBAction func eveningSelect(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.morningSelectedView.layer.borderWidth = 0
            self.afternoonSelectedView.layer.borderWidth = 0
            self.eveningSelectedView.layer.borderWidth = 2
            self.anytimeSelectedView.layer.borderWidth = 0
        }
    }
    @IBAction func anytimeSelect(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.morningSelectedView.layer.borderWidth = 0
            self.afternoonSelectedView.layer.borderWidth = 0
            self.eveningSelectedView.layer.borderWidth = 0
            self.anytimeSelectedView.layer.borderWidth = 2
        }
    }
    
    fileprivate func setButton(view:UIView,border:CGFloat,radius:CGFloat = 25){
        view.layer.borderColor = darkGreenColor.cgColor
        view.layer.borderWidth = border
        view.layer.cornerRadius = radius
    }
    
}
