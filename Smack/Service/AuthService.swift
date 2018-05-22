//
//  AuthService.swift
//  Smack
//
//  Created by Vinicius Ricci on 5/10/18.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let sharedInstance = AuthService()
    private let manager = Alamofire.SessionManager.default
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken : String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            return defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail : String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            return defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email: String, password: String, result: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        manager.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADERS).validate().responseString { (response) in
            
            if response.result.error == nil {
                result(true)
            }else {
                result(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func loginUser(email: String, password: String, result: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        manager.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADERS).validate().responseJSON { (response) in
            
            if response.result.error == nil {
//                if let json = response.result.value as? [String: Any] {
                    
//                    if let email = json["user"] as? String {
//                        self.userEmail = email
//                    }
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
                    
//                }
                    //Using SwiftJSON
                    guard let data = response.data else {return}
                    let json = try! JSON(data: data)
                    
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    self.isLoggedIn = true
                    result(true)
                
            }else {
                result(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        let header = ["Authorization": "Bearer \(AuthService.sharedInstance.authToken)",
            "Content-Type": "Application/json; charset=utf-8"]
        
       manager.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).validate().responseJSON { (response) in
        
                if response.result.error == nil {
       
                    guard let data = response.data else {return}
                    let json = try! JSON(data: data)
                    let id = json["_id"].stringValue
                    let color = json["avatarColor"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let email = json["email"].stringValue
                    let name = json["name"].stringValue
                    
                    UserDataService.sharedInstance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
                    completion(true)
                }else {
                    completion(false)
                    debugPrint(response.result.error as Any)
        }
    
            }
    }
    
    
}
