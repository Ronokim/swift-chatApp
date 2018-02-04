//
//  UserModel.swift
//  chatApp
//
//  Created by Ronald Kimutai on 30/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import Foundation

class UserModel {
    
    var DBRef = FirebaseDBHandler.sharedInstance
    
    
    func checkIfUserExists(msisdn: String, completionHandler:@escaping (NSDictionary) -> ()) {
        
        DBRef.fetchData(table: "users/"+msisdn, completionHandler: {responseDictionary in
            print("responseDictionary\(responseDictionary)")
            completionHandler(responseDictionary)
        })
        
    }
}


