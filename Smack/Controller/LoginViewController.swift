//
//  LoginViewController.swift
//  Smack
//
//  Created by Vinicius Ricci on 5/10/18.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    @IBAction func closePressed(_ sender: UIButton) {
          dismiss(animated: true, completion: nil)
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        guard let username = usernameTextField.text, usernameTextField.text != "" else {return}
        guard let password = passwordTextField.text, passwordTextField.text != "" else {return}
        
        AuthService.sharedInstance.loginUser(email: username, password: password) { (success) in
            
            if success {
               
                AuthService.sharedInstance.findUserByEmail(completion: { (success) in
                    
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                        self.activityIndicatorView.isHidden = true
                        self.activityIndicatorView.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            }
        }
    }
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    func setupView(){
        
        activityIndicatorView.isHidden = true
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
    }

}
