//
//  ChatViewController.swift
//  chatApp
//
//  Created by Ronald Kimutai on 30/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {

    var selectedContactNumber: String? = ""
    var selectedContactName: String? = ""
    var selectedChatID: String? = ""
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func loadView() {
        super.loadView()
        
        self.title = selectedContactName ?? "Chats"
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
        self.senderId = Auth.auth().currentUser?.phoneNumber
        self.senderDisplayName = UserDefaults.standard.string(forKey: "senderName")
        
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        self.observeMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func observeMessages(){
        MessagesModel().getAllMessages(chatID: selectedChatID!, completionHandler: {messageData in
            print("UI :- messageData\(messageData)")
            if let id = messageData["senderId"] as! String!, let name = messageData["senderName"] as! String!, let text = messageData["text"] as! String!, text.characters.count > 0 {
                
                self.addMessage(withId: id, name: name, text: text)
                
                self.finishReceivingMessage()
            } else {
                print("UI :-Error! Could not decode message data")
            }
            
        })
    }
    
    
    private func getChatID(){
        
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    
    // MARK :- UICollectionViewDelegate methods
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    //remove avatars
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    //add message to displays
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let messageItem = ["senderId": senderId!,"senderName": senderDisplayName!,"text": text!,"timestamp": ""]
        
        // first time chatting between the two users
        if selectedChatID == ""{
            
            //create a new chat
            ChatsModel().createNewChat(userID: senderId!, recepientID: selectedContactNumber!, lastMessage: text!, completionHandler: {newChatCreated in
                
                if newChatCreated{
                    //now retrieve the chatID created to start a new line of messages
                    ChatsModel().checkIfChatExists(userID: senderId!, recepientID: self.selectedContactNumber!, completionHandler: {chatID in
                        
                        if chatID != ""{
                            
                            self.selectedChatID = chatID
                            
                            //create new message
                            MessagesModel().createNewMessage(chatID: chatID, newChat: messageItem as NSDictionary, completionHandler: {messageSaved in
                                
                                if messageSaved{
                                    JSQSystemSoundPlayer.jsq_playMessageSentSound()
                                }
                                self.finishSendingMessage()
                            })
                        }
                        
                    })
                    
                }
                else {
                    //failed to create new chat
                }
            })
        }
        else{
            //use existing chat ID to add messages to their chats
            //create new message
            MessagesModel().createNewMessage(chatID: self.selectedChatID!, newChat: messageItem as NSDictionary, completionHandler: {messageSaved in
                
                if messageSaved{
                    JSQSystemSoundPlayer.jsq_playMessageSentSound()
                }
                self.finishSendingMessage()
            })
        }
    }
}
