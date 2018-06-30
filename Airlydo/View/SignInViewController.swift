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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            statusText.text = "initializing..."
            GIDSignIn.sharedInstance().signInSilently()
            
        } else {
            statusText.text = "PLease Login"
        }
        
    }
    
}

// Google Sign-in
extension SignInViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            print(user.profile.email)
        }
        
        let ContainerViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
        self.present(ContainerViewController, animated: true, completion: nil)
        GIDSignIn.sharedInstance().delegate = UIApplication.shared.delegate as! AppDelegate
        print("SignInView")

    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}
