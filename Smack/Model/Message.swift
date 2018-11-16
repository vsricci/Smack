//
//  Message.swift
//  Smack
//
//  Created by Vinicius Ricci on 23/09/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation

struct Message: Decodable {
    public private (set) var message: String = ""
    public private (set) var userName: String = ""
    public private (set) var channelID: String = ""
    public private (set) var userAvatar: String = ""
    public private (set) var userAvatarColor: String = ""
    public private (set) var id: String = ""
    public private (set) var timestamp: String = ""
    
     init(message: String, userName: String, channelID: String, userAvatar: String, userAvatarColor: String, id: String, timestamp: String) {
        self.message = message
        self.userName = userName
        self.channelID = channelID
        self.userAvatar = userAvatar
        self.userAvatarColor = userAvatarColor
        self.id = id
        self.timestamp = timestamp
    }
    
    enum CodingKeys : String, CodingKey {
        case messageBody
        case userName
        case channelId
        case userAvatar
        case userAvatarColor
        case _id
        case timeStamp
        
    }
    
     init(from decoder: Decoder) throws {
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let message = try! container.decode(String.self, forKey: .messageBody)
        let userName = try! container.decode(String.self, forKey: .userName)
        let channelID = try! container.decode(String.self, forKey: .channelId)
        let userAvatar = try! container.decode(String.self, forKey: .userAvatar)
        let userAvatarColor = try! container.decode(String.self, forKey: .userAvatarColor)
        let id = try! container.decode(String.self, forKey: ._id)
        let timestamp = try! container.decode(String.self, forKey: .timeStamp)
        self.init(message: message, userName: userName, channelID: channelID, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timestamp: timestamp)
        
    }
}
