//
//  CreateAccountViewController.swift
//  Smack
//
//  Created by Vinicius Ricci on 5/10/18.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func createAccountPressed(_ sender: UIButton) {
        
        guard let name = usernameTxt.text, usernameTxt.text != "" else {return}
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let password = passwordTxt.text, passwordTxt.text != "" else {return}
        
        AuthService.sharedInstance.registerUser(email: email, password: password) { (success) in
            
            if success {
                print("registered user!")
                AuthService.sharedInstance.loginUser(email: email, password: password, result: { (success) in
                    if success {
                        print("logged in user!", AuthService.sharedInstance.authToken)
                        AuthService.sharedInstance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            
                            if success {
                                print(UserDataService.sharedInstance.name, UserDataService.sharedInstance.avatarName)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            }
                        })
                    }
                    
                })
            }
        }
        
    }
    @IBAction func pickAvatarPressed(_ sender: UIButton) {
        
    }
    @IBAction func pickBGColorPressed(_ sender: UIButton) {
        
    }
    @IBAction func closePressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: UNWIND, sender: nil)
    }

}
