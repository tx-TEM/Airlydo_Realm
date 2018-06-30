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
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let cUser = GIDSignIn.sharedInstance().currentUser {
            print(cUser.profile.email)
        }else{
            print("nomail")
        }
        
        GIDSignIn.sharedInstance().signOut()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            statusText.text = "initializing..."
            
        } else {
            statusText.text = "PLease Login"
        }
        
        toggleAuthUI()
    }
    
    
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
        } else {
            statusText.text = "please Login"
        }
    }

}
