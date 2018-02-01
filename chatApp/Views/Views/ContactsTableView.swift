//
//  ContactsTableView.swift
//  chatApp
//
//  Created by Ronald Kimutai on 30/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit

class ContactsTableView: UIView {

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
        let viewController = ContactsTableViewController()
        
        self.backgroundColor = UIColor.backGroundColor.themeColor
        
        let tableView : UITableView = UITableView(frame: CGRect(x: 0, y: 50, width:screenWidth, height: screenHeight))
        tableView.tag = 1
        tableView.delegate = viewController
        tableView.dataSource = viewController
        self.addSubview(tableView)
    }
}
