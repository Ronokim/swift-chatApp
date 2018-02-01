//
//  UserModel.swift
//  chatApp
//
//  Created by Ronald Kimutai on 30/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import Foundation

class UserModel: NSObject {
    
    var _firstName: String = ""
    var _lastName: String = ""
    private var _email: String = ""
    private var _msisdn: String = ""
    
//    init(firstName: String) {
//        self._firstName = firstName
//    }
//    
    public var firstName: String {
        get {
            return self._firstName
        }
        set {
            self._firstName = newValue
        }
    }
    
    public var lastName: String {
        get {
            return self._lastName
        }
        set {
            self._lastName = newValue
        }
    }
    
    public var email: String {
        get {
            return self._email
        }
        set {
            self._email = newValue
        }
    }
    
    public var msisdn: String {
        get {
            return self._msisdn
        }
        set {
            self._msisdn = newValue
        }
    }
}


