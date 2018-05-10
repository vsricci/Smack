//
//  AuthService.swift
//  Smack
//
//  Created by Vinicius Ricci on 5/10/18.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation
import Alamofire

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
        let headers = ["Content-Type": "application/json; charset=utf-8"]
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        manager.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).validate().responseString { (response) in
            
            if response.result.error == nil {
                result(true)
            }else {
                result(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    
}
