//
//  VCLogin.swift
//  TableDemo
//
//  Created by Jason Spence on 17/07/2015.
//  Copyright (c) 2015 Jason Spence. All rights reserved.
//

import UIKit
import CoreData
class VCLogin: UIViewController, UIActionSheetDelegate {

    @IBOutlet weak var login_FB: UIButton!
    
    @IBOutlet weak var login_Twitter: UIButton!
   
    var ref: Firebase!
    var authHelper: TwitterAuthHelper!
    var accounts: [ACAccount]!
    var theCode: FAuthData!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url:"https://miquiz.firebaseio.com")
        authHelper = TwitterAuthHelper(firebaseRef: ref, apiKey: "mePjllXD6Pg8Flxt1IC5PaYsR")
        login_FB.addTarget(self, action: "loginFB:", forControlEvents: UIControlEvents.TouchUpInside)
        login_Twitter.addTarget(self, action: "loginTwitter:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
          // Do any additional setup after loading the view.
    }
    
    func loginFB(sender:UIButton){
        
        if theCode == nil{
        
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
                            
                            //println("Auth Data \(authData.uid)")
                            
                            
                            var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                            var context: NSManagedObjectContext = appDel.managedObjectContext!
                            
                            
                            var request = NSFetchRequest(entityName : "Facebook")
                            var results : NSArray = context.executeFetchRequest(request, error: nil)!
                            
                            if results.count < 1{
                                
                            var newUser = NSEntityDescription.insertNewObjectForEntityForName("Facebook", inManagedObjectContext: context) as! NSManagedObject
                            newUser.setValue(authData.uid, forKey: "uID")
                            newUser.setValue(0, forKey: "count")
                            context.save(nil)
                                
                                
                                var questionToAdd = Firebase(url:"https://miquiz.firebaseio.com/\(authData.uid)/Questions")
                                let addQuestion = ["Question":"This is a test Question", "Answer":"This is a test answer","ID":"ID1"]
                                let questionRef = questionToAdd.childByAutoId()
                                questionRef.setValue(addQuestion)
                                
                                
                                var quiz = Firebase(url:"https://miquiz.firebaseio.com/\(authData.uid)/MyQuizzes/Example Quiz/Round 1")
                                let addQuiz = ["ID":"ID1"]
                                let quizRef = quiz.childByAutoId()
                                quizRef.setValue(addQuiz)
                                
                                
                                
                            }
                            var newUser = NSEntityDescription.insertNewObjectForEntityForName("UID", inManagedObjectContext: context) as! NSManagedObject
                            newUser.setValue(0, forKey: "login")
                            context.save(nil)
                            
                            
                            self.performSegueWithIdentifier("toTabBar", sender: authData)
                            
                        }
                })
            }
        })
        }
        else{
            
            
            print("hello")
           self.performSegueWithIdentifier("toTabBar", sender: theCode)
            
        
        }
        
       
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginTwitter(sender:UIButton){

        
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
            //UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!);
        }
    
    }
}

func authAccount(account: ACAccount) {
    authHelper.authenticateAccount(account, withCallback: { (error, authData) -> Void in
        if error != nil {
            // There was an error authenticating
        } else {
            // We have an authenticated Twitter user
            
            
            var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            var context: NSManagedObjectContext = appDel.managedObjectContext!
            
            
            var request = NSFetchRequest(entityName : "Twitter")
            var results : NSArray = context.executeFetchRequest(request, error: nil)!
            
            if results.count < 1{
                
                var newUser = NSEntityDescription.insertNewObjectForEntityForName("Twitter", inManagedObjectContext: context) as! NSManagedObject
                newUser.setValue(authData.uid, forKey: "uID")
                newUser.setValue(0, forKey: "count")
                context.save(nil)
                
                
                var questionToAdd = Firebase(url:"https://miquiz.firebaseio.com/\(authData.uid)/Questions")
                let addQuestion = ["Question":"This is a test Question", "Answer":"This is a test answer","ID":"ID1"]
                let questionRef = questionToAdd.childByAutoId()
                questionRef.setValue(addQuestion)
                
                
                var quiz = Firebase(url:"https://miquiz.firebaseio.com/\(authData.uid)/MyQuizzes/Example Quiz/Round 1")
                let addQuiz = ["ID":"ID1"]
                let quizRef = quiz.childByAutoId()
                quizRef.setValue(addQuiz)
                
                
                
            }
            var newUser = NSEntityDescription.insertNewObjectForEntityForName("UID", inManagedObjectContext: context) as! NSManagedObject
            newUser.setValue(1, forKey: "login")
            context.save(nil)
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
//        var tabBarC : UITabBarController = segue.destinationViewController as! UITabBarController
//         var desView: VCTab = tabBarC.viewControllers?.first as! VCTab
//        
//        desView.user = sender

        
    }
    
  
    

    //facebook:839809966111003


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
