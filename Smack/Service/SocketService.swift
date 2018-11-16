//
//  SocketService.swift
//  Smack
//
//  Created by Vinicius Ricci on 5/24/18.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit
import SocketIO
class SocketService: NSObject {

    static let sharedInstance = SocketService()
    static let manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    static var socket = manager.defaultSocket
    
    func establishConnection(){
        
        SocketService.socket = SocketService.manager.defaultSocket
        SocketService.socket.connect()
    }
    
    func closeConnection(){
        SocketService.socket.disconnect()
    }
    
    func addChannel(channelName: String,  channelDescription: String, completion: @escaping CompletionHandler){
        SocketService.socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        SocketService.socket.on("channelCreated") { (dataArray, ack) in
            
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDesc = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            
            print(channelName)
            
            let newChannel = Channel(name: channelName, description: channelDesc, _id: channelId, __v: 0)
            MessageService.sharedInstance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func getChannels(completion: @escaping CompletionHandler) {
        SocketService.socket.once("channelCreated") { (channels, ack) in
            
            if let channels = channels as? [Channel] {
                print("Count: \(channels.count)")
                
            }else {
                print("not is a channel")
            }
        }
    }
    
    func addMessage(messageBody: String, userID: String, channelID: String, completion: @escaping (CompletionHandler)) {
        
        let user = UserDataService.sharedInstance
        SocketService.socket.emit("newMessage", messageBody, userID, channelID, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getChatMessage(completion: @escaping (_ newMessage: Message) -> Void){
        SocketService.socket.on("messageCreated") { (dataArray, ack) in
            
            guard let messageBody = dataArray[0] as? String else {return}
            guard let channelID = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let id = dataArray[6] as? String else {return}
            guard let timestamp = dataArray[7] as? String else {return}
            
            let newMessage = Message(message: messageBody, userName: userName, channelID: channelID, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timestamp: timestamp)
            completion(newMessage)
            
//            if channelID == MessageService.sharedInstance.selectedChannel?._id && AuthService.sharedInstance.isLoggedIn {
//
//                completion(true)
//
//            }else {
//                completion(false)
//            }
        }
    }
    
    func getTypeUsers(_ completionHandler: @escaping (_ typingUser: [String: String]) -> Void){
        SocketService.socket.on("userTypingUpdate") { (dataArray, ack) in
            
            guard let  typingUsers = dataArray[0] as? [String: String] else {return}
            completionHandler(typingUsers)
        }
    }
    
}
