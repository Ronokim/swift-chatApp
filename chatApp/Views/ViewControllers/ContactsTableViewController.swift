//
//  ContactsTableViewController.swift
//  chatApp
//
//  Created by Ronald Kimutai on 30/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol dismissContactsListDelegate {
    func dismissContactsListShowChatView(contactName: String, contactNumber: String)
}

class ContactsTableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var delegate: dismissContactsListDelegate? = nil
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
       
        let cancelButton: UIButton = UIButton(frame: CGRect(x : 1, y : 5, width : 70, height : 30))
        cancelButton.tag = 100
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitle("Cancel", for: UIControlState.normal)
        cancelButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelButton.titleLabel?.textAlignment = NSTextAlignment.left
        cancelButton.addTarget(self, action:#selector(buttonListener(sender:)), for: UIControlEvents.touchUpInside)
        
        let leftUIBarButtonItem = UIBarButtonItem()
        leftUIBarButtonItem.customView = cancelButton
        self.navigationItem.leftBarButtonItem = leftUIBarButtonItem
        
    }
    
    func dataSource() {
        
        FirebaseDBHandler.sharedInstance.fetchData(table: "users", completionHandler: {responseDictionary in
            
            self.contactsArray = responseDictionary.allKeys as! [String]
            self.contactsNameArray = responseDictionary.allValues as! [Dictionary<String, String>]
            
            self.contactsTable?.reloadData()
        })
    }
    
    
    //MARK :- UITableView delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedContactNumber = self.contactsNameArray[indexPath.row]["phoneNumber"]
        selectedContactName = self.contactsNameArray[indexPath.row]["firstName"]! + " " + self.contactsNameArray[indexPath.row]["lastName"]!
        
        if(self.delegate != nil){
            dismissContactsListShowChatView(contactName: selectedContactName!, contactNumber: selectedContactName!)
        }
        else{
            print("delegate is nil")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.contactsNameArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdendifier, for: indexPath as IndexPath) as! ContactsTableViewCell
        
        let rowDictionary = self.contactsNameArray[indexPath.row]
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
    
    
    // MARK :- UIButton action method
    @objc func buttonListener(sender:UIButton) {
        
        let btnsendtag: UIButton = sender
        
        //cancel button selected
        if btnsendtag.tag == 100 {
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func dismissContactsListShowChatView(contactName: String, contactNumber: String){
        delegate?.dismissContactsListShowChatView(contactName: selectedContactName!, contactNumber: selectedContactNumber!)
        dismiss(animated: true, completion: nil)
    }
}
