//
//  ChatsModel.swift
//  chatApp
//
//  Created by Ronald Kimutai on 31/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import Foundation

class ChatsModel{
    var DBRef = FirebaseDBHandler.sharedInstance
    
    
    func getAllChats(userID: String, completionHandler:@escaping (NSDictionary) -> ()) {
        
        DBRef.fetchQueryData(table: "chats", column: "users/"+userID, values: true, completionHandler: {(responseDictionary) in
            
            completionHandler(responseDictionary)
        })
        
    }
    
    
    func checkIfChatExists(userID: String, recepientID: String, completionHandler:@escaping (String) -> ()) {
        
        DBRef.fetchQueryData(table: "chats", column: "users/"+userID, values: true, completionHandler: {(responseDictionary) in
            print("responseDictionary: \(responseDictionary)")
            
            
            if let responseCode = responseDictionary["responseCode"]{
                print("responseCode: \(responseCode)")
                if responseCode as! String == "1" || responseCode as! String == "0" {
                    print("responseCode as! String: \(responseCode as! String)")
                    completionHandler("")
                }
            }
            else {
                for (key,value) in responseDictionary{
                    let valueDict = value as! NSDictionary
                    print("valueDict: \(valueDict)")
                    let usersArray = (valueDict["users"] as! NSDictionary).allKeys as NSArray
                    print("usersArray: \(usersArray)")
                    
                    if usersArray.contains(recepientID){
                        print("chat exists for key: \(key)")
                        completionHandler(key as! String)
                    }
                    else{
                        print("chat does not exists for receipient: \(recepientID)")
                        completionHandler("")
                    }
                }
            }
        })
        
    }
    
    
    func createNewChat(userID: String, recepientID: String, lastMessage: String, completionHandler:@escaping (Bool) -> ()) {
        
        let users = [userID:true,recepientID:true]
        let newChat = ["title":"private","lastMessage":lastMessage,"timestamp":"","users":users] as [String : Any]
        
        DBRef.addNewRecordWithAutoID(table: "chats", values: newChat as NSDictionary, completionHandler: {response in
            completionHandler(response)
        })
        
    }
    
    
    func updateLastMessage(chatID: String, lastMessage: String) -> Bool {
        
        return false
    }
}
