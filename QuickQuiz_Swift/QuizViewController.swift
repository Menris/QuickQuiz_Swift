//
//  QuizViewController.swift
//  QuickQuiz_Swift
//
//  Created by Admin on 27.02.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class QuizViewController: UIViewController {
    
    var passedPIN = ""

    @IBOutlet weak var QuestionProgress: UILabel!
    @IBOutlet weak var Question: UILabel!
    
    @IBOutlet weak var textQuestion: UITextView!
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    
    var ref: FIRDatabaseReference!
    var countQuestions: FIRDatabaseReference!
    var questionNumber = 1
    var correctAnswer: String!
    var numberOfQuestions = 0
    var myAnswer = ""
    var quizTitle = ""
    var teacherID = ""
    var userName = ""
    var userGroup = ""
    var userResult = 0
    
    let user = FIRAuth.auth()?.currentUser?.uid
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let triggerTime = (Int64(NSEC_PER_MSEC) * 500 )
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), {() -> Void in
            SwiftLoading().showLoading()
        })
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func clickA(sender: AnyObject) {
        print("clickA")
        self.btnA.backgroundColor = UIColor.greenColor()
        self.btnB.backgroundColor = UIColor.lightGrayColor()
        self.btnC.backgroundColor = UIColor.lightGrayColor()
        self.btnD.backgroundColor = UIColor.lightGrayColor()
        self.myAnswer = "A"
    }
    @IBAction func clickB(sender: AnyObject) {
        print("clickB")
        self.btnA.backgroundColor = UIColor.lightGrayColor()
        self.btnB.backgroundColor = UIColor.greenColor()
        self.btnC.backgroundColor = UIColor.lightGrayColor()
        self.btnD.backgroundColor = UIColor.lightGrayColor()
        self.myAnswer = "B"
    }
    @IBAction func clickC(sender: AnyObject) {
        print("clickC")
        self.btnA.backgroundColor = UIColor.lightGrayColor()
        self.btnB.backgroundColor = UIColor.lightGrayColor()
        self.btnC.backgroundColor = UIColor.greenColor()
        self.btnD.backgroundColor = UIColor.lightGrayColor()
        self.myAnswer = "C"
    }
    @IBAction func clickD(sender: AnyObject) {
        print("clickD")
        self.btnA.backgroundColor = UIColor.lightGrayColor()
        self.btnB.backgroundColor = UIColor.lightGrayColor()
        self.btnC.backgroundColor = UIColor.lightGrayColor()
        self.btnD.backgroundColor = UIColor.greenColor()
        self.myAnswer = "D"
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
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 3 )
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), {() -> Void in
            SwiftLoading().hideLoading()
        })

    
        
    }
    
    @IBAction func goNextQuestion(sender: AnyObject) {
        
        ///uncheck selected answer
        self.btnA.selected = false
        self.btnB.selected = false
        self.btnC.selected = false
        self.btnD.selected = false
        //uncolor buttons
        self.btnA.backgroundColor = UIColor.lightGrayColor()
        self.btnB.backgroundColor = UIColor.lightGrayColor()
        self.btnC.backgroundColor = UIColor.lightGrayColor()
        self.btnD.backgroundColor = UIColor.lightGrayColor()
        
        /// adding user Answer to database
        self.ref = FIRDatabase.database().reference()
        
        self.ref.child("userInformation").child(self.user!).child("myPassedQuizes").child(passedPIN).child("Question " + String(questionNumber)).setValue(["myAnswer": self.myAnswer])
        
        if self.myAnswer == self.correctAnswer {
            self.userResult++
        }
        
        ///counter to next question +1
        questionNumber++
        
        ///checking if it the last question
        if questionNumber > self.numberOfQuestions-2 {
            print("Show submit form")
            
            
            ///show alert dialog for finishing quiz
            let submitAlert = UIAlertController(title:"You have finished", message: "Click submit button to see result", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(submitAlert, animated: true, completion: nil)
            
            
            submitAlert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                print("Submit Action")
                
                
                
                let teacherQuizID = self.ref.child("userInformation").child(self.teacherID).child("teacherQuizes").child(self.passedPIN)
                teacherQuizID.updateChildValues([
                    "quizID": self.passedPIN,
                    ])
                
                let teacherRef = self.ref.child("userInformation").child(self.teacherID).child("teacherQuizes").child(self.passedPIN).child("groups").child(self.userGroup).child("userNames").child(self.userName)
                teacherRef.updateChildValues([
                    "name": self.userName,
                    "group": self.userGroup,
                    "userResult": String(self.userResult)
                    ])
                
                
                
                let groupRef = self.ref.child("userInformation").child(self.teacherID).child("teacherQuizes").child(self.passedPIN).child("groups").child(self.userGroup)
                groupRef.updateChildValues ([
                    "group": self.userGroup
                    ])
                
                let quizInfoRef = self.ref.child("userInformation").child(self.user!).child("myPassedQuizes").child(self.passedPIN)
                quizInfoRef.updateChildValues ([
                    
                    "userResult": String(self.userResult),
                    "quizTitle": self.quizTitle,
                    "quizID": self.passedPIN
                    ])
                
                
                let resultController = self.storyboard?.instantiateViewControllerWithIdentifier("ResultViewController") as! ResultViewController
                resultController.passedResult = String(self.userResult)
                
                self.navigationController?.pushViewController(resultController, animated: true)
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
