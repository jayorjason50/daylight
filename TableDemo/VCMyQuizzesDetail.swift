//
//  VCMyQuizzesDetail.swift
//  TableDemo
//
//  Created by Jason Spence on 17/07/2015.
//  Copyright (c) 2015 Jason Spence. All rights reserved.
//

import UIKit
import CoreData
class VCMyQuizzesDetail: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var DetailTable: UITableView!
    var miQuestions: NSMutableArray = NSMutableArray()
    var miRounds: NSMutableArray = NSMutableArray()
    var roundSec: NSMutableArray = NSMutableArray()
    var name = String()
    var arrayInc = 0
    
    
    override func viewDidLoad() {
        
        
        //As this is an override we want to run the original function first, and then add to it
        super.viewDidLoad()
        
        //Table view setup
        DetailTable.dataSource = self
        DetailTable.delegate = self
        
        name = self.title!//Get title (so we know which quiz we are going into 
        println(name)
        //This is for editing the list ->    self.tableView.editing = true
        
        
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
            //print("User: \(user)")
            
            var results : NSArray = context.executeFetchRequest(request, error: nil)!
            
            var res = results[0] as! NSManagedObject
            if results.count == 1{
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
                
                res = results[results.count - 1] as! NSManagedObject
                
            }

            uid = res.valueForKey("uID") as! String
            
            
            
        }
        

        var snapshot: FDataSnapshot = FDataSnapshot()
        var ref = Firebase(url:"https://miquiz.firebaseio.com/\(uid)/MyQuizzes/" + name) //Make ref to the selected quiz
        
        ref.observeSingleEventOfType(.Value, withBlock:{snapshot in
            self.miRounds.addObject(snapshot.childrenCount)

            for rest in snapshot.children.allObjects as! [FDataSnapshot]{ //Loop through (nested loop to get to the questions)
                
                var child = rest.children.allObjects
                var round = rest.key
                
                
                
                for rest in child as! [FDataSnapshot]{
                    var child = rest.children.allObjects
                    
                    for rest in child as! [FDataSnapshot]{
                        var questionID = rest.value as! String
                        var ref = Firebase(url:"https://miquiz.firebaseio.com/\(uid)/Questions")
                        ref.observeSingleEventOfType(.Value, withBlock:{snapshot in
                            
                            for rest in snapshot.children.allObjects as! [FDataSnapshot]{
                                var data = rest.value.objectForKey("ID") as! String
                                
                                if(data == questionID){
                                    
                                    //If they match do some splitting of the string: "Round 1" changes to 1, as an int
                                    var roundString = round as String
                                    let index = advance(roundString.startIndex, 6)
                                    var newString = roundString.substringFromIndex(index)
                                    
                                    var roundToAdd = newString.toInt()!
                                    self.roundSec.addObject(roundToAdd - 1)//For indexing purposes remove 1
                                    var question = rest.value.objectForKey("Question") as! String
                                    self.miQuestions.addObject(question)
                                    self.DetailTable.reloadData()

                                    
                                }
                            }
                        })
                    }
                }
                
            }
        })
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var num = 1
        
        for elements in miRounds{
            
            num = elements as! Int //Update to get the number of rounds
            
        }
        
        

    
        
        return num
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int)-> String? {
        
        
        return "Round " + String(section + 1)//Get section and and 1 to get round number
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
     var count = 0
        
        
        
        for elements in roundSec{ //Loop through the rounds array
           
            if elements as! Int == section{ //If it matches the section
            
                count++ //Increment count
            }
            
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
        var cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! UITableViewCell //Make cell
        let (MiQuestionTitle: AnyObject) = miQuestions[arrayInc] //Set the title the next value in the questions array, we are essentially iterating over this
        //As arrayInc is 0 to start the first cell can still use miQuestions[arrayInc]
        
        var count = miQuestions.count //Get the size of the questions array
        
        
        if arrayInc >= count - 1{ //If our counter (arrayInc) reaches or exceeds the size of count we reset the arrayInc value
        
            arrayInc = 0
        
        }
        else{//Otherwise increment
            arrayInc++
        }
        cell.textLabel?.text = MiQuestionTitle as? String //Now set the title and images of the cell
        var myImage = UIImage(named: "CellIcon")
        cell.imageView?.image = myImage
        
        
        
        
        return cell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Values to index into the array holding the data
        let row = indexPath.row
        let section = indexPath.section
        
        
//        for elements in miQuestions{
//            
//            if elements as! String == "test"
//            { //If it matches the section
//               println(elements)
//               
//            }
//            
//            //print(elements)
////        
//        }
        
        //For bug with multiple rounds!!!!!!!!!!!
        
        var count = 0
        var theCounter = 0
        for elements in roundSec{
           

        
        
            if elements as! Int == section{
                
                
                if count == row{
                
                    var number = count + theCounter
                    
                    let quiz = (miQuestions[count + theCounter] as! String) //Get string representation of the cells text
                    
                    //Make a reference to the VCQuestionEdit (It's Identifier is set via storyboard -> ID card icon -> Identifier
                    var view: VCQuestionEdit = self.storyboard?.instantiateViewControllerWithIdentifier("VCQuestionEdit") as! VCQuestionEdit
                    //Set the animation
                    self.navigationController?.pushViewController(view, animated: true)
                    view.title = miQuestions[count + theCounter] as? String //Set the text
                    
                
                }
                count++
                
            
            }
            else{
                theCounter++
            }
            
            }
        
        
//        let quiz = (miQuestions[indexPath.row] as! String) //Get string representation of the cells text
//        
//                            //Make a reference to the VCQuestionEdit (It's Identifier is set via storyboard -> ID card icon -> Identifier
//                            var view: VCQuestionEdit = self.storyboard?.instantiateViewControllerWithIdentifier("VCQuestionEdit") as! VCQuestionEdit
//                            //Set the animation
//                            self.navigationController?.pushViewController(view, animated: true)
//                            view.title = miQuestions[indexPath.row] as? String //Set the text
        
        
        
//         println("row" + String(row))
//        println("section" + String(section))
        
        
        
        
        
        
        // for elements in myQuestions{
        
        //            var textToAdd = view.labelString
        //            textToAdd += (elements as? String)!
        //            //view.labelString = textToAdd
        
        //  }
        
        
        
        
        
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
