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
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        SocketService.sharedInstance.getChannel { (success) in
            
            if success {
                self.tableView.reloadData()
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupUserInfo()
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
    
    @IBAction func addChannelPressed(_ sendr: Any) {
        let addChannel = AddChannelViewController()
        addChannel.modalPresentationStyle = .custom
        present(addChannel, animated: true, completion: nil)
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
    
    func setupUserInfo() {
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

extension ChannelViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MessageService.sharedInstance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell") as? ChannelCell {
            let channel = MessageService.sharedInstance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        }else {
            return ChannelCell()
        }
    }
    
}
