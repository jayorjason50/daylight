//
//  VCNewQuizViewController.swift
//  
//
//  Created by Liam Chapman on 22/07/2015.
//
//

import UIKit
import CoreData
class VCNewQuizViewController: UIViewController {

    
   
    @IBOutlet weak var quizAnswer: UITextField!
    
    @IBOutlet weak var quizQuestion: UITextField!
    @IBOutlet weak var quizName: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submit.addTarget(self, action: "addQuiz:", forControlEvents: UIControlEvents.TouchUpInside)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addQuiz(sender:UIButton){
        
        print("hello")
        var quizNameText = quizName.text
        var quizQuestionText = quizQuestion.text
        var quizAnswerText = quizAnswer.text
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName : "UID")
        var results : NSArray = context.executeFetchRequest(request, error: nil)!
        var res = results[0] as! NSManagedObject
        var uid = res.valueForKey("uID") as! String
        
        var newRes = results[results.count - 1] as! NSManagedObject
        var IDCount = newRes.valueForKey("count") as! Int
        
        println("hello \(uid)")
        
        var newUser = NSEntityDescription.insertNewObjectForEntityForName("UID", inManagedObjectContext: context) as! NSManagedObject
        newUser.setValue(IDCount + 1, forKey: "count")
        context.save(nil)
        
        var ref = Firebase(url:"https://miquiz.firebaseio.com/\(uid)/Questions")
        ref.observeEventType(.ChildAdded, withBlock: {snapshot in
            
            
        })
        
        
        
        
        var refQ = Firebase(url:"https://miquiz.firebaseio.com/\(uid)/Questions")
        let add = ["Question": quizQuestionText, "Answer": quizAnswerText, "ID" : IDCount]
        let post1Ref = refQ.childByAutoId()
        post1Ref.setValue(add)
        
        
        
        
//        refQ.observeEventType(.Value, withBlock: { snapshot in
        
//            var childNum = snapshot.childrenCount
        
            
//            var ref = Firebase(url:"https://miquiz.firebaseio.com/\(uid)/Questions/ID\(childNum + 1)")
//            var users = ["Question": quizQuestionText, "Answer": quizAnswerText]
//            ref.setValue(users)
//        })
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}
