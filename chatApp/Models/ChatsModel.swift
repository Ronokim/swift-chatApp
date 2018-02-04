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
        
        DBRef.ObserveFilteredData(table: "chats", column: "users/"+userID, values: true, completionHandler: {(responseDictionary) in completionHandler(responseDictionary)
        })
        
    }
    
    func dumpAllChats(userID: String, completionHandler:@escaping (NSDictionary) -> ())  {
                DBRef.fetchQueryData(table: "chats", column: "users/"+userID, values: true, completionHandler: {(responseDictionary) in
        
                    completionHandler(responseDictionary)
                })
    }
    
    
    func observeLastMessageChange(chatID: String, completionHandler:@escaping (NSDictionary) -> ()) {
        
        DBRef.ObserveDataChanged(table: "chats", column: chatID, completionHandler: {(responseDictionary) in completionHandler(responseDictionary)
        })
        
    }
    
    
    func checkIfChatExists(userID: String, recepientID: String, completionHandler:@escaping (String) -> ()) {
        
        DBRef.fetchQueryData(table: "chats", column: "users/"+userID, values: true, completionHandler: {(responseDictionary) in
             print("responseDictionary: \(responseDictionary)")
            
            
            if let responseCode = responseDictionary["responseCode"]{
                print("responseCode: \(responseCode)")
                if responseCode as! String == "1" || responseCode as! String == "0" {
                    //   print("responseCode as! String: \(responseCode as! String)")
                    completionHandler("")
                }
            }
            else {
                var chatID: String = ""
                let chatsDictionaryArray = responseDictionary.allValues
                 for (key,value) in chatsDictionaryArray[0] as! NSDictionary{
                    let valueDict = value as! NSDictionary
                    let usersArray = (valueDict["users"] as! NSDictionary).allKeys as NSArray
                    
                    if usersArray.contains(recepientID)
                    {
                         chatID = key as! String
                    }
                    else
                    {
                        print("chat does not exists for receipient: \(recepientID)")
                        //completionHandler("")
                    }
                }
                completionHandler(chatID)
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
    
    
    func updateLastMessage(chatID: String, lastMessage: String, completionHandler:@escaping (Bool) -> ()) {
        
        DBRef.updateFunction(referenceToUpdate: "chats/"+chatID, newValues: ["lastMessage":lastMessage], completionHandler: {response in
            completionHandler(response)
        })
   
    }
}
