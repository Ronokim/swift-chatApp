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
        let screenHeight = screenSize.height
        let viewController = LoginViewController()
        
        scrollView = UIScrollView(frame: CGRect(x : 0, y : 0, width : screenWidth, height : screenHeight))
        scrollView.backgroundColor = UIColor.backGroundColor.plainColor
        self.addSubview(scrollView)
        
        let bodyContainerView: UIView = UIView(frame: CGRect(x : (screenWidth - screenWidth*0.95)/2, y : 5, width :screenWidth*0.95, height : screenHeight*0.7 ) )
        bodyContainerView.backgroundColor = UIColor.clear
        bodyContainerView.layer.cornerRadius = 4
        scrollView.addSubview(bodyContainerView)
        
        let phoneNumberLabel : UILabel = UILabel(frame : CGRect(x : 5, y : 10, width : bodyContainerView.frame.size.width, height : 25))
        phoneNumberLabel.text = "Enter your phone number"
        phoneNumberLabel.textColor = UIColor.formLabelsColor.defaultLabelColor
        phoneNumberLabel.font = UIFont.boldSystemFont(ofSize: 16)
        phoneNumberLabel.textAlignment = NSTextAlignment.left
        bodyContainerView.addSubview(phoneNumberLabel)
        
        let phoneNumberText : UITextField = UITextField(frame : CGRect(x : 5, y : phoneNumberLabel.frame.size.height + phoneNumberLabel.frame.origin.y + 10, width: bodyContainerView.frame.size.width - 10, height : 40))
        phoneNumberText.placeholder = " Enter phone number"
        phoneNumberText.text = "+254"
        phoneNumberText.backgroundColor = UIColor.clear
        phoneNumberText.textColor = UIColor.black
        phoneNumberText.layer.cornerRadius = 4
        phoneNumberText.textAlignment = NSTextAlignment.left
        phoneNumberText.tag = 1
        phoneNumberText.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberText.layer.borderWidth = 1
        phoneNumberText.keyboardType = .numbersAndPunctuation
        bodyContainerView.addSubview(phoneNumberText)
        
        
        
        let saveButton : UIButton = UIButton(frame : CGRect(x : 0, y : phoneNumberText.frame.size.height + phoneNumberText.frame.origin.y + 15, width: bodyContainerView.frame.size.width, height : 40))
        saveButton.backgroundColor = UIColor.buttonColor.defaultButtonColor
        saveButton.setTitle("NEXT", for: UIControlState.normal)
        saveButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.titleLabel?.textAlignment = NSTextAlignment.center
        saveButton.clipsToBounds = true
        saveButton.isEnabled = true
        saveButton.layer.cornerRadius = 4
        saveButton.tag = 2
        saveButton.addTarget(viewController, action:#selector(viewController.buttonListener(sender:)), for: UIControlEvents.touchUpInside)
        bodyContainerView.addSubview(saveButton)
        
        
    }
}
