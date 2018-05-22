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
    @IBOutlet weak var activityIndicatorView : UIActivityIndicatorView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        activityIndicatorView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDataService.sharedInstance.avatarName != ""{
            userImg.image = UIImage(named: UserDataService.sharedInstance.avatarName)
            avatarName = UserDataService.sharedInstance.avatarName
            if avatarName.contains("light") && bgColor == nil {
                userImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    @IBAction func createAccountPressed(_ sender: UIButton) {
        
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
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
                                self.activityIndicatorView.isHidden = true
                                self.activityIndicatorView.stopAnimating()
                                print(UserDataService.sharedInstance.name, UserDataService.sharedInstance.avatarName)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                                
                            }
                        })
                    }
                    
                })
            }
        }
        
    }
    @IBAction func pickAvatarPressed(_ sender: UIButton) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    @IBAction func pickBGColorPressed(_ sender: UIButton) {
        let r =  CGFloat(arc4random_uniform(255)) / 255
        let g =  CGFloat(arc4random_uniform(255)) / 255
        let b =  CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        
        UIView.animate(withDuration: 0.2) {
            self.userImg.backgroundColor = self.bgColor
        }
        
        
    }
    @IBAction func closePressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    func setupView(){
        
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }

}
