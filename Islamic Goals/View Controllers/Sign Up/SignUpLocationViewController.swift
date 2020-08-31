//
//  SignUpLocationViewController.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 19/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class SignUpLocationViewController: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dummyMapImageView: UIImageView!
    
    var emailAddress = String()
    var password = String()
    var fullName = String()
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 25
        nextButton.layer.cornerRadius = 25
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        mapView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func setCurrentLocation(_ sender: Any) {
        dummyMapImageView.isHidden = true
        mapView.isHidden = false
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latitude = location.latitude
        let longitude = location.longitude
        if locations.last != nil{
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func goAhead(_ sender: Any) {
        self.performSegue(withIdentifier: "locationToCalendar", sender: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationToCalendar" {
            let destinationVC = segue.destination as! SignUpCalendarViewController
            destinationVC.emailAddress = emailAddress
            destinationVC.fullName = fullName
            destinationVC.password = password
        }
    }
    
}
