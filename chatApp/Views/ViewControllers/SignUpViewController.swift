//
//  SignUpViewController.swift
//  chatApp
//
//  Created by Ronald Kimutai on 26/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    var tapper : UITapGestureRecognizer? = nil
    var registerButtonRef : UIButton? = nil
    var firstNameText : UITextField? = nil
    var lastNameText : UITextField? = nil
    var emailText : UITextField? = nil
    var confirmPasswordText : UITextField? = nil
    var passwordText : UITextField? = nil
    var msisdnText : UITextField? = nil
    
    
    override func loadView() {
        super.loadView()
        
        self.title = "Sign up"
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
        let pageView = SignUpView(frame: CGRect.zero)
        self.view = pageView
        
        firstNameText = self.view.viewWithTag(1) as! UITextField?
        lastNameText = self.view.viewWithTag(2) as! UITextField?
        emailText = self.view.viewWithTag(3) as! UITextField?
        passwordText = self.view.viewWithTag(4) as! UITextField?
        confirmPasswordText = self.view.viewWithTag(5) as! UITextField?
        msisdnText = self.view.viewWithTag(7) as! UITextField?
       
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
        if btnsendtag.tag == 6 {
           
            let lastNameString = lastNameText?.text
            let firtNameString = firstNameText?.text
            let emailString = emailText?.text
            let msisdnString = msisdnText?.text
            
            if(firtNameString?.isEmpty)!{
                
                let alert = UIAlertController.init(title: "", message: "Enter your first name", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                navigationController?.present(alert, animated: true, completion: nil)
                
            }
            else if(lastNameString?.isEmpty)!{
                
                let alert2 = UIAlertController.init(title: "", message: "Enter your last name", preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                navigationController?.present(alert2, animated: true, completion: nil)
                
            }
            
            else if(msisdnString?.isEmpty)!{
                
                let alert = UIAlertController.init(title: "", message: "Enter your phone number", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                navigationController?.present(alert, animated: true, completion: nil)
                
            }
                
            else if(emailString?.isEmpty)!{
                
                let alert = UIAlertController.init(title: "", message: "Enter your email address", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                navigationController?.present(alert, animated: true, completion: nil)
                
            }
            else
            {
                PhoneAuthProvider.provider().verifyPhoneNumber(msisdnString!, uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        self.showMessagePrompt(messageToShow: error.localizedDescription)
                        return
                    }
                    // Sign in using the verificationID and the code sent to the user
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                   
                    let controller: TokenViewController = TokenViewController()
                    controller.firstName = firtNameString!
                    controller.lastName = lastNameString!
                    controller.phoneNumber = msisdnString!
                    controller.email = emailString!
                    controller.authenticationType = "Registration"
                    controller.verificationID = verificationID
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
        
    }

}
