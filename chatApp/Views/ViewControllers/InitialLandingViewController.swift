//
//  InitialLandingViewController.swift
//  chatApp
//
//  Created by Ronald Kimutai on 26/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit

class InitialLandingViewController: UIViewController {

    override func loadView() {
        super.loadView()
        
        self.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.backGroundColor.themeColor
        self.navigationController?.navigationBar.barTintColor = UIColor.backGroundColor.themeColor
        UINavigationBar.appearance().tintColor = UIColor.white
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let pageView = InitialLandingView(frame: CGRect.zero)
        self.view = pageView
      
//        UserDefaults.standard.set("test", forKey: "senderNameTest")
//        let user = UserModel()
//        user.firstName = "fsd"
//        print("Set user:\(user.firstName)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func buttonListener(sender:UIButton) {
        
        let btnsendtag: UIButton = sender
        
        if btnsendtag.tag == 4 {
            //  MARK: - sign up Button clicked
           
            let controller: SignUpViewController = SignUpViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        else if btnsendtag.tag == 5 {
            // MARK: - login Button clicked
            
            let controller: LoginViewController = LoginViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
}
