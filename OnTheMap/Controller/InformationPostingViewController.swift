//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by David Koch on 22.11.22.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController{
    
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var location: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func findLocation(_ sender: Any) {
        if location.text == ""{
            showFailure(message: "No location, please enter location to continue.", title: "Missing Input")
        }
        if url.text == "" {
            showFailure(message: "No URL, please enter URL to continue.", title: "Missing Input")
        }
        
        coordinates(forAddress: location.text!) { location in
            guard let _ = location else{
                self.showFailure(message: "No location found, please try again", title: "Invalid Location")
                return
            }
            
        }

    }
    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            if let error = error {
                self.showFailure(message: error.localizedDescription, title: "Location Not Found")

                DispatchQueue.main.async {
                    completion(nil)
                }
            } else {
                var location: CLLocation?
                if let marker = placemarks, marker.count > 0 {
                    location = marker.first?.location
                }
                if let location = location{
                    self.openMapForPlace(location: location.coordinate)
                } else {
                    self.showFailure(message: "Please try again later", title: "Error")
                }
            }
            
        }
    }
    

    
    public func openMapForPlace(location: CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "\(ParseClient.Auth.firstName) \(ParseClient.Auth.lastName)"
        annotation.subtitle = url.text!
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "LocationConfirmViewController") as! LocationConfirmViewController
        controller.annotation = annotation
        controller.objectId = ParseClient.Auth.objectId
        controller.mapString = self.location.text!
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
}
