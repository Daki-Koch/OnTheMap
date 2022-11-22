//
//  LocationConfirmViewController.swift
//  OnTheMap
//
//  Created by David Koch on 22.11.22.
//

import UIKit
import MapKit

class LocationConfirmViewController: UIViewController, MKMapViewDelegate{
    
    var annotation = MKPointAnnotation()
    var objectId = String()
    var mapString = String()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
        
    }
    
    @IBAction func finish(_ sender: Any) {
        if ParseClient.Auth.objectId == ""{
            ParseClient.POSTStudentLocation(location: Location(uniqueKey: ParseClient.Auth.accountKey, firstName: ParseClient.Auth.firstName, lastName: ParseClient.Auth.lastName, mapString: self.mapString, mediaURL: self.annotation.subtitle!, latitude: Float(annotation.coordinate.latitude), longitude: Float(annotation.coordinate.longitude))) { response, error in
                if response {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                    
                }
                else{
                    self.showFailure(message: error!.localizedDescription, title: "Error")
                }
            }
        } else {
            showAlert(message: "This student already has a posted location. Would you like to continue?", title: "") { (action: UIAlertAction) in
                if action.title == "Overwrite"{
                    ParseClient.PUTStudentLocation(location: Location(uniqueKey: ParseClient.Auth.accountKey, firstName: ParseClient.Auth.firstName, lastName: ParseClient.Auth.lastName, mapString: self.mapString, mediaURL: self.annotation.subtitle!, latitude: Float(self.annotation.coordinate.latitude), longitude: Float(self.annotation.coordinate.longitude))) { success, error in
                        if success{
                            DispatchQueue.main.async {
                                self.dismiss(animated: true)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showFailure(message: error?.localizedDescription ?? "", title: "Error")
                            }
                        }
                    }
                }
                if action.title == "Cancel"{
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                }
            }
            
        }
    }
}

