//
//  UserObject.swift
//  chatApp
//
//  Created by Ronald Kimutai on 28/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import Foundation

public class UserObject : NSObject
{
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""
    
    func setUser(firstname: String, lastname: String, msisdn: String, email: String, password: String)
    {
        let newUser = UserObject()
        newUser.firstName = firstname
        newUser.lastName = lastname
        newUser.phoneNumber = msisdn
        newUser.email = email
        newUser.password = password
    }
    
    func getUser() -> NSDictionary
    {
        let userDictionary: NSDictionary = ["firstName":self.firstName,"lastName":self.lastName,"phoneNumber":self.phoneNumber,"email":self.email,"password":self.password]
        return userDictionary
    }
}
