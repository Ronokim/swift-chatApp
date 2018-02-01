//
//  LoginViewController.swift
//  chatApp
//
//  Created by Ronald Kimutai on 26/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {

    var loginButtonRef : UIButton? = nil
    var forgotPasswordButtonRef : UIButton? = nil
    var tapper : UITapGestureRecognizer? = nil
    var emailText : UITextField? = nil
    var passwordText : UITextField? = nil
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
        
        emailText = self.view.viewWithTag(1) as! UITextField?
        passwordText = self.view.viewWithTag(2) as! UITextField?
        
        loginButtonRef = self.view.viewWithTag(4) as! UIButton?
        loginButtonRef!.addTarget(self, action:#selector(buttonListener(sender:)), for: UIControlEvents.touchUpInside)
        
        forgotPasswordButtonRef = self.view.viewWithTag(6) as! UIButton?
        forgotPasswordButtonRef!.addTarget(self, action:#selector(buttonListener(sender:)), for: UIControlEvents.touchUpInside)
        
        tapper = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(sender:)))
        tapper?.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapper!)
        
        
//        let user = UserModel()
//        let storedUser = UserDefaults.standard.string(forKey: "senderNameTest")
//        print("Read user:\(storedUser ?? "Failed to get stored user")")
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
        
        if btnsendtag.tag == 4 {
            // login Button clicked
            let emailString = emailText?.text
            let passwordString = passwordText?.text
            
            if(emailString?.isEmpty)!
            {
                
                let alert = UIAlertController.init(title: "", message: "Enter your email address.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                navigationController?.present(alert, animated: true, completion: nil)
                
            }
            else if (passwordString?.isEmpty)!
            {
                
                let alert = UIAlertController.init(title: "", message: "Enter your password.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                navigationController?.present(alert, animated: true, completion: nil)
                
            }
            else
            {
                FirebaseDBHandler.sharedInstance.attempToLogin(credentials: emailString!+"_"+passwordString!, completionHandler: {isValidUser in
                    
                    if isValidUser == 1{
                        //set sender display name
                        let senderName = UserDefaults.standard.string(forKey: "senderName")
                        print("READ senderName: \(String(describing: senderName))")

                        let chatController: ChatViewController = ChatViewController() as ChatViewController
                        chatController.senderDisplayName = senderName
                        
                        let controller: ChatsListViewController = ChatsListViewController()
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    else  if isValidUser == 2{
                        
                        self.showMessagePrompt(messageToShow: "Invalid username / password")
                    }
                    else{
                        
                        self.showMessagePrompt(messageToShow: "An error occured please try again later")
                    }
                })
                
            }
           
        }
        else if btnsendtag.tag == 6 {
            //MARK - forgot password Button clicked
            
           
        }
        
    }

}
