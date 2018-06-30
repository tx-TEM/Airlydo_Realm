//
//  SignInViewController.swift
//  Airlydo
//
//  Created by yoshiki-t on 2018/06/28.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit
import GoogleSignIn


class SignInViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var button: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        statusText.text = "please Login"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let cUser = GIDSignIn.sharedInstance().currentUser {
            print(cUser.profile.email)
        }else{
            print("nomail")
        }
    }
}
