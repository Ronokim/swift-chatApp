//
//  ChatsListViewController.swift
//  chatApp
//
//  Created by Ronald Kimutai on 26/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit

class ChatsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var chatsTableList: UITableView?
    var cellIdendifier: String = "ChatCell"
    var userID: String? = ""
    var chatsArray:[Any] = []
    //private var channels: [Channel] = []
    //private var channels:[]?
    
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
        print("UserID: \(String(describing: userID))")
        self.loadChats()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //fetch all chats user is in
    func loadChats(){
        
        ChatsModel().getAllChats(userID: userID!, completionHandler: {chatsDictionary in
            let chatsDictionaryArray = chatsDictionary.allValues
            print("chatsDictionaryArray: \(chatsDictionaryArray))")
            for chatDictionary in chatsDictionaryArray[0] as! NSDictionary {
                
                if let chatValue = chatDictionary.value as? NSDictionary, let chatKey = chatDictionary.key as? AnyObject {
                    
                    let dataDict = [chatKey:chatValue] as NSMutableDictionary
                    self.chatsArray.append(dataDict)
                }
            }
            self.chatsTableList?.reloadData()
        })
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
        print("messageDictionary: \(messageDictionary)")
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
        
        let controller: ChatViewController = ChatViewController()
        //controller.selectedContactName = self.selectedContactName
        //controller.selectedContactNumber = self.selectedContactNumber
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
            let navController = UINavigationController(rootViewController: newContactView)
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    
    }
}
