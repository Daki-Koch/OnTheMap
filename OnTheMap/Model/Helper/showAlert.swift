//
//  showAlert.swift
//  OnTheMap
//
//  Created by David Koch on 22.11.22.
//

import Foundation
import UIKit

extension UIViewController{
    
    func showFailure(message: String, title: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true)
    }
    
    func showAlert(message: String, title: String, completion: @escaping (UIAlertAction) -> Void){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: completion))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: completion))
        present(alertVC, animated: true)
                          
    }
}
