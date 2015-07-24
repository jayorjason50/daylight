//
//  VCMyQuizzes.swift
//  TableDemo
//
//  Created by Liam Chapman on 17/07/2015.
//  Copyright (c) 2015 Jason Spence. All rights reserved.
//

import UIKit
import CoreData
class VCMyQuizzes: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var miQuizzes: NSMutableArray = NSMutableArray()
    //var myQuestions: NSMutableArray = NSMutableArray()
   
    var firebase: Firebase?
    var quizName = ""
    var theNewCode:AnyObject!
    var user: AnyObject?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName : "UID")
        //print("User: \(user)")
       
        var results : NSArray = context.executeFetchRequest(request, error: nil)!
        var res = results[0] as! NSManagedObject
        if results.count == 1{
            res = results[0] as! NSManagedObject
        
        }
        else{
        
            res = results[results.count - 1] as! NSManagedObject
        
        }
        
        
        
        
        var login = res.valueForKey("login") as! Int
        var uid = ""
        
        if login == 0{
        
            var request = NSFetchRequest(entityName : "Facebook")
            var results : NSArray = context.executeFetchRequest(request, error: nil)!
            var res = results[0] as! NSManagedObject
            
            if results.count == 1
            {
                res = results[0] as! NSManagedObject
                
            }
            else{
                
                res = results[results.count - 1] as! NSManagedObject
                
            }
            uid = res.valueForKey("uID") as! String
        
        
        }
        else if login == 1{
            var request = NSFetchRequest(entityName : "Twitter")
            var results : NSArray = context.executeFetchRequest(request, error: nil)!
            
            var res = results[0] as! NSManagedObject
            if results.count == 1{
                res = results[0] as! NSManagedObject
                
            }
            else{
                
                res = results[results.count] as! NSManagedObject
                
            }
            uid = res.valueForKey("uID") as! String
        
        
        
        }
        
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        
        //This is for editing the list ->    self.tableView.editing = true
        
        var snapshot: FDataSnapshot = FDataSnapshot()
        var ref = Firebase(url:"https://miquiz.firebaseio.com/\(uid)/MyQuizzes")
        
 
        ref.observeEventType(.ChildAdded, withBlock: {snapshot in
            
            
            self.miQuizzes.addObject(snapshot.key)
            self.tableView.reloadData()
        })
        
        ref.observeEventType(.ChildRemoved, withBlock: {snapshot in
            
            
            self.miQuizzes.removeObject(snapshot.key)
            self.tableView.reloadData()
        })
        
        
    }
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            return miQuizzes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        let (MiQuizTitle: AnyObject) = miQuizzes[indexPath.row]
        cell.textLabel?.text = MiQuizTitle as? String
        var myImage = UIImage(named: "CellIcon")
        cell.imageView?.image = myImage
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        //Values to index into the array holding the data
        let row = indexPath.row
        let section = indexPath.section
        let quiz = (miQuizzes[indexPath.row] as! String) //Get string representation of the cells text
        
        //Make a reference to the VCMyQuizzesDetail (It's Identifier is set via storyboard -> ID card icon -> Identifier
        var view: VCMyQuizzesDetail = self.storyboard?.instantiateViewControllerWithIdentifier("VCMyQuizzesDetail") as! VCMyQuizzesDetail
        //Set the animation
        self.navigationController?.pushViewController(view, animated: true)
        view.title = miQuizzes[indexPath.row] as? String //Set the text
        
        
        
       
        
       // for elements in myQuestions{
            
//            var textToAdd = view.labelString
//            textToAdd += (elements as? String)!
//            //view.labelString = textToAdd
            
      //  }
        
        
        
        
        
     }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   
    
    
    
   
}

