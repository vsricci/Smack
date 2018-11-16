//
//  MessageService.swift
//  Smack
//
//  Created by Vinicius Ricci on 5/24/18.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let sharedInstance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var unreadChannels = [String]()
    var manager = Alamofire.SessionManager.default
    var selectedChannel: Channel?
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        
        manager.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).validate().responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                
                do {
                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
//                    print(channel.description)
//                    self.channels.append(channel)
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                }catch let error {
                    completion(false)
                    debugPrint(error.localizedDescription as Any)
                }
               // print(self.channels)
                
                
                //            if response.result.error == nil {
                //                guard let data = response.data else {return}
                //                if let json = try! JSON(data: data).array {
                //                    for item in json {
                //                        let name = item["name"].stringValue
                //                        let description = item["description"].stringValue
                //                        let id = item["_id"].stringValue
                //                        let v = item["__v"].intValue
                //                        let channel = Channel(name: name, description: description, _id: id, __v: v)
                //                        print("Channel created: \(channel.name)")
                //                        self.channels.append(channel)
                //                    }
                //
                //                }
                //            }
            }
        
        }
    }
    
    func findAllMessagesForChaannel(channelId: String, completion: @escaping (CompletionHandler)) {
        
        let url = "\(URL_GET_MESSAGES)/\(channelId)"
        //print("URL:: \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).validate(statusCode: 200..<402).responseJSON { (response) in
            
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else {return}
                do {
                    self.messages = try JSONDecoder().decode([Message].self, from: data)
                   // print("Message : \(self.messages[0].timestamp)")
                    print(self.messages.count)
                    completion(true)
                }
                catch let error {
                    print(error.localizedDescription)
                    completion(false)
                }
                
            }else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearChannels(){
        channels.removeAll()
    }
    
    func clearMessages() {
        messages.removeAll()
    }
}
