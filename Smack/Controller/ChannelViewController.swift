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
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelIsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        
        
        SocketService.sharedInstance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }else {
                print("not is a channel group...")
            }
        }
        
        SocketService.sharedInstance.getChatMessage { (newMessage) in
            if newMessage.channelID != MessageService.sharedInstance.selectedChannel?._id && AuthService.sharedInstance.isLoggedIn {
                MessageService.sharedInstance.unreadChannels.append(newMessage.channelID)
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
        
        if AuthService.sharedInstance.isLoggedIn {
            let addChannel = AddChannelViewController()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
            
        }
       
    }
    
    @IBAction func prepareForUnwind(segue : UIStoryboardSegue) {
        
    }

    @objc func userDataDidChange(_ notification: Notification) {
        setupUserInfo()
    }
    
    @objc func channelIsLoaded(_ notif: Notification) {
        
        tableView.reloadData()
    }
    
    func setupUserInfo() {
        if AuthService.sharedInstance.isLoggedIn {
            loginBtn.setTitle(UserDataService.sharedInstance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.sharedInstance.avatarName)
            userImg.backgroundColor = UserDataService.sharedInstance.returnUIColor(components: UserDataService.sharedInstance.avatarColor)
            NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
        }
        else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.sharedInstance.channels[indexPath.row]
        MessageService.sharedInstance.selectedChannel = channel
        
        if MessageService.sharedInstance.unreadChannels.count > 0 {
            MessageService.sharedInstance.unreadChannels = MessageService.sharedInstance.unreadChannels.filter{$0 != channel._id}
        }
        
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: index, animated: true, scrollPosition: .none)
        
        NotificationCenter.default.post(name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        self.revealViewController()?.revealToggle(animated: true)
    }
    
}
