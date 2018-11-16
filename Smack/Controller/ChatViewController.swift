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
    @IBOutlet weak var channelNameLbl : UILabel!
    @IBOutlet weak var messagetextButton: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typeUsersLabel: UILabel!
    
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        
        
        sendButton.isHidden = true
        messageTableView.estimatedRowHeight = 120
        messageTableView.rowHeight = UITableViewAutomaticDimension
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
       getNewMessages()
       getTypingUsers()
        
        if AuthService.sharedInstance.isLoggedIn {
            AuthService.sharedInstance.findUserByEmail { (success) in
                
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
               
            }
        }
    }

    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.sharedInstance.isLoggedIn {
            // get channels
            onLoginGetMessages()
            
        }else {
            channelNameLbl.text = "Please Log in"
            self.messageTableView.reloadData()
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    func getTypingUsers() {
        SocketService.sharedInstance.getTypeUsers { (typingUsers) in
            
            guard let channelID = MessageService.sharedInstance.selectedChannel?._id else {return}
            var names = ""
            var numberOfTypers = 0
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.sharedInstance.name && channel == channelID {
                    if names == ""{
                        names = typingUser
                    }else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.sharedInstance.isLoggedIn == true {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typeUsersLabel.text = "\(names), \(verb) typing a message"
            }
            else {
                self.typeUsersLabel.text = ""
            }
        }
    }
    
    func updateWithChannel() {
        let channelName  = MessageService.sharedInstance.selectedChannel?.name ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
       // self.getNewMessages()
       // self.getTypingUsers()
    }
    
    @objc func onLoginGetMessages(){
        MessageService.sharedInstance.findAllChannel { (success) in
            
            if success {
                // Do Stuff with channels
                if MessageService.sharedInstance.channels.count > 0 {
                    MessageService.sharedInstance.selectedChannel = MessageService.sharedInstance.channels[0]
                    self.updateWithChannel()
                }
                else {
                    self.channelNameLbl.text = "No channels yet!"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelID = MessageService.sharedInstance.selectedChannel?._id else {return}
        MessageService.sharedInstance.findAllMessagesForChaannel(channelId: channelID) { (success) in
            
            if success {
                self.messageTableView.reloadData()
            }
        }
    }
    
    func getNewMessages() {
        SocketService.sharedInstance.getChatMessage { (newMessage) in
            if newMessage.channelID == MessageService.sharedInstance.selectedChannel?._id && AuthService.sharedInstance.isLoggedIn {
                MessageService.sharedInstance.messages.append(newMessage)
                self.messageTableView.reloadData()
                if MessageService.sharedInstance.messages.count > 0 {
                    let endIndex = IndexPath(row: MessageService.sharedInstance.messages.count - 1, section: 0)
                    self.messageTableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                    
                }
            }
        }
//        SocketService.sharedInstance.getChatMessage { (success) in
//            if success {
//                self.messageTableView.reloadData()
//                if MessageService.sharedInstance.messages.count > 0 {
//                    let index = IndexPath(row: MessageService.sharedInstance.messages.count - 1, section: 0)
//                    self.messageTableView.scrollToRow(at: index, at: .bottom, animated: false)
//                }
//            }
//        }
    }
    
    //MARK: - @IBActions

    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthService.sharedInstance.isLoggedIn {
            guard let channelID = MessageService.sharedInstance.selectedChannel?._id else {return}
            guard let message = messagetextButton.text else {return}
            
            SocketService.sharedInstance.addMessage(messageBody: message, userID: UserDataService.sharedInstance.id, channelID: channelID) { (success) in
                if success {
                    self.messagetextButton.text = ""
                    self.messagetextButton.resignFirstResponder()
                    SocketService.socket.emit("stopType", UserDataService.sharedInstance.name, channelID)
                }
            }
        }
    }
    
    @IBAction func messageEditing(_ sender: Any) {
        
        guard let channelID = MessageService.sharedInstance.selectedChannel?._id else {return}
        
        if messagetextButton.text == "" {
                isTyping = false
                sendButton.isHidden = true
            SocketService.socket.emit("stopType", UserDataService.sharedInstance.name, channelID)
            }else {
                if isTyping == false{
                    sendButton.isHidden = false
                    SocketService.socket.emit("startType", UserDataService.sharedInstance.name, channelID)
                }
                isTyping = true
            }
    }
    
}

extension ChatViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.0
    }
}

extension ChatViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.sharedInstance.messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            
            let message = MessageService.sharedInstance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
            
        }else {
            return UITableViewCell()
        }
    }
}



