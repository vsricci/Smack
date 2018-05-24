//
//  ChatViewController.swift
//  Smack
//
//  Created by Vinicius Ricci on 5/10/18.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    //MARK: -  Outlets
    @IBOutlet weak var menuBtn : UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        if AuthService.sharedInstance.isLoggedIn {
            AuthService.sharedInstance.findUserByEmail { (success) in
                
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
        
        MessageService.sharedInstance.findAllChannel { (success) in
            
        }
    }

    

}
