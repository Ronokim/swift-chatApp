//
//  ContactsTableViewController.swift
//  chatApp
//
//  Created by Ronald Kimutai on 30/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit
import FirebaseAuth

class ContactsTableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var customView: ContactsTableView? = nil
    var cellIdendifier: String = "EventCell"
    var arrayList: [Dictionary<String, String>] = []
    var rowHeight: CGFloat = 60.0
    var contactsTable: UITableView? = nil
    var selectedContactNumber: String? = ""
    var selectedContactName: String? = ""
    var contactsArray: [String] = []
    var contactsNameArray: [Dictionary<String, String>] = []
    var userMsisdn: String = ""
    
    override func loadView()  {
        super.loadView()
        
        self.title = "Select Contact"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        self.navigationItem.title = "Select Contact"
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        //self.navigationController?.navigationBar.topItem?.title = " "
        customView = ContactsTableView(frame: CGRect.zero)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = customView
        
        contactsTable = self.view.viewWithTag(1) as? UITableView
        contactsTable?.isUserInteractionEnabled = true
        contactsTable?.allowsSelection = true
        contactsTable?.allowsSelectionDuringEditing = false
        contactsTable?.delegate = self
        contactsTable?.dataSource = self
        self.dataSource()
        contactsTable?.reloadData()
        
        contactsTable?.register(ContactsTableViewCell.self, forCellReuseIdentifier: cellIdendifier)
        contactsTable?.tableFooterView = UIView()
        
        userMsisdn = UserDefaults.standard.string(forKey: "verifiedUser")!
        
        self.setToolBarButtons()
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setToolBarButtons()  {
        let doneButton: UIButton = UIButton(frame: CGRect(x : 0, y : 5, width : 70, height : 30))
        doneButton.tag = 99
        doneButton.backgroundColor = UIColor.clear
        doneButton.setTitle("Chat", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.backGroundColor.themeColor, for: UIControlState.normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        doneButton.titleLabel?.textAlignment = NSTextAlignment.right
        doneButton.addTarget(self, action:#selector(buttonListener(sender:)), for: UIControlEvents.touchUpInside)
        
        let cancelButton: UIButton = UIButton(frame: CGRect(x : 1, y : 5, width : 70, height : 30))
        cancelButton.tag = 100
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitle("Cancel", for: UIControlState.normal)
        cancelButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelButton.titleLabel?.textAlignment = NSTextAlignment.left
        cancelButton.addTarget(self, action:#selector(buttonListener(sender:)), for: UIControlEvents.touchUpInside)
        
        let testUIBarButtonItem = UIBarButtonItem()
        testUIBarButtonItem.customView = doneButton
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        
        let leftUIBarButtonItem = UIBarButtonItem()
        leftUIBarButtonItem.customView = cancelButton
        self.navigationItem.leftBarButtonItem = leftUIBarButtonItem
        
    }
    
    func dataSource() {
        
        FirebaseDBHandler.sharedInstance.fetchData(table: "users", completionHandler: {responseDictionary in
            
            self.contactsArray = responseDictionary.allKeys as! [String]
            print("contactsArray: \(self.contactsArray)")
            self.contactsNameArray = responseDictionary.allValues as! [Dictionary<String, String>]
            print("contactsNameArray: \(self.contactsNameArray)")
            
            
            self.contactsTable?.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedContactNumber = self.contactsNameArray[indexPath.row]["phoneNumber"]
        selectedContactName = self.contactsNameArray[indexPath.row]["firstName"]! + " " + self.contactsNameArray[indexPath.row]["lastName"]!
        print("selectedFilter: \(String(describing: selectedContactNumber))")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("row count: \(self.contactsNameArray.count)")
        return self.contactsNameArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdendifier, for: indexPath as IndexPath) as! ContactsTableViewCell
        
        let rowDictionary = self.contactsNameArray[indexPath.row] //self.arrayList[indexPath.row]
        let contactName = rowDictionary["firstName"]! + " " + rowDictionary["lastName"]!
        let contactMsisdn = rowDictionary["phoneNumber"]
        
        if contactMsisdn == userMsisdn {
            rowHeight = 0
            return cell
        }
        else{
            cell.nameLabel.text = contactName
            cell.msisdnLabel.text = contactMsisdn
            
            cell.nameLabel.sizeToFit()
            cell.msisdnLabel.sizeToFit()
            
            cell.frame.size.height = cell.nameLabel.frame.size.height + cell.msisdnLabel.frame.size.height + 25
            rowHeight = cell.frame.size.height
        }
        return cell
    }
    
    
    @objc func buttonListener(sender:UIButton) {
        
        let btnsendtag: UIButton = sender
        
        //chat button selected
        if btnsendtag.tag == 99 {
            
            let userID = Auth.auth().currentUser?.phoneNumber
            print("UserID: \(String(describing: userID))")
            print("self.selectedContactName: \(String(describing: self.selectedContactName))")
            print("self.selectedContactNumber: \(String(describing: self.selectedContactNumber)))")
            
            ChatsModel().checkIfChatExists(userID: userID!, recepientID: selectedContactNumber!, completionHandler: {(chatIDReturned) in
                
                //self.dismiss(animated: true, completion: {
                    let controller: ChatViewController = ChatViewController()
                    controller.selectedContactName = self.selectedContactName
                    controller.selectedContactNumber = self.selectedContactNumber
                    controller.selectedChatID = chatIDReturned
                    self.navigationController?.pushViewController(controller, animated: true)
                    
                //})
                
                
            })
            
        }
        
        //cancel button selected
        if btnsendtag.tag == 100 {
            
            dismiss(animated: true, completion: nil)
        }
    }
    
}
