//
//  CustomExpandableViewController.swift
//  Smack
//
//  Created by Vinicius Ricci on 29/09/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class CustomExpandableViewController: UIViewController {

    @IBOutlet weak var expandableTableView: UITableView!
    
    var heigthHeaderCell : CGFloat = 88.0
    var customHeigthCell : CGFloat = 0.0
    var customHeigthCell2 : CGFloat = 0.0
    var customHeigthCell3 : CGFloat = 0.0
    var numberMenosUm = Int()
    var numberMaisUm: Int = Int()
    var numberOfTaps : Int = 1
    var taps : Int = -1
    var expandables = [Expandable]()
    var isEx: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        expandableTableView.rowHeight = 88.0
        
        expandableTableView.estimatedRowHeight = UITableViewAutomaticDimension

        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.twoPats(tap:row:)))
        tap.numberOfTapsRequired = 2
        expandableTableView.addGestureRecognizer(tap)
        
        getRows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        expandableTableView.reloadData()
    }
    
    func getRows() {
        for i in 0..<5 {
            var item = Expandable()
            item.isExpandable = false
            item.farovite = 0
            expandables.append(item)
        }
    }
    
    func updateRows() {
        
        if let row = UserDefaults.standard.object(forKey: "row") as? Int {
            if row == 1 {
                for i in 0..<5 {
                    var item = Expandable()
                    item.isExpandable = false
                    item.farovite = 1
                    expandables.append(item)
                }
            }else {
                for i in 0..<5 {
                    var item = Expandable()
                    item.isExpandable = false
                    item.farovite = 0
                    expandables.append(item)
                }
            }
        }else {
            print("teste")
        }
        
       
    }
    
    func remove() {
        UserDefaults.standard.removeObject(forKey: "row")
    }
    

    @objc func twoPats(tap: UITapGestureRecognizer, row: Int) {
        customHeigthCell = 0.0
        customHeigthCell2 = 0.0
        self.expandableTableView.reloadData()
    }
}

extension CustomExpandableViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return expandables.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomExpandableTableViewCell
        let row = expandables[indexPath.row]
        
        if cell.frame.size.height == 125.0 {
            cell.textLabel?.text = "fgdhshdfghdfhs"
            cell.textLabel?.textColor = UIColor.blue
        }
        if cell.frame.size.height == 88.0 {
            
            cell.textLabel?.text = "fdgffdgfdgfdgfdgfdgfgdfgfdgfd"
             cell.textLabel?.textColor = UIColor.red
        }
        print(cell.frame.size.height)
       
    return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let index = indexPath.section
        var row = indexPath.row
        
      numberMenosUm = row-1
      numberMaisUm = row+1
        
        print("row : \(row) menos um : \(numberMenosUm) mais um : \(numberMaisUm)")
        let cell = tableView.cellForRow(at: indexPath) as! CustomExpandableTableViewCell
 
       // self.remove()
        if row > numberMenosUm &&  row < numberMaisUm {
          // self.expandableTableView.beginUpdates()
            //  self.expandableTableView.reloadRows(at: [indexPath], with: .automatic)
           // self.expandableTableView.endUpdates()
           // UserDefaults.standard.set(row, forKey: "row")
            //updateRows()
//            if cell.frame.size.height == 125.0 {
//                DispatchQueue.main.async {
//                    cell.textLabel?.text = "ddfgfdgdf"
//                }
//                //cell.textLabel?.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
//            }else {
//                cell.textLabel?.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
//            }
//            self.expandableTableView.beginUpdates()
//            self.expandableTableView.reloadRows(at: [indexPath], with: .automatic)
//            self.expandableTableView.endUpdates()
        }
       // UserDefaults.standard.set(row, forKey: "row")
        
       
        
        self.expandableTableView.beginUpdates()
       // self.expandableTableView.reloadRows(at: [indexPath], with: .automatic)
        self.expandableTableView.reloadData()
        self.expandableTableView.endUpdates()
       // updateRows()
    }
}

extension CustomExpandableViewController: UITableViewDataSource{
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
       // let cell = tableView.cellForRow(at: indexPath) as! CustomExpandableTableViewCell
        let row = indexPath.row
        if row > numberMenosUm &&  row < numberMaisUm {
            
            //cell.titleLabel.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            height = 125
        }
       else {
           // cell.titleLabel.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            height = 88
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let index = indexPath.section
//        let row = indexPath.row
     //   print("max: \(heigthHeaderCell + customHeigthCell)")
        return 0.0
    }
}

class Expandable  {
    var isExpandable : Bool = false
    var farovite: Int = 0
}
