//
//  Privacy&TermsViewController.swift
//  Islamic Goals
//
//  Created by Osama Fahim on 30/05/2020.
//  Copyright © 2020 Matz. All rights reserved.
//

import UIKit
import FirebaseFirestore

class Privacy_TermsViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        cardView.layer.cornerRadius = 25
    }
    
    @IBAction func backbuttonPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        vc.selectedIndex = 4
        vc.view.backgroundColor = .clear
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func getData(){
        let db = Firestore.firestore()
        let collectionRef = db.collection("Privacy & terms")
        collectionRef.getDocuments { (querySnapshot, err) in
            if let docs = querySnapshot?.documents {
                for docSnapshot in docs {
                    let text = docSnapshot["PrivacyTerms"] as! String
                    let text1 = docSnapshot["PrivacyTerms1"] as! String
                    let text2 = docSnapshot["PrivacyTerms2"] as! String
                    let text3 = docSnapshot["PrivacyTerms3"] as! String
                    let text4 = docSnapshot["PrivacyTerms4"] as! String
                    self.textView.text = "\(text)\n\n\(text1)\n\n\(text2)\n\n\(text3)\n\n\(text4)"
                }
            }
        }
    }
}
