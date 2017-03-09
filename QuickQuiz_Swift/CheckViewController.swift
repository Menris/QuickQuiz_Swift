//
//  CheckViewController.swift
//  QuickQuiz_Swift
//
//  Created by Admin on 07.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CheckViewController: UIViewController {
    
    var passedPIN = ""

    @IBOutlet weak var QuestionProgress: UILabel!
    @IBOutlet weak var textQuestion: UITextView!
    
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    
    var ref: FIRDatabaseReference!
    var countQuestions: FIRDatabaseReference!
    let user = FIRAuth.auth()?.currentUser?.uid
    
    var questionNumber = 1
    var numberOfQuestions = 0
    var correctAnswer: String!
    var quizTitle = ""
    var teacherID = ""
    var userName = ""
    var userGroup = ""
    var userResult = 0
    
    @IBOutlet weak var pin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        btnA.enabled = false;
        btnB.enabled = false;
        btnC.enabled = false;
        btnD.enabled = false;
        
        self.textQuestion.layer.cornerRadius = 10.0
        self.textQuestion.clipsToBounds = true
        
        self.btnA.layer.cornerRadius = 10.0
        self.btnA.clipsToBounds = true
        
        self.btnB.layer.cornerRadius = 10.0
        self.btnB.clipsToBounds = true
        
        self.btnC.layer.cornerRadius = 10.0
        self.btnC.clipsToBounds = true
        
        self.btnD.layer.cornerRadius = 10.0
        self.btnD.clipsToBounds = true
        
        
        //counting questions
        countQuestions = FIRDatabase.database().reference().child("Tests").child(passedPIN)
        countQuestions.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let fQuizTitle = snapshot.value!["quizTitle"] as? String {
                print(fQuizTitle)
                self.quizTitle = fQuizTitle
            }
            
            if let fTeacherID = snapshot.value!["teacherID"] as? String {
                print(fTeacherID)
                self.teacherID = fTeacherID
            }
            
            ///get user information
            self.getUserInfo()
            
        })
        countQuestions.observeEventType(.Value, withBlock: { (snapshot: FIRDataSnapshot!) in
            self.numberOfQuestions = Int(snapshot.childrenCount)
            self.readQuestion()
        })
        
        // Do any additional setup after loading the view.
    }
    
    func getUserInfo() {
        
        countQuestions = FIRDatabase.database().reference().child("userInformation").child(self.user!)
        countQuestions.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let fUserName = snapshot.value!["name"] as? String {
                print(fUserName)
                self.userName = fUserName
            }
            
            if let fUserGroup = snapshot.value!["group"] as? String {
                print(fUserGroup)
                self.userGroup = fUserGroup
            }
            
        })
        
        
    }
    
    func readQuestion() {
        
        self.QuestionProgress.text = String(questionNumber) + " / " + String(self.numberOfQuestions-2)
        
        ref = FIRDatabase.database().reference().child("Tests").child(passedPIN).child("Question " + String(questionNumber))
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let CurrentQuestion = snapshot.value!["question"] as? String {
                print(CurrentQuestion)
                self.textQuestion.text = CurrentQuestion
                self.textQuestion.font = .systemFontOfSize(18)
                self.textQuestion.textAlignment = .Center
            }
            
            if let correctAns = snapshot.value!["correctAnswer"] as? String {
                print (correctAns)
                self.correctAnswer = correctAns
            }
            
            if let ansA = snapshot.value!["answerA"] as? String {
                print (ansA)
                self.btnA.setTitle(ansA, forState: .Normal)
            }
            if let ansB = snapshot.value!["answerB"] as? String {
                print (ansB)
                self.btnB.setTitle(ansB, forState: .Normal)
            }
            if let ansC = snapshot.value!["answerC"] as? String {
                print (ansC)
                self.btnC.setTitle(ansC, forState: .Normal)
            }
            if let ansD = snapshot.value!["answerD"] as? String {
                print (ansD)
                self.btnD.setTitle(ansD, forState: .Normal)
            }
        })
        markQuestions()
    }
    
    
    func markQuestions() {
        ref = FIRDatabase.database().reference().child("userInformation").child(self.user!).child("myPassedQuizes").child(passedPIN).child("Question " + String(questionNumber))
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let myAnswer = snapshot.value!["myAnswer"] as? String {
                
                if self.correctAnswer == myAnswer {
                    let myBtn = "btn" + myAnswer
                    print("myAnswer - " + myAnswer + myBtn)
                    if myBtn == "btnA" {
                        self.btnA.backgroundColor = UIColor.greenColor()
                    }
                    if myBtn == "btnB" {
                        self.btnB.backgroundColor = UIColor.greenColor()
                    }
                    if myBtn == "btnC" {
                        self.btnC.backgroundColor = UIColor.greenColor()
                    }
                    if myBtn == "btnD" {
                        self.btnD.backgroundColor = UIColor.greenColor()
                    }
                    
                } else {
                
                    if self.correctAnswer == "A" {
                        self.btnA.backgroundColor = UIColor.blueColor()
                    }
                    if self.correctAnswer == "B" {
                        self.btnB.backgroundColor = UIColor.blueColor()
                    }
                    if self.correctAnswer == "C" {
                        self.btnC.backgroundColor = UIColor.blueColor()
                    }
                    if self.correctAnswer == "D" {
                        self.btnD.backgroundColor = UIColor.blueColor()
                    }
                    
                }
                
            }
        })

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showNextQuestion(sender: AnyObject) {
        
        //uncolor buttons
        self.btnA.backgroundColor = UIColor.lightGrayColor()
        self.btnB.backgroundColor = UIColor.lightGrayColor()
        self.btnC.backgroundColor = UIColor.lightGrayColor()
        self.btnD.backgroundColor = UIColor.lightGrayColor()
        
        ///counter to next question +1
        questionNumber++
        
        ///checking if it the last question
        if questionNumber > self.numberOfQuestions-2 {
            print("Show submit form")
            
            
            ///show alert dialog for finishing quiz
            let submitAlert = UIAlertController(title:"You have finished", message: "Click submit button to finish checking", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(submitAlert, animated: true, completion: nil)
            
            
            submitAlert.addAction(UIAlertAction(title: "Finish", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                print("Submit Action")
                
                let resultController = self.storyboard?.instantiateViewControllerWithIdentifier("StartingViewController") as! StartingViewController
                self.presentViewController(resultController, animated: true, completion: nil)
                
            }))
            
            submitAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                print("Submit Action")
            }))
            
        } else { readQuestion() }
        
        
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
