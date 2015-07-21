//
//  VCLogin.swift
//  TableDemo
//
//  Created by Jason Spence on 17/07/2015.
//  Copyright (c) 2015 Jason Spence. All rights reserved.
//

import UIKit

class VCLogin: UIViewController {

    @IBOutlet weak var login_FB: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        login_FB.addTarget(self, action: "loginFB:", forControlEvents: UIControlEvents.TouchUpInside)
        
          // Do any additional setup after loading the view.
    }
    
    func loginFB(sender:UIButton){
    
        let ref = Firebase(url: "https://miquiz.firebaseio.com")
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"], handler: {
            (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                println("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                println("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        
                        if error != nil
                        {
                           println("Login failed. \(error)")
                        }
                        else
                        {
                            
                            println("TEST")
                            
                            var view: VCMyQuizzes = self.storyboard?.instantiateViewControllerWithIdentifier("VCMyQuizzes") as! VCMyQuizzes
                            self.navigationController?.pushViewController(view, animated: true)
                            view.title = "miQuizzes" //Set the text
                            println("Logged in! \(authData)")
                        }
                })
            }
        })
        println("Function Works")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
