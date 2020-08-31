//
//  TryPremiumViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 20/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit

class TryPremiumViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var premiumButton: UIButton!
    
    @IBOutlet weak var curvedView: UIView! //iboutlet for the curved view in tryPremium screen
    
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    
    @IBOutlet weak var bismillahButton: UIButton!
    
    
    @IBOutlet weak var beneathView1Label: UILabel!
    
    @IBOutlet weak var beneathView2Label: UILabel!
    
    @IBOutlet weak var beneathView3Label: UILabel!
    
    @IBOutlet weak var growMindfulLabel: UILabel!
    
    @IBOutlet weak var goBackButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        cardView?.layer.cornerRadius = 25
        premiumButton?.layer.cornerRadius = 25
        
        cardView?.dropShadow(color: .white, opacity: 1, shadowRadius: 2)
        
        curvedView?.layer.cornerRadius = 25 //curving the borders of the view
        
        
        //the making of bismillah button
        //bismillahButton.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
            bismillahButton.layer.cornerRadius = 15
            bismillahButton.tintColor = UIColor.white
        
        
        //casting the shadow of the labels beneath each view
        beneathView1Label.layer.shadowColor = UIColor.black.cgColor
        beneathView1Label.layer.shadowRadius = 0.0
        beneathView1Label.layer.shadowOpacity = 0.0
        
        beneathView2Label.layer.shadowColor = UIColor.black.cgColor
        beneathView2Label.layer.shadowRadius = 0.0
        beneathView2Label.layer.shadowOpacity = 0.0
               
        beneathView3Label.layer.shadowColor = UIColor.black.cgColor
        beneathView3Label.layer.shadowRadius = 0.0
        beneathView3Label.layer.shadowOpacity = 0.0
               

        
        //now casting the shadow of uiviews inside the stack view in the premium screeen, which involves three main views, so casting shadow on all of them
        firstView.layer.shadowColor = UIColor.black.cgColor
        firstView.layer.shadowOpacity = 1
        firstView.layer.shadowOffset = .zero
        firstView.layer.shadowRadius = 2
        firstView.layer.shadowPath = UIBezierPath( rect: firstView.bounds).cgPath
        firstView.layer.shouldRasterize = true
        firstView.layer.rasterizationScale = UIScreen.main.scale
        
        secondView.layer.shadowColor = UIColor.black.cgColor
        secondView.layer.shadowOpacity = 1
        secondView.layer.shadowOffset = .zero
        secondView.layer.shadowRadius = 2
        secondView.layer.shadowPath = UIBezierPath( rect: firstView.bounds).cgPath
        secondView.layer.shouldRasterize = true
        secondView.layer.rasterizationScale = UIScreen.main.scale
        
        thirdView.layer.shadowColor = UIColor.black.cgColor
        thirdView.layer.shadowOpacity = 1
        thirdView.layer.shadowOffset = .zero
        thirdView.layer.shadowRadius = 2
        thirdView.layer.shadowPath = UIBezierPath( rect: firstView.bounds).cgPath
        thirdView.layer.shouldRasterize = true
        thirdView.layer.rasterizationScale = UIScreen.main.scale
        
      

    }
    
    @IBAction func goAhead(_ sender: Any) {
    }
    
    @IBAction func goBack(_ sender: Any) {
       // _ = navigationController?.popViewController(animated: true)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        vc.selectedIndex = 4
        vc.view.backgroundColor = .clear
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
