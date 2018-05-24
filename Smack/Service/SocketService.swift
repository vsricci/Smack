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
    
    override init() {
        super.init()
    }
    
    var socket: SocketIOClient = SocketIOClient(manager: URL(string: BASE_URL)! as! SocketManagerSpec, nsp: "")
    
    func establishConnection(){
        socket.connect()
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    func addChannel(channelName: String,  channelDescription: String, completion: @escaping CompletionHandler){
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDesc = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, _id: channelId, __v: 0)
            MessageService.sharedInstance.channels.append(newChannel)
            completion(true)
        }
    }
    
    
}
