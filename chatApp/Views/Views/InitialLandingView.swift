//
//  InitialLandingView.swift
//  chatApp
//
//  Created by Ronald Kimutai on 26/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit

class InitialLandingView: UIView {

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
        let viewController = InitialLandingViewController()
        
        self.backgroundColor = UIColor.backGroundColor.themeColor
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight ))
        scrollView.backgroundColor = UIColor.backGroundColor.themeColor
        self.addSubview(scrollView)
        
        let logoView: UIView = UIView(frame: CGRect(x: (screenWidth - screenWidth*0.55)/2, y: 10, width:screenWidth*0.55, height: screenWidth*0.55 ) )
        logoView.backgroundColor = UIColor.white
        logoView.layer.cornerRadius = (screenWidth*0.55)/2
        scrollView.addSubview(logoView)
        
        let logoIcon: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: logoView.frame.size.width , height: logoView.frame.size.height))
        logoIcon.backgroundColor = UIColor.clear
        logoIcon.image = UIImage(named: "logo.png")
        logoIcon.clipsToBounds = true
        logoIcon.contentMode = UIViewContentMode.center
        logoView.addSubview(logoIcon)
        
        
        let bodyContainer: UIView = UIView(frame: CGRect(x: (screenWidth - screenWidth*0.95)/2, y: screenHeight * 0.7, width:screenWidth*0.95, height: screenHeight*0.25 ) )
        bodyContainer.backgroundColor = UIColor.clear
        bodyContainer.layer.cornerRadius = 4
        scrollView.addSubview(bodyContainer)
        
        
        let registerButton : UIButton = UIButton(frame : CGRect(x : 5, y :5, width: bodyContainer.frame.size.width - 10, height : 45))
        registerButton.backgroundColor = UIColor.black
        registerButton.setTitle("SIGN UP", for: UIControlState.normal)
        registerButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        registerButton.titleLabel?.textAlignment = NSTextAlignment.center
        registerButton.clipsToBounds = true
        registerButton.isEnabled = true
        registerButton.layer.cornerRadius = 8
        registerButton.tag = 4
        registerButton.addTarget(viewController, action:#selector(viewController.buttonListener(sender:)), for: UIControlEvents.touchUpInside)
        bodyContainer.addSubview(registerButton)
        
        
        let loginButton : UIButton = UIButton(frame : CGRect(x : 5, y : registerButton.frame.size.height + registerButton.frame.origin.y + 10, width: bodyContainer.frame.size.width - 10, height : 45))
        loginButton.backgroundColor = UIColor.clear
        loginButton.setTitle("LOGIN", for: UIControlState.normal)
        loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loginButton.titleLabel?.textAlignment = NSTextAlignment.center
        loginButton.clipsToBounds = true
        loginButton.isEnabled = true
        loginButton.tag = 5
        loginButton.layer.cornerRadius = 8
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 2
        loginButton.addTarget(viewController, action:#selector(viewController.buttonListener(sender:)), for: UIControlEvents.touchUpInside)
        bodyContainer.addSubview(loginButton)
        
    }
}
