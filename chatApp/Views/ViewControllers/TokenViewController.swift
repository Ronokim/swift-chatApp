//
//  TokenViewController.swift
//  chatApp
//
//  Created by Ronald Kimutai on 28/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit
import FirebaseAuth

class TokenViewController: UIViewController, UITextFieldDelegate {
    
    var tapper : UITapGestureRecognizer? = nil
    var registerButtonRef : UIButton? = nil
    var tokenText : UITextField? = nil
    
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var password: String = ""
    
    override func loadView() {
        super.loadView()
        
        self.title = "Authentication"
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
        let pageView = TokenView(frame: CGRect.zero)
        self.view = pageView
        
        tokenText = self.view.viewWithTag(1) as! UITextField?
        
        registerButtonRef = self.view.viewWithTag(6) as! UIButton?
        registerButtonRef!.addTarget(self, action:#selector(buttonListener(sender:)), for: UIControlEvents.touchUpInside)
        
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
    @objc func handleSingleTap(sender:UIGestureRecognizer)
    {
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
    @objc func buttonListener(sender:UIButton)
    {
        let btnsendtag: UIButton = sender
        
        // MARK: - register Button clicked
        if btnsendtag.tag == 6
        {
            let verificationCode = tokenText?.text
            
            if(verificationCode?.isEmpty)!{
                
                let alert = UIAlertController.init(title: "", message: "Enter your first name", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                navigationController?.present(alert, animated: true, completion: nil)
                
            }
            else
            {
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID!,
                    verificationCode: verificationCode!)
                
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        // show error message
                        self.showMessagePrompt(messageToShow: error.localizedDescription)
                        return
                    }
                    else{
                        // User is signed in
                        print("User\(String(describing: user?.phoneNumber))")
                        UserDefaults.standard.set(user?.phoneNumber, forKey: "verifiedUser")
                        UserDefaults.standard.set(user?.uid, forKey: "verifiedUserID")
                        
                        let userData = ["firstName":self.firstName,"lastName":self.lastName,"phoneNumber":self.phoneNumber,"email":self.email,"uid":user?.uid,"credentials":self.email+"_"+self.password]
                        
                        FirebaseDBHandler.sharedInstance.addNewUser(table: "users", uniqueID: (user?.phoneNumber)!, values: userData as NSDictionary, completionHandler: {response in
                            if response == 1
                            {
                                let controller: LoginViewController = LoginViewController()
                                self.navigationController?.pushViewController(controller, animated: true)
                            }
                            else
                            {
                                let alert = UIAlertController.init(title: "", message: "An error occurred, please try again later.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                                self.navigationController?.present(alert, animated: true, completion: nil)
                            }
                        })
                    }
                }
                
            }
        }
    }
    
}
