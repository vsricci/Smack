//
//  ProfileViewController.swift
//  Smack
//
//  Created by Vinicius Ricci on 5/22/18.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }

    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.sharedInstance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        userName.text = UserDataService.sharedInstance.name
        userEmail.text = UserDataService.sharedInstance.email
        profileImg.image = UIImage(named: UserDataService.sharedInstance.avatarName)
        profileImg.backgroundColor = UserDataService.sharedInstance.returnUIColor(components: UserDataService.sharedInstance.avatarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeTap))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

}
