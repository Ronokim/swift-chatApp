//
//  FirebaseDBHandler.swift
//  chatApp
//
//  Created by Ronald Kimutai on 28/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

public class FirebaseDBHandler
{
    var databaseRef: DatabaseReference!
    static let   sharedInstance = FirebaseDBHandler()
    var response: NSDictionary? = nil
    
    private init()
    {
        print("init called")
        databaseRef = Database.database().reference()
    }
    
    public func addNewRecord(table: String, uniqueID: String, values: NSDictionary, completionHandler:@escaping (Bool) -> ())
    {
        self.databaseRef.child(table).child(uniqueID).childByAutoId().setValue(values){ (error, ref) -> Void in
            if (error != nil) {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
    
    
    public func addNewRecordWithAutoID(table: String, values: NSDictionary, completionHandler:@escaping (Bool) -> ())
    {
        self.databaseRef.child(table).childByAutoId().setValue(values){ (error, ref) -> Void in
            if (error != nil) {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
    
    
    public func fetchData(table: String, completionHandler:@escaping (NSDictionary) -> ())
    {
        databaseRef.child(table).observe(.value, with: { snapshot in
            self.response = snapshot.value as? NSDictionary
            completionHandler(self.response!)
        })
        { (error) in
            self.response = ["responseCode":"0", "responseMessage":error.localizedDescription]
            completionHandler(self.response!)
        }
    }
    
    
    public func fetchFilteredData(table: String, column: String, values: Any, completionHandler:@escaping (NSDictionary) -> ())
    {
        databaseRef.child(table).queryOrdered(byChild: column).observeSingleEvent(of: .value, with: { (snapshot) in
            print("snapshot: \(snapshot)")
            if let dic = snapshot.value as? NSDictionary{
                self.response = dic
            }
            else{
                self.response = ["responseCode":"1", "responseMessage":"Data doesn't exist"]
            }
            
            completionHandler(self.response!)
        })
        { (error) in
            self.response = ["responseCode":"0", "responseMessage":error.localizedDescription]
            completionHandler(self.response!)
        }
    }
    
    
    public func fetchQueryData(table: String, column: String, values: Any, completionHandler:@escaping (NSDictionary) -> ())
    {
        databaseRef.child(table).queryOrdered(byChild: column).queryEqual(toValue: values).observeSingleEvent(of: .value, with: { (snapshot) in
            print("snapshot: \(snapshot)")
            
            if snapshot.childrenCount > 0
            {
               
                for childSnap in  snapshot.children.allObjects {
                    let snap = childSnap as! DataSnapshot
                    if let snapshotValue = snapshot.value as? NSDictionary, let snapVal = snapshotValue[snap.key] as? AnyObject {
                        
                        let dataDict = [snapVal:snapshotValue] as NSMutableDictionary
                        self.response = dataDict
                    }
                }
                print("all dataDict: \(self.response!)")
            }
            else
            {
                self.response = ["responseCode":"1", "responseMessage":"Data doesn't exist"]
            }
            
            
            
//            if let dic = snapshot.value as? NSDictionary{
//                self.response = dic
//            }
//            else{
//                self.response = ["responseCode":"1", "responseMessage":"Data doesn't exist"]
//            }
            
            completionHandler(self.response!)
        })
        { (error) in
            self.response = ["responseCode":"0", "responseMessage":error.localizedDescription]
            completionHandler(self.response!)
        }
    }
    
    
    public func ObserveData(table: String, column: String, values: Any, completionHandler:@escaping (NSDictionary) -> ())
    {
        //let dataQuery = databaseRef.child(table).queryOrdered(byChild: column).queryEqual(toValue: values)
        let dataQuery = databaseRef.child(table+"/"+column)
        dataQuery.observe(.childAdded, with: { (snapshot) -> Void in
            print("snapshot: \(snapshot)")
            
            if let dic = snapshot.value as? NSDictionary{
                self.response = dic
            }
            else{
                self.response = ["responseCode":"1", "responseMessage":"Data doesn't exist"]
            }

            
//            if snapshot.childrenCount > 1
//            {
//
//                for childSnap in  snapshot.children.allObjects {
//                    let snap = childSnap as! DataSnapshot
//                    if let snapshotValue = snapshot.value as? NSDictionary, let snapVal = snapshotValue[snap.key] as? AnyObject {
//
//                        let dataDict = [snapVal:snapshotValue] as NSMutableDictionary
//                        self.response = dataDict
//                    }
//                }
//                print("all dataDict: \(self.response!)")
//            }
//            else
//            {
//                self.response = ["responseCode":"1", "responseMessage":"Data doesn't exist"]
//            }
            
            completionHandler(self.response!)
        })
        { (error) in
            self.response = ["responseCode":"0", "responseMessage":error.localizedDescription]
            completionHandler(self.response!)
        }
    }
    
    
    public func addNewUser(table: String, uniqueID: String, values: NSDictionary, completionHandler:@escaping (Int) -> ())
    {
        self.databaseRef.child(table).child(uniqueID).setValue(values){ (error, ref) -> Void in
            if (error != nil) {
                completionHandler(0)
            } else {
                completionHandler(1)
            }
        }
    }
    
    
    public func attempToLogin(credentials: String, completionHandler:@escaping (Int) -> ())
    {
        var isValidUser: Int?
        
        let userID = Auth.auth().currentUser?.phoneNumber
        self.databaseRef.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            self.response = snapshot.value as? NSDictionary
            let savedCredentials = self.response?["credentials"] as? String ?? ""
            if savedCredentials == credentials{
                //user validated correctly
                isValidUser = 1
                
                //set user details
                let senderFirstName = (self.response?["firstName"] as! String)+" "+(self.response?["lastName"] as! String)
                 
                UserDefaults.standard.set(senderFirstName, forKey: "senderName")
            }
            else{
                //user valation failed
                isValidUser = 2
            }
            completionHandler(isValidUser!)
        }) { (error) in
            print(error.localizedDescription)
            //an error occured
            completionHandler(0)
        }
        
    }
}
