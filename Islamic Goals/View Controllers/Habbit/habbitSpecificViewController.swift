//
//  habbitSpecificViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 27/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class habbitSpecificViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var habbitCollectionView: UICollectionView!
    @IBOutlet weak var writeOwnButton: UIButton!
    
  

    

    
    
    @IBOutlet weak var backgroundCard: UIView!
    
    
    var specificHabbit : String?
    var key : String?
    var subHabit : String?
    var db: Firestore!
    let size:CGFloat = 55.0
    var subHabitArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
//        let label = UILabel(frame: CGRect(x : 0.0,y : 0.0,width : size, height :  size))
//        label.textAlignment = .center
//
//        label.font = UIFont.systemFont(ofSize: 24.0)
//        label.layer.cornerRadius = size / 2
//       label.layer.borderWidth = 3.0
//        label.layer.masksToBounds = true
//        label.layer.backgroundColor = UIColor.green.cgColor
//        label.layer.borderColor = UIColor.green.cgColor
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
        
//        print(specificHabbit)
//        headerLabel.text = "\(specificHabbit!)"
        
        habbitCollectionView.layoutIfNeeded()
        backgroundCard.layer.cornerRadius = 25
        backgroundCard.dropShadow()
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        subHabitArray.removeAll()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subHabitArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitCategory", for: indexPath) as! habbitCollectionViewCell
        
        cell.habbitLabel.text = subHabitArray[indexPath.row]
        
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
        subHabit = subHabitArray[indexPath.row]
        self.performSegue(withIdentifier: "goToFrequency", sender: self)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToFrequency" {
//            let destinationVC = segue.destination as! ChooseFrequencyViewController
//            destinationVC.Habit = self.specificHabbit!
//            destinationVC.SubHabit = self.subHabit!
//            destinationVC.key = self.key
//            
//        }
//    }
    
    func getData(){
        db = Firestore.firestore()
        let collectionRef = db.collection("habits")
        collectionRef.getDocuments { (querySnapshot, err) in
            if let docs = querySnapshot?.documents {
                for docSnapshot in docs {
                    let data = docSnapshot["Name"] as? String
                    
                    if data == self.specificHabbit{
                        let subhabits = docSnapshot["SubHabits"] as! [[String : Any]]
                        for docSnapshot1 in subhabits{
                            print(docSnapshot1)
                            if let doc = docSnapshot1["Name"]{
                                self.subHabitArray.append(doc as! String)
                                self.habbitCollectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}
