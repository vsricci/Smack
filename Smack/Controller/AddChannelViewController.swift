//
//  AddChannelViewController.swift
//  Smack
//
//  Created by Vinicius Ricci on 5/24/18.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class AddChannelViewController: UIViewController {

    @IBOutlet weak var nameChannelField: UITextField!
    @IBOutlet weak var descriptionChannelField: UITextField!
    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
    }

    @IBAction func createChannelPressed(_ sender: Any) {
        guard let channelName = nameChannelField.text, nameChannelField.text != "" else {return}
        guard let channelDesc = descriptionChannelField.text, descriptionChannelField.text != "" else {return}
        
        SocketService.sharedInstance.addChannel(channelName: channelName, channelDescription: channelDesc) { (success) in
            
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(){
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        nameChannelField.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        
        descriptionChannelField.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }

 

}
