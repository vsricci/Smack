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
    var manager = Alamofire.SessionManager.default
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        
        manager.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).validate().responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                
//                do {
//                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
//                }catch let error {
//                    debugPrint(error as Any)
//                }
//                print(self.channels)
                
                
                if let json = try! JSON(data: data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let description = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let v = item["__v"].intValue
                        let channel = Channel(channelTitle: name, channelDescription: description, _id: id, __v: v)
                        self.channels.append(channel)
                    }
                    completion(true)
                }
                
            }else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
}
