//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by David Koch on 21.11.22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var singUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginTapped(_ sender: Any) {
        UdacityClient.login(user: SessionRequest(udacity: User(username: emailTextField.text ?? "", password: passwordTextField.text ?? "")), completion: handleSessionResponse(success:error:))
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.signUpURL.url)
    }
    
    func handleSessionResponse(success: Bool, error: Error?){
        setLoggingIn(false)
        if success {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }
        else {
            showLoginFailure(message: error?.localizedDescription ?? "")
            setLoggingIn(false)
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool){
        if loggingIn{
            
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String){
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        show(alertVC, sender: nil)
    }
}

