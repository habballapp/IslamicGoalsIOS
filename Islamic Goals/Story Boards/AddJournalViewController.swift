//
//  AddJournalViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 25/10/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit

class AddJournalViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addJournalButton: UIButton!
    @IBOutlet weak var backView: UIView!
    var date = Date()
    var calendar = Calendar.current
    
    let placeholder = "Type the Journal here"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 25
        backView.dropShadow()
        addJournalButton.layer.cornerRadius = 25
        
        textView.text = placeholder
        textView.textColor = UIColor.lightGray
        print(date)
        textView.delegate = self
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didClickedAddJournal(_ sender: Any) {
        if UserManager.shared.isUserLoggedIn {
            if textView.text != nil && textView.text != "" && textView.text != placeholder {
                let currentDateTime = Date()
                let formatter = DateFormatter()
                formatter.timeStyle = .none
                formatter.dateStyle = .long
                let formatedDate = formatter.string(from: currentDateTime)
                JournalDatabase.init(dateJournal: formatedDate, jDescription: textView.text, timestamp: "\(date)").addJournalDatabase(currentUser: UserManager.shared.userDetails!, handleFinish: { (isAdded) in
                    if (isAdded) {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
            else {
                CustomToast.showNegativeMessage(message: "no data is there to add")
            }
        }
        else {
            CustomToast.showNegativeMessage(message: "you are not signed in")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray || textView.text == placeholder {
            textView.text = nil
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
