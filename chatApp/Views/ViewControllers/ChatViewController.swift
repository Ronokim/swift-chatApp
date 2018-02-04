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

class ChatViewController: JSQMessagesViewController, JSQMessagesCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var selectedContactNumber: String? = ""
    var selectedContactName: String? = ""
    var selectedChatID: String? = ""
    var tappedCellIndexPath: IndexPath?
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func loadView() {
        super.loadView()
        
        self.title = selectedContactName ?? selectedContactNumber
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
        
        imagePicker.delegate = self
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        //self.observeMessages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.observeMessages()
    }
    
    private func observeMessages(){
        if(selectedChatID! != ""){
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
        
    }
    
    
    // MARK :- navigationBarButtons
    func manageNavigationBarItems(show: Bool) {
        print("manageNavigationBarItems")
        if(show){
          
            let reply = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(replyTapped))
            let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped))
            
            self.navigationItem.rightBarButtonItems = [reply, trash]
        }
        else{
            
            self.navigationItem.rightBarButtonItems?.removeAll()
            
        }
    }
    
    
    @objc func replyTapped()  {
        print("replyTapped")
        
        let messageSelected = messages[(tappedCellIndexPath?.item)!]
        
        self.showMessagePrompt(messageToShow: messageSelected.text,buttonTitle: "Reply")
    }
    
    @objc func trashTapped()  {
        print("trashTapped")
        let messageSelected = messages[(tappedCellIndexPath?.item)!]
        
        self.showMessagePrompt(messageToShow: messageSelected.text,buttonTitle: "Delete")
    }
    
    
    // MARK: - Show message in UIAlertViewController
    func showMessagePrompt(messageToShow: String, buttonTitle: String)
    {
        let alert = UIAlertController.init(title: "", message: messageToShow, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        navigationController?.present(alert, animated: true, completion: nil)
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
        cell.delegate = self as JSQMessagesCollectionViewCellDelegate
        cell.isUserInteractionEnabled = true
        cell.messageBubbleImageView.isUserInteractionEnabled = true
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
            
            selectedContactName = message.senderDisplayName
            if(self.title == ""){
                self.title = selectedContactName
            }
        }
        
        if !message.isMediaMessage {
            cell.textView.isSelectable = false
            cell.textView.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapCellAt indexPath: IndexPath!, touchLocation: CGPoint) {
        print("Tapped cell at \(touchLocation)")
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        print("didTapMessageBubbleAt")
        
    }
    
    // For showing name of the contact sending message..
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let data = self.collectionView(collectionView, messageDataForItemAt: indexPath)
        if self.senderDisplayName == data?.senderDisplayName() {
            return nil
        } 
        return NSAttributedString(string: (data?.senderDisplayName())!)
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let data = self.collectionView(collectionView, messageDataForItemAt: indexPath)
        
        if self.senderDisplayName == data?.senderDisplayName(){
            return 0.0
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    
    //remove avatars
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    // MARK :- JSQMessagesCollectionViewCellDelegate methods
    func messagesCollectionViewCellDidTapAvatar(_ cell: JSQMessagesCollectionViewCell!) {
        
    }
    
    func messagesCollectionViewCellDidTapMessageBubble(_ cell: JSQMessagesCollectionViewCell!) {
        print("messagesCollectionViewCellDidTapMessageBubble")
        
        tappedCellIndexPath = self.collectionView.indexPath(for: cell)
        
        if cell.contentView.backgroundColor ==  UIColor.black.withAlphaComponent(0.7){
            cell.contentView.backgroundColor =  UIColor.white
            self.manageNavigationBarItems(show: false)
        }
        else {
            cell.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.manageNavigationBarItems(show: true)
        }
        
    }
    
    func messagesCollectionViewCellDidTap(_ cell: JSQMessagesCollectionViewCell!, atPosition position: CGPoint) {
        print("messagesCollectionViewCellDidTap")
        
        //let message = messages[indexPath.item]
        
    }
    
    func messagesCollectionViewCell(_ cell: JSQMessagesCollectionViewCell!, didPerformAction action: Selector!, withSender sender: Any!) {
        print("messagesCollectionViewCell")
    }
    
    
    //add message to displays
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    
    // MARK :- Send button pressed method
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
                            self.sendMessage(text: text!, messageToSend: messageItem as NSDictionary, completionHandler: {messageSaved in
                                
                                if messageSaved{
                                    
                                    self.observeMessages()
                                }
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
            self.sendMessage(text: text!, messageToSend: messageItem as NSDictionary, completionHandler: {messageSaved in
                
                if messageSaved{
                    //self.observeMessages()
                }
            })
        }
    }
    
    
    // MARK :- Accessory button method
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let actionSheet =  UIAlertController(title: "Select media from?", message: "", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: {
            (_:UIAlertAction)in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let video = UIAlertAction(title: "Video", style: .default, handler: {
            (_:UIAlertAction)in
            //self.imagePicker.mediaTypes = [kUTTypeVideo as String]
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let gallery = UIAlertAction(title: "Gallery", style: .default, handler: {
            (_:UIAlertAction)in
            self.imagePicker.sourceType =  .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(camera)
        actionSheet.addAction(video)
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let pickedImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imgMedia =  JSQPhotoMediaItem(image: pickedImg)
            messages.append(JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: Date(), media: imgMedia))
        }
        else if let mediaURL = info[UIImagePickerControllerMediaURL] as? URL{
            let imgURL = JSQVideoMediaItem(fileURL: mediaURL, isReadyToPlay: true)
            messages.append(JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: Date(), media: imgURL))
        }
        self.finishSendingMessage()
        JSQSystemSoundPlayer.jsq_playMessageSentAlert()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled")
    }
    
    
    // Call to send message
    func sendMessage(text: String, messageToSend: NSDictionary, completionHandler:@escaping (Bool) -> ())  {
        
        MessagesModel().createNewMessage(chatID: self.selectedChatID!, newChat: messageToSend, completionHandler: {messageSaved in
            
            if messageSaved{
                print("messageSaved true on UI")
                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                self.updateLastMessage(message: text)
            }
            self.finishSendingMessage()
            completionHandler(messageSaved)
        })
    
    }
    
    
    // Update last message on chats node
    func updateLastMessage(message: String)  {
        
        ChatsModel().updateLastMessage(chatID: self.selectedChatID!, lastMessage: message, completionHandler: {messageUpdated in
            if messageUpdated{
                //
            }
        })
        
    }
    
}
