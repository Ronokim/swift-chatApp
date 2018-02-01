//
//  MessagesModel.swift
//  chatApp
//
//  Created by Ronald Kimutai on 01/02/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import Foundation

class MessagesModel{
    var DBRef = FirebaseDBHandler.sharedInstance
   
    func getAllMessages(chatID: String, completionHandler:@escaping (NSDictionary) -> ()) {
        
//        DBRef.fetchQueryData(table: "messages", column: chatID, values: chatID, completionHandler: {(responseDictionary) in
//
//            completionHandler(responseDictionary)
//        })
        
        DBRef.ObserveData(table: "messages", column: chatID, values: chatID, completionHandler: {(responseDictionary) in completionHandler(responseDictionary)
        })
        
    }
    
    
    func createNewMessage(chatID: String, newChat: NSDictionary, completionHandler:@escaping (Bool) -> ()) {
        
        DBRef.addNewRecordWithAutoID(table: "messages/"+chatID, values: newChat, completionHandler: {response in
            completionHandler(response)
        })
        
    }
}
