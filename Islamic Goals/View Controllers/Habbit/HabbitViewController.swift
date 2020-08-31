//
//  HabbitViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 27/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import FirebaseFirestore

class HabbitViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var habbitCollectionView: UICollectionView!
    
    @IBOutlet weak var backgroundCard: UIView!
    
    
    var selectedRow = 0
    var db: Firestore!
    var habitsArray = [String]()
    var keyArray = [String]()
    var HabitKey = ""
    
    let habbitKeys = habbitCategoryData.map({$0.key})
    
    override func viewDidLoad() {
        super.viewDidLoad()
        habbitCollectionView.layoutIfNeeded()
        backgroundCard.layer.cornerRadius = 25
        backgroundCard.dropShadow()
        
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        getData()
        
        
       // saveButton.dropShadow
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        habitsArray.removeAll()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return habitsArray.count
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitCategory", for: indexPath) as! habbitCollectionViewCell
        cell.habbitLabel.text = habitsArray[indexPath.row]
        cell.backgroundCard.layer.cornerRadius = 25
        cell.backgroundCard.layer.borderColor = darkGreenColor.cgColor
        cell.backgroundCard.layer.borderWidth = 1
        cell.backgroundCard.backgroundColor = .white
        cell.backgroundCard.dropShadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: habbitCollectionView.frame.width * 0.45, height: habbitCollectionView.frame.width * 0.45)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           if indexPath.row == 5{
               self.performSegue(withIdentifier: "goToAllHabits", sender: self)
           }else{
               selectedRow = indexPath.row
            print("i am in else part")
            print(selectedRow)
               self.performSegue(withIdentifier: "showSpecificHabbitCategory", sender: self)
           }
       }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedRow = indexPath.row
//        self.performSegue(withIdentifier: "showSpecificHabbitCategory", sender: self)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSpecificHabbitCategory" {
            let destinationVC = segue.destination as! habbitSpecificViewController
            print("the selected row in habbit view controller is")
            print(selectedRow)
         destinationVC.specificHabbit = habitsArray[selectedRow]
            destinationVC.key = keyArray[selectedRow]
            
        }
    }
    
    
 
    
    
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func getData(){
        db = Firestore.firestore()
        let collectionRef = db.collection("habits")
        collectionRef.getDocuments { (querySnapshot, err) in
            if let docs = querySnapshot?.documents {
                for docSnapshot in docs {
                    let data = docSnapshot["Name"] as? String
                    self.HabitKey = docSnapshot["HabitKey"] as! String
                    self.habitsArray.append(data!)
                    self.keyArray.append(self.HabitKey)
                    self.habbitCollectionView.reloadData()
                }
            }
        }
    }
}
