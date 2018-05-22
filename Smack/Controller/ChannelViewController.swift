//
//  ChannelViewController.swift
//  Smack
//
//  Created by Vinicius Ricci on 5/10/18.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        if AuthService.sharedInstance.isLoggedIn {
            let profile = ProfileViewController()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        }else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
        
        
    }
    
    @IBAction func prepareForUnwind(segue : UIStoryboardSegue) {
        
    }

    @objc func userDataDidChange(_ notification: Notification) {
        if AuthService.sharedInstance.isLoggedIn {
            loginBtn.setTitle(UserDataService.sharedInstance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.sharedInstance.avatarName)
            userImg.backgroundColor = UserDataService.sharedInstance.returnUIColor(components: UserDataService.sharedInstance.avatarColor)
        }
        else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
        }
    }
}
