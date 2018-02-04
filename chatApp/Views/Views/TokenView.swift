//
//  TokenView.swift
//  chatApp
//
//  Created by Ronald Kimutai on 28/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit

class TokenView: UIView {
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
        
        let bodyContainerView: UIView = UIView(frame: CGRect(x : (screenWidth - screenWidth*0.95)/2, y : 5, width :screenWidth*0.95, height : screenHeight*0.7 ) )
        bodyContainerView.backgroundColor = UIColor.clear
        bodyContainerView.layer.cornerRadius = 4
        scrollView.addSubview(bodyContainerView)
        
        let tokenLabel : UILabel = UILabel(frame : CGRect(x : 5, y : 10, width : bodyContainerView.frame.size.width, height : 25))
        tokenLabel.text = "Enter authentication token received"
        tokenLabel.textColor = UIColor.formLabelsColor.defaultLabelColor
        tokenLabel.font = UIFont.boldSystemFont(ofSize: 16)
        tokenLabel.textAlignment = NSTextAlignment.left
        bodyContainerView.addSubview(tokenLabel)
        
        let tokenText : UITextField = UITextField(frame : CGRect(x : 5, y : tokenLabel.frame.size.height + tokenLabel.frame.origin.y + 10, width: bodyContainerView.frame.size.width - 10, height : 40))
        tokenText.placeholder = " Enter token"
        tokenText.backgroundColor = UIColor.clear
        tokenText.textColor = UIColor.black
        tokenText.layer.cornerRadius = 4
        tokenText.textAlignment = NSTextAlignment.left
        tokenText.tag = 1
        tokenText.layer.borderColor = UIColor.lightGray.cgColor
        tokenText.layer.borderWidth = 1
        tokenText.keyboardType = .numberPad
        bodyContainerView.addSubview(tokenText)
        
        
        
        let saveButton : UIButton = UIButton(frame : CGRect(x : 0, y : tokenText.frame.size.height + tokenText.frame.origin.y + 15, width: bodyContainerView.frame.size.width, height : 40))
        saveButton.backgroundColor = UIColor.buttonColor.defaultButtonColor
        saveButton.setTitle("CONFIRM", for: UIControlState.normal)
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
