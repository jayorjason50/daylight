//
//  VCLogin.swift
//  TableDemo
//
//  Created by Jason Spence on 17/07/2015.
//  Copyright (c) 2015 Jason Spence. All rights reserved.
//

import UIKit

class VCLogin: UIViewController, UIActionSheetDelegate {

    @IBOutlet weak var login_FB: UIButton!
    
    @IBOutlet weak var login_Twitter: UIButton!
   
    var ref: Firebase!
    var authHelper: TwitterAuthHelper!
    var accounts: [ACAccount]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url:"https://miquiz.firebaseio.com")
        authHelper = TwitterAuthHelper(firebaseRef: ref, apiKey: "mePjllXD6Pg8Flxt1IC5PaYsR")
        login_FB.addTarget(self, action: "loginFB:", forControlEvents: UIControlEvents.TouchUpInside)
        login_Twitter.addTarget(self, action: "loginTwitter:", forControlEvents: UIControlEvents.TouchUpInside)
        
          // Do any additional setup after loading the view.
    }
    
    func loginFB(sender:UIButton){
        
        
        //let ref = Firebase(url: "https://miquiz.firebaseio.com")
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"], handler: {
            (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                println("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                println("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                self.ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        
                        if error != nil
                        {
                           println("Login failed. \(error)")
                        }
                        else
                        {
                            
                            println("Auth Data \(authData)")
                            println("UID \(authData.uid)")
                            self.performSegueWithIdentifier("toTabBar", sender: self)
                        }
                })
            }
        })
        
       
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginTwitter(sender:UIButton){
        
     
//        let ref = Firebase(url: "https://miquiz.firebaseio.com")
//        let twitterAuthHelper = TwitterAuthHelper(firebaseRef: ref, apiKey:"mePjllXD6Pg8Flxt1IC5PaYsR")
//        
//        twitterAuthHelper.selectTwitterAccountWithCallback { error, accounts in
//            if error != nil {
//               println("Error") // Error retrieving Twitter accounts
//            } else if accounts.count >= 1 {
//                // Select an account. Here we pick the first one for simplicity
//                let account = accounts[0] as? ACAccount
//                twitterAuthHelper.authenticateAccount(account, withCallback: { error, authData in
//                    if error != nil {
//                        println("Nay")// Error authenticating account
//                    } else {
//                        print(authData)
//                        println("Yay")
//                    }
//                })
//            }
//        }
        
         self.authWithTwitter()
        }
        
        
    
func authWithTwitter() {
    authHelper.selectTwitterAccountWithCallback { (error, accounts) -> Void in
        
        
        if accounts != nil{
            self.accounts = accounts as! [ACAccount]
            self.handleMultipleTwitterAccounts(self.accounts)
        }
        else{
        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/signup")!)
        
        }
    
    }
}

func authAccount(account: ACAccount) {
    authHelper.authenticateAccount(account, withCallback: { (error, authData) -> Void in
        if error != nil {
            // There was an error authenticating
        } else {
            // We have an authenticated Twitter user
            NSLog("%@", authData)
            // segue to chat
            self.performSegueWithIdentifier("toTabBar", sender: authData)
        }
    })
}

func selectTwitterAccount(accounts: [ACAccount]) {
    var selectUserActionSheet = UIActionSheet(title: "Select Twitter Account", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Destruct", otherButtonTitles: "Other")
    
    for account in accounts {
        selectUserActionSheet.addButtonWithTitle(account.username)
    }
    
    selectUserActionSheet.cancelButtonIndex = selectUserActionSheet.addButtonWithTitle("Cancel")
    selectUserActionSheet.showInView(self.view);
}

func handleMultipleTwitterAccounts(accounts: [ACAccount]) {
    switch accounts.count {
    case 0:
        UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/signup")!)
    case 1:
        self.authAccount(accounts[0])
    default:
        self.selectTwitterAccount(accounts)
    }
}

func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    let currentTwitterHandle = actionSheet.buttonTitleAtIndex(buttonIndex)
    for acc in accounts {
        if acc.username == currentTwitterHandle {
            self.authAccount(acc)
        }
    }
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
