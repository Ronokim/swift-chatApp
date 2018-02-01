//
//  LoginView.swift
//  chatApp
//
//  Created by Ronald Kimutai on 26/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit

class LoginView: UIView {

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
        self.addCustomView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView() {
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height - 40
        let viewController = LoginViewController()
        
        self.backgroundColor = UIColor.backGroundColor.themeColor
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight ))
        scrollView.backgroundColor = UIColor.backGroundColor.themeColor
        self.addSubview(scrollView)
       
        
        let bodyContainer: UIView = UIView(frame: CGRect(x: (screenWidth - screenWidth*0.95)/2, y: screenHeight * 0.3, width:screenWidth*0.95, height: screenHeight*0.4 ) )
        bodyContainer.backgroundColor = UIColor.white
        bodyContainer.layer.cornerRadius = 4
        scrollView.addSubview(bodyContainer)
        
        let emailText : UITextField = UITextField(frame : CGRect(x : 5, y : 10, width: bodyContainer.frame.size.width - 10, height : 40))
        emailText.placeholder = " Enter email"
        emailText.backgroundColor = UIColor.white
        emailText.textColor = UIColor.black
        emailText.layer.cornerRadius = 4
        emailText.keyboardType = UIKeyboardType.emailAddress
        emailText.textAlignment = NSTextAlignment.left
        emailText.tag = 1
        emailText.layer.borderColor = UIColor.lightGray.cgColor
        emailText.layer.borderWidth = 1
        emailText.delegate = viewController
        emailText.returnKeyType = UIReturnKeyType.done
        bodyContainer.addSubview(emailText)
        
        
        let passwordText : UITextField = UITextField(frame : CGRect(x : 5, y : emailText.frame.origin.y + emailText.frame.size.height + 15, width: bodyContainer.frame.size.width - 10, height : 40))
        passwordText.placeholder = " Enter password"
        passwordText.backgroundColor = UIColor.white
        passwordText.textColor = UIColor.black
        passwordText.layer.cornerRadius = 4
        passwordText.keyboardType = UIKeyboardType.default
        passwordText.textAlignment = NSTextAlignment.left
        passwordText.isSecureTextEntry = true
        passwordText.tag = 2
        passwordText.layer.borderColor = UIColor.lightGray.cgColor
        passwordText.layer.borderWidth = 1
        passwordText.delegate = viewController
        passwordText.returnKeyType = UIReturnKeyType.done
        bodyContainer.addSubview(passwordText)
        
        
        let loginButton : UIButton = UIButton(frame : CGRect(x : 5, y : passwordText.frame.size.height + passwordText.frame.origin.y + 15, width: bodyContainer.frame.size.width - 10, height : 40))
        loginButton.backgroundColor = UIColor.black
        loginButton.setTitle("LOGIN", for: UIControlState.normal)
        loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loginButton.titleLabel?.textAlignment = NSTextAlignment.center
        loginButton.clipsToBounds = true
        loginButton.isEnabled = true
        loginButton.layer.cornerRadius = 8
        loginButton.tag = 4
        bodyContainer.addSubview(loginButton)
        
        
        let forgotButton : UIButton = UIButton(frame : CGRect(x : 0, y : loginButton.frame.size.height + loginButton.frame.origin.y + 10, width: (bodyContainer.frame.size.width * 0.5)  , height : 30))
        forgotButton.backgroundColor = UIColor.clear
        forgotButton.setTitle("Forgot password?", for: UIControlState.normal)
        forgotButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        forgotButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        forgotButton.titleLabel?.textAlignment = NSTextAlignment.center
        forgotButton.clipsToBounds = true
        forgotButton.isEnabled = true
        forgotButton.tag = 6
        bodyContainer.addSubview(forgotButton)
        
        
    }
}
