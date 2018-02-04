//
//  LoginViewController.swift
//  chatApp
//
//  Created by Ronald Kimutai on 26/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var loginButtonRef : UIButton? = nil
    var tapper : UITapGestureRecognizer? = nil
    var phoneNumberText : UITextField? = nil
    var defaults: UserDefaults?
    
    override func loadView() {
        super.loadView()
        
        self.title = "Login"
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
        let loginView = LoginView(frame: CGRect.zero)
        self.view = loginView
        
        phoneNumberText = self.view.viewWithTag(1) as! UITextField?
        
        tapper = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(sender:)))
        tapper?.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapper!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { 
        textField.resignFirstResponder()
        
        return true
    }
    
    
    // MARK: - dismiss keyboard on tap outside UITextField
    @objc func handleSingleTap(sender:UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Show message in UIAlertViewController
    func showMessagePrompt(messageToShow: String)
    {
        let alert = UIAlertController.init(title: "", message: messageToShow, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - button actions
    @objc func buttonListener(sender:UIButton) {
        
        let btnsendtag: UIButton = sender
        
        if btnsendtag.tag == 2 {
            //  MARK: - login Button clicked
            let phoneString = phoneNumberText?.text
            
            if(phoneString?.isEmpty)!
            {
                
                let alert = UIAlertController.init(title: "", message: "Enter your phone number.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                navigationController?.present(alert, animated: true, completion: nil)
                
            }
            else
            {
                UserModel().checkIfUserExists(msisdn: phoneString!, completionHandler: {responseDictionary in
                    print("responseDictionary2: \(responseDictionary)")
                    if let responseMsisdn = responseDictionary["phoneNumber"]{
                        //  MARK: - user already registered. Authenticate phone number
                        print("user exists")
                        
                        let userName = (responseDictionary["firstName"] as! String)+" "+(responseDictionary["lastName"] as! String)
                        
                        PhoneAuthProvider.provider().verifyPhoneNumber(phoneString!, uiDelegate: nil) { (verificationID, error) in
                            if let error = error {
                                self.showMessagePrompt(messageToShow: error.localizedDescription)
                                return
                            }
                            //  MARK: - Sign in using the verificationID and the code sent to the user
                            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                            UserDefaults.standard.set(userName, forKey: "senderName")
                            
                            let controller: TokenViewController = TokenViewController()
                            controller.authenticationType = "Login"
                            controller.phoneNumber = responseMsisdn as! String
                            controller.verificationID = verificationID
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                    else{
                        //  MARK: - user is not registered. Go to registration view
                        let controller: SignUpViewController = SignUpViewController()
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                })
                
            }
            
        }
        
    }
    
}
