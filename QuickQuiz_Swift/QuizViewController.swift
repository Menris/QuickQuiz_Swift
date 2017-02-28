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
    var ref: FIRDatabaseReference!
    var countQuestions: FIRDatabaseReference!
    var questionNumber = 1
    var correctAnswer: String!
    var numberOfQuestions = 0
    var myAnswer = ""
    var quizTitle = ""
    var userResult = 0
    
    
    @IBOutlet weak var textQuestion: UITextView!
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //counting questions
        countQuestions = FIRDatabase.database().reference().child("Tests").child(passedPIN)
        countQuestions.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let fQuizTitle = snapshot.value!["quizTitle"] as? String {
                print(fQuizTitle)
                self.quizTitle = fQuizTitle
            }
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
    
    @IBAction func clickA(sender: AnyObject) {
        print("clickA")
        self.myAnswer = "A"
    }
    @IBAction func clickB(sender: AnyObject) {
        print("clickB")
        self.myAnswer = "B"
    }
    @IBAction func clickC(sender: AnyObject) {
        print("clickC")
        self.myAnswer = "C"
    }
    @IBAction func clickD(sender: AnyObject) {
        print("clickD")
        self.myAnswer = "D"
    }
    func readQuestion() {
        
        self.QuestionProgress.text = String(questionNumber) + " / " + String(self.numberOfQuestions-2)
        
        ref = FIRDatabase.database().reference().child("Tests").child("1203").child("Question " + String(questionNumber))
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
    }
    
    @IBAction func goNextQuestion(sender: AnyObject) {
        
        /// adding user Answer to database
        self.ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser?.uid
        self.ref.child("userInformation").child(user!).child("myPassedQuizes").child(passedPIN).child("Question " + String(questionNumber)).setValue(["myAnswer": self.myAnswer])
        
        if (myAnswer == correctAnswer) {
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
                let quizInfoRef = self.ref.child("userInformation").child(user!).child("myPassedQuizes").child(self.passedPIN)
                
                quizInfoRef.updateChildValues ([
                    "userResult": self.userResult,
                    "quizTitle": self.quizTitle,
                    "quizID": self.passedPIN
                    ])
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
