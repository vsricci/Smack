//
//  CreateAccountViewController.swift
//  Smack
//
//  Created by Vinicius Ricci on 5/10/18.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func closePressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    

}
