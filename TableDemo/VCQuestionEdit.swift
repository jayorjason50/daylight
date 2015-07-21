//
//  VCQuestionEdit.swift
//  TableDemo
//
//  Created by Jason Spence on 20/07/2015.
//  Copyright (c) 2015 Jason Spence. All rights reserved.
//

import UIKit

class VCQuestionEdit: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    var data = ""
    var name = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        name = self.title!
        updateButton.addTarget(self, action: "updateQuestion:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var snapshot: FDataSnapshot = FDataSnapshot()
        var ref = Firebase(url:"https://miquiz.firebaseio.com/Questions")
        ref.observeSingleEventOfType(.Value, withBlock:{snapshot in
           for rest in snapshot.children.allObjects as! [FDataSnapshot]{
                var child = rest.children.allObjects
            
                for ID in child as! [FDataSnapshot]{
                   var questionID = ID.value as! String
                    if (questionID == self.name){
            
                      self.data = rest.key
                        
                    
                        var qRef = Firebase(url:"https://miquiz.firebaseio.com/Questions/"+self.data)
                        qRef.observeSingleEventOfType(.Value, withBlock:{snapshot in
                            
                            
                            for branch in snapshot.children.allObjects as! [FDataSnapshot]{
                            
                                if branch.key == "Answer"{
                                    
                            
                                    self.answerLabel.text = "Answer : " + (branch.value as? String)!
                                    self.questionLabel.text = "Question : " + self.name

                                
                                
                                }
                                
                            
                            }
                        
                        
                        })
                    
                    
                    
                    
                    
                    
                    }
                    
                }
                
            }
        })
        
        
        
        
        
        
        
        
       
        questionLabel.font = UIFont.systemFontOfSize(15)
        
        answerLabel.font = UIFont.systemFontOfSize(15)
        //answerLabel.text = "Answer: "
        
        
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func updateQuestion(sender:UIButton){
    
        var qText : String = questionField.text
        var aText : String = answerField.text
        
        var theKey = data
        var ref = Firebase(url:"https://miquiz.firebaseio.com/Questions")
        var hopperRef = ref.childByAppendingPath(theKey)
        
        
        if(!questionField.text.isEmpty && !answerField.text.isEmpty){
        
            var newQuestion = ["Question":qText]
            var newAnswer = ["Answer":aText]
            hopperRef.updateChildValues(newQuestion)
            hopperRef.updateChildValues(newAnswer)
        
        }
        else if !questionField.text.isEmpty{
        
            var newQuestion = ["Question":qText]
            hopperRef.updateChildValues(newQuestion)

        }
        else if !answerField.text.isEmpty{
            
            var newAnswer = ["Answer":aText]
            hopperRef.updateChildValues(newAnswer)
            
        }

        
        
        //
        
        //hopperRef.updateChildValues(newQuestion)
        
        println(qText)
        
        
    }
    
}
