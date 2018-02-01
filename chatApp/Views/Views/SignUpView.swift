//
//  SignUpView.swift
//  chatApp
//
//  Created by Ronald Kimutai on 26/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit

class SignUpView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var scrollView :UIScrollView = UIScrollView()
    let screenSize: CGRect = UIScreen.main.bounds
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let viewController = SignUpViewController()
        
        scrollView = UIScrollView(frame: CGRect(x : 0, y : 0, width : screenWidth, height : screenHeight))
        scrollView.backgroundColor = UIColor.backGroundColor.plainColor
        self.addSubview(scrollView)
        
        let bodyContainerView: UIView = UIView(frame: CGRect(x : (screenWidth - screenWidth*0.95)/2, y : 5, width :screenWidth*0.95, height : screenHeight))
        bodyContainerView.backgroundColor = UIColor.clear
        bodyContainerView.layer.cornerRadius = 4
        scrollView.addSubview(bodyContainerView)
        
        let firstNameLabel : UILabel = UILabel(frame : CGRect(x : 5, y : 5, width : bodyContainerView.frame.size.width, height : 25))
        firstNameLabel.text = "First Name"
        firstNameLabel.textColor = UIColor.formLabelsColor.defaultLabelColor
        firstNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        firstNameLabel.textAlignment = NSTextAlignment.left
        bodyContainerView.addSubview(firstNameLabel)
        
        let firstNameText : UITextField = UITextField(frame : CGRect(x : 5, y : firstNameLabel.frame.size.height + firstNameLabel.frame.origin.y + 5, width: bodyContainerView.frame.size.width - 10, height : 40))
        firstNameText.placeholder = " Enter first name"
        firstNameText.backgroundColor = UIColor.clear
        firstNameText.textColor = UIColor.black
        firstNameText.layer.cornerRadius = 4
        firstNameText.textAlignment = NSTextAlignment.left
        firstNameText.tag = 1
        firstNameText.layer.borderColor = UIColor.lightGray.cgColor
        firstNameText.layer.borderWidth = 1
        bodyContainerView.addSubview(firstNameText)
        
        
        let lastNameLabel : UILabel = UILabel(frame : CGRect(x : 5, y : firstNameText.frame.size.height + firstNameText.frame.origin.y + 5, width : bodyContainerView.frame.size.width - 10, height : 25))
        lastNameLabel.text = "Last Name"
        lastNameLabel.textColor = UIColor.formLabelsColor.defaultLabelColor
        lastNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        lastNameLabel.textAlignment = NSTextAlignment.left
        bodyContainerView.addSubview(lastNameLabel)
        
        let lastNameText : UITextField = UITextField(frame : CGRect(x : 5, y : lastNameLabel.frame.size.height + lastNameLabel.frame.origin.y + 5, width: bodyContainerView.frame.size.width - 10, height : 40))
        lastNameText.placeholder = " Enter last name"
        lastNameText.backgroundColor = UIColor.clear
        lastNameText.textColor = UIColor.black
        lastNameText.layer.cornerRadius = 4
        lastNameText.textAlignment = NSTextAlignment.left
        lastNameText.tag = 2
        lastNameText.layer.borderColor = UIColor.lightGray.cgColor
        lastNameText.layer.borderWidth = 1
        bodyContainerView.addSubview(lastNameText)
        
        
        let msisdnLabel : UILabel = UILabel(frame : CGRect(x : 5, y : lastNameText.frame.size.height + lastNameText.frame.origin.y + 5 , width : bodyContainerView.frame.size.width, height : 25))
        msisdnLabel.text = "Phone number"
        msisdnLabel.textColor = UIColor.formLabelsColor.defaultLabelColor
        msisdnLabel.font = UIFont.boldSystemFont(ofSize: 16)
        msisdnLabel.textAlignment = NSTextAlignment.left
        bodyContainerView.addSubview(msisdnLabel)
        
        let msisdnText : UITextField = UITextField(frame : CGRect(x : 5, y : msisdnLabel.frame.size.height + msisdnLabel.frame.origin.y + 5, width: bodyContainerView.frame.size.width - 10, height : 40))
        msisdnText.placeholder = " Enter phone number"
        msisdnText.backgroundColor = UIColor.clear
        msisdnText.textColor = UIColor.black
        msisdnText.layer.cornerRadius = 4
        msisdnText.keyboardType = UIKeyboardType.emailAddress
        msisdnText.textAlignment = NSTextAlignment.left
        msisdnText.tag = 7
        msisdnText.layer.borderColor = UIColor.lightGray.cgColor
        msisdnText.layer.borderWidth = 1
        bodyContainerView.addSubview(msisdnText)
        
        
        let emailLabel : UILabel = UILabel(frame : CGRect(x : 5, y : msisdnText.frame.size.height + msisdnText.frame.origin.y + 5 , width : bodyContainerView.frame.size.width, height : 25))
        emailLabel.text = "Email address"
        emailLabel.textColor = UIColor.formLabelsColor.defaultLabelColor
        emailLabel.font = UIFont.boldSystemFont(ofSize: 16)
        emailLabel.textAlignment = NSTextAlignment.left
        bodyContainerView.addSubview(emailLabel)
        
        let emailNameText : UITextField = UITextField(frame : CGRect(x : 5, y : emailLabel.frame.size.height + emailLabel.frame.origin.y + 5, width: bodyContainerView.frame.size.width - 10, height : 40))
        emailNameText.placeholder = " Enter email"
        emailNameText.backgroundColor = UIColor.clear
        emailNameText.textColor = UIColor.black
        emailNameText.layer.cornerRadius = 4
        emailNameText.keyboardType = UIKeyboardType.emailAddress
        emailNameText.textAlignment = NSTextAlignment.left
        emailNameText.tag = 3
        emailNameText.layer.borderColor = UIColor.lightGray.cgColor
        emailNameText.layer.borderWidth = 1
        bodyContainerView.addSubview(emailNameText)
        
        
        let passwordLabel : UILabel = UILabel(frame : CGRect(x : 5, y : emailNameText.frame.size.height + emailNameText.frame.origin.y + 5, width : bodyContainerView.frame.size.width - 10, height : 25))
        passwordLabel.text = "Create password"
        passwordLabel.textColor = UIColor.formLabelsColor.defaultLabelColor
        passwordLabel.font = UIFont.boldSystemFont(ofSize: 16)
        passwordLabel.textAlignment = NSTextAlignment.left
        bodyContainerView.addSubview(passwordLabel)
        
        let passwordText : UITextField = UITextField(frame : CGRect(x : 5, y : passwordLabel.frame.size.height + passwordLabel.frame.origin.y + 5, width: bodyContainerView.frame.size.width - 10, height : 40))
        passwordText.placeholder = " Enter password"
        passwordText.backgroundColor = UIColor.clear
        passwordText.textColor = UIColor.black
        passwordText.layer.cornerRadius = 4
        passwordText.isSecureTextEntry = true
        passwordText.textAlignment = NSTextAlignment.left
        passwordText.tag = 4
        passwordText.layer.borderColor = UIColor.lightGray.cgColor
        passwordText.layer.borderWidth = 1
        bodyContainerView.addSubview(passwordText)
        
        
        let confirmPasswordLabel : UILabel = UILabel(frame : CGRect(x : 5, y : passwordText.frame.size.height + passwordText.frame.origin.y + 5, width : bodyContainerView.frame.size.width - 10, height : 25))
        confirmPasswordLabel.text = "Confirm password"
        confirmPasswordLabel.textColor = UIColor.formLabelsColor.defaultLabelColor
        confirmPasswordLabel.font = UIFont.boldSystemFont(ofSize: 16)
        confirmPasswordLabel.textAlignment = NSTextAlignment.left
        bodyContainerView.addSubview(confirmPasswordLabel)
        
        let confirmPasswordText : UITextField = UITextField(frame : CGRect(x : 5, y : confirmPasswordLabel.frame.size.height + confirmPasswordLabel.frame.origin.y + 5, width: bodyContainerView.frame.size.width - 10, height : 40))
        confirmPasswordText.placeholder = " Re-enter password"
        confirmPasswordText.backgroundColor = UIColor.clear
        confirmPasswordText.textColor = UIColor.black
        confirmPasswordText.layer.cornerRadius = 4
        confirmPasswordText.isSecureTextEntry = true
        confirmPasswordText.textAlignment = NSTextAlignment.left
        confirmPasswordText.tag = 5
        confirmPasswordText.layer.borderColor = UIColor.lightGray.cgColor
        confirmPasswordText.layer.borderWidth = 1
        bodyContainerView.addSubview(confirmPasswordText)
        
        
        let saveButton : UIButton = UIButton(frame : CGRect(x : 0, y : confirmPasswordText.frame.size.height + confirmPasswordText.frame.origin.y + 15, width: bodyContainerView.frame.size.width, height : 40))
        saveButton.backgroundColor = UIColor.buttonColor.defaultButtonColor
        saveButton.setTitle("SIGN UP", for: UIControlState.normal)
        saveButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.titleLabel?.textAlignment = NSTextAlignment.center
        saveButton.clipsToBounds = true
        saveButton.isEnabled = true
        saveButton.layer.cornerRadius = 4
        saveButton.tag = 6
        saveButton.addTarget(viewController, action:#selector(viewController.buttonListener(sender:)), for: UIControlEvents.touchUpInside)
        bodyContainerView.addSubview(saveButton)
        
    }
}
