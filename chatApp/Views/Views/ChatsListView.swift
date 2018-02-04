//
//  ChatsListView.swift
//  chatApp
//
//  Created by Ronald Kimutai on 26/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit

class ChatsListView: UIView {

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
        let viewController = ChatsListViewController()
        
        self.backgroundColor = UIColor.backGroundColor.themeColor
 
        let tableView : UITableView = UITableView(frame: CGRect(x: 0, y: 0, width:screenWidth, height: screenHeight))
        tableView.tag = 1
        tableView.dataSource = viewController
        tableView.delegate = viewController
        self.addSubview(tableView)
        
        let newContactButton : UIButton = UIButton(frame: CGRect(x: screenWidth * 0.80, y: screenHeight * 0.80, width: 60, height: 60))
        newContactButton.tag = 2
        newContactButton.backgroundColor = UIColor.buttonColor.defaultButtonColor
        newContactButton.layer.cornerRadius = 30
        newContactButton.addTarget(viewController, action:#selector(viewController.buttonListener(sender:)), for: UIControlEvents.touchUpInside)
        newContactButton.setImage(UIImage(named: "ic_add.png"), for: .normal)
        self.addSubview(newContactButton)
        
    }
}
