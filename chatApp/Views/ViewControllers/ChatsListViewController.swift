//
//  ChatsListViewController.swift
//  chatApp
//
//  Created by Ronald Kimutai on 26/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, dismissContactsListDelegate {

    var chatsTableList: UITableView?
    var cellIdendifier: String = "ChatCell"
    var userID: String? = ""
    var chatsArray:[Any] = []
    
    override func loadView() {
        super.loadView()
        
        self.title = "Chats"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.backGroundColor.themeColor
        self.navigationController?.navigationBar.barTintColor = UIColor.backGroundColor.themeColor
        UINavigationBar.appearance().tintColor = UIColor.white
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let chatsView = ChatsListView(frame: CGRect.zero)
        self.view = chatsView
        
        chatsTableList =  self.view.viewWithTag(1) as! UITableView?
        chatsTableList?.register(ChatsTableViewCell.self, forCellReuseIdentifier: cellIdendifier)
        chatsTableList?.tableFooterView = UIView()
        chatsTableList?.delegate = self
        chatsTableList?.dataSource = self
        userID = UserDefaults.standard.string(forKey: "verifiedUser")
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.loadChats()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //fetch all chats user is in
    func loadChats(){
        self.chatsArray.removeAll()
        ChatsModel().getAllChats(userID: userID!, completionHandler: {chatsDictionary in
             let chatsDictionaryArray = chatsDictionary as NSDictionary
            
            for chatDictionary in chatsDictionaryArray {
                
                if let chatValue = chatDictionary.value as? NSDictionary, let chatKey = chatDictionary.key as? AnyObject {
                    
                    let dataDict = [chatKey:chatValue] as NSMutableDictionary
                    self.chatsArray.append(dataDict)
                    
                    //listen for changes to last message
                    ChatsModel().observeLastMessageChange(chatID: chatKey as! String, completionHandler: {changeInData in
                        
                        let changeDictionaryArray = changeInData.allValues
                        let changeKey = changeInData.allKeys
                        self.updateLastMessage(lastMessage: changeDictionaryArray[0] as! String, changeKey: changeKey[0] as! String,  chatID:  chatKey as! String )
                    })
                }
                
            }
            
            self.chatsTableList?.reloadData()
        })
    }
    
    
    //Update chat list with new message
    func updateLastMessage(lastMessage: String, changeKey: String, chatID: String)  {
        
        for (index,chat) in chatsArray.enumerated() {
            
            let rowDictionary = chat as! NSDictionary
            let chatKey = rowDictionary.allKeys
            
            let messageValues = rowDictionary.allValues
            let messageDictionary = messageValues[0] as! NSMutableDictionary
            
            if chatID == chatKey[0] as? String{
                //change the dictionary
                messageDictionary.removeObject(forKey: changeKey)
                messageDictionary.setValue(lastMessage, forKey: changeKey)
              
                //create new dictionary
                let newDict = [chatID:messageDictionary] as NSMutableDictionary
                
                //push new dictionary to the array
                chatsArray[index] = newDict
                
                //update the table row with new data
                let indexPath = IndexPath(item: index, section: 0)
                chatsTableList?.reloadRows(at: [indexPath], with: .top)
                
            }
        }
      
    }
    
    // MARK :- UITableViewDelegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdendifier, for: indexPath as IndexPath) as! ChatsTableViewCell
        
        let rowDictionary = chatsArray[indexPath.row] as! NSMutableDictionary
       
        let messageValues = rowDictionary.allValues
        let messageDictionary = messageValues[0] as! NSDictionary
        
        let lastMessage = messageDictionary.value(forKey: "lastMessage")
        let usersArray = (messageDictionary.value(forKey: "users") as? NSDictionary)?.allKeys as NSArray?
        var recepient: String? = ""
        
        for msisdn in usersArray!{
            if msisdn as? String != userID{
                recepient = msisdn as? String
            }
        }
        
        cell.msisdnLabel.text = recepient
        cell.nameLabel.text = lastMessage as? String
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowDictionary = self.chatsArray[indexPath.row] as! NSMutableDictionary
        let chatID = rowDictionary.allKeys
        
        //get selected msisdn
        let messageValues = rowDictionary.allValues
        let messageDictionary = messageValues[0] as! NSDictionary
        let usersArray = (messageDictionary.value(forKey: "users") as? NSDictionary)?.allKeys as NSArray?
        var recepient: String? = ""
        
        for msisdn in usersArray!{
            if msisdn as? String != userID{
                recepient = msisdn as? String
            }
        }
        
        
        let controller: ChatViewController = ChatViewController()
        //controller.selectedContactName = self.selectedContactName
        controller.selectedContactNumber = recepient
        controller.selectedChatID = chatID[0] as? String
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - button actions
    @objc func buttonListener(sender:UIButton) {
        
        let btnsendtag: UIButton = sender
        
        if btnsendtag.tag == 2 {
            //new conversation button clicked.
            //direct user to select a contact to start a chat with
            
            let newContactView = ContactsTableViewController()
            newContactView.delegate = self
           
            let navController = UINavigationController(rootViewController: newContactView)
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    
    }
    
    
    // MARK: - dismiss contacts list method
    func dismissContactsListShowChatView(contactName: String, contactNumber: String) {
        
        let userID = Auth.auth().currentUser?.phoneNumber
        
        ChatsModel().checkIfChatExists(userID: userID!, recepientID: contactNumber, completionHandler: {(chatIDReturned) in
            
            let controller: ChatViewController = ChatViewController()
            controller.selectedContactName = contactName
            controller.selectedContactNumber = contactNumber
            controller.selectedChatID = chatIDReturned
            self.navigationController?.pushViewController(controller, animated: true)
            
        })
    }
}
