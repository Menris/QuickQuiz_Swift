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

class CheckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var passedPIN = ""
    var myArray = [""]
    var ansArray = [""]
    
    var correctAnswerText = ""
    var myAnswerText = ""
    
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
    
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var btn_back: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textQuestion: UILabel!
    @IBOutlet weak var label_quizTitle: UILabel!
    @IBOutlet weak var questionProgress: UILabel!
    @IBOutlet weak var questionText: UILabel!
    var navBar:UINavigationBar=UINavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Check quiz"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.btn_next.layer.cornerRadius = 10.0
        self.btn_next.clipsToBounds = true
        self.btn_next.layer.borderWidth = 2
        self.btn_next.layer.borderColor = UIColor.blackColor().CGColor
        
        self.btn_back.layer.cornerRadius = 10.0
        self.btn_back.clipsToBounds = true
        self.btn_back.layer.borderWidth = 2
        self.btn_back.layer.borderColor = UIColor.blackColor().CGColor
        
        self.questionText.layer.cornerRadius = 10.0
        self.questionText.clipsToBounds = true
        self.questionText.layer.borderWidth = 2
        self.questionText.layer.borderColor = UIColor.blackColor().CGColor
        self.questionText.textColor = UIColor.whiteColor()
        
        
        self.ref = FIRDatabase.database().reference()

        
        //counting questions
        countQuestions = FIRDatabase.database().reference().child("Tests").child(passedPIN)
        countQuestions.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let fQuizTitle = snapshot.value!["quizTitle"] as? String {
                print(fQuizTitle)
                self.label_quizTitle.text! = fQuizTitle
            }
            
            if let fTeacherID = snapshot.value!["teacherID"] as? String {
                print(fTeacherID)
                self.teacherID = fTeacherID
            }
            
            ///get user information
            self.getUserInfo()
            
        })
        countQuestions.child("Questions").observeEventType(.Value, withBlock: { (snapshot: FIRDataSnapshot!) in
            self.numberOfQuestions = Int(snapshot.childrenCount)
            print("number of questions: " + String(snapshot.childrenCount))
            self.showQuestion()
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserInfo() {
        
        ref.child("userInformation").child(self.user!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
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
    
    func showQuestion() {
        
        self.myArray.removeAll()
        self.ansArray.removeAll()
        self.correctAnswerText = ""
        self.myAnswerText = ""
        
        self.questionProgress.text = String(questionNumber) + " / " + String(self.numberOfQuestions )
        
        ref.child("userInformation").child(self.user!).child("myPassedQuizes").child(passedPIN).child("Question " + String(questionNumber)).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let myAnswer = snapshot.value!["myAnswer"] as? String {
                    print (myAnswer)
                    self.myAnswerText = myAnswer
                }
            })
        ref.child("Tests").child(passedPIN).child("Questions").child("Question " + String(questionNumber)).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let CurrentQuestion = snapshot.value!["question"] as? String {
                print(CurrentQuestion)
                self.questionText.text = CurrentQuestion
                self.questionText.font = .systemFontOfSize(25)
                self.questionText.textAlignment = .Center
            }
            
            if let correctAns = snapshot.value!["correctAnswer"] as? String {
                print (correctAns)
                self.correctAnswer = correctAns
            }
            
            if let ansA = snapshot.value!["answerA"] as? String {
                if (self.correctAnswer == "A") {
                    self.correctAnswerText = ansA
                } else if (self.myAnswerText == "A") {
                    self.myAnswerText = ansA
                }
                self.ansArray.append("A")
                self.myArray.append(ansA)
            }
            if let ansB = snapshot.value!["answerB"] as? String {
                if (self.correctAnswer == "B") {
                    self.correctAnswerText = ansB
                } else if (self.myAnswerText == "B") {
                    self.myAnswerText = ansB
                }
                self.ansArray.append("B")
                self.myArray.append(ansB)
            }
            if let ansC = snapshot.value!["answerC"] as? String {
                if (self.correctAnswer == "C") {
                    self.correctAnswerText = ansC
                } else if (self.myAnswerText == "C") {
                    self.myAnswerText = ansC
                }
                self.ansArray.append("C")
                self.myArray.append(ansC)
            }
            if let ansD = snapshot.value!["answerD"] as? String {
                if (self.correctAnswer == "D") {
                    self.correctAnswerText = ansD
                } else if (self.myAnswerText == "D") {
                    self.myAnswerText = ansD
                }
                self.ansArray.append("D")
                self.myArray.append(ansD)
            }
            if let ansE = snapshot.value!["answerE"] as? String {
                if (self.correctAnswer == "E") {
                    self.correctAnswerText = ansE
                }
                self.ansArray.append("E")
                self.myArray.append(ansE)
            }
            if let ansF = snapshot.value!["answerF"] as? String {
                if (self.correctAnswer == "F") {
                    self.correctAnswerText = ansF
                }
                self.ansArray.append("F")
                self.myArray.append(ansF)
            }
            if let ansG = snapshot.value!["answerG"] as? String {
                if (self.correctAnswer == "G") {
                    self.correctAnswerText = ansG
                }
                self.ansArray.append("G")
                self.myArray.append(ansG)
            }
            if let ansH = snapshot.value!["answerH"] as? String {
                if (self.correctAnswer == "H") {
                    self.correctAnswerText = ansH
                }
                self.ansArray.append("H")
                self.myArray.append(ansH)
            }
            if let ansI = snapshot.value!["answerI"] as? String {
                if (self.correctAnswer == "I") {
                    self.correctAnswerText = ansI
                }
                self.ansArray.append("I")
                self.myArray.append(ansI)
            }
            if let ansJ = snapshot.value!["answerJ"] as? String {
                if (self.correctAnswer == "J") {
                    self.correctAnswerText = ansJ
                }
                self.ansArray.append("J")
                self.myArray.append(ansJ)
            }
            
            self.tableView.reloadData()
        })
        
    }
    
    
    @IBAction func goNextQuestion(sender: AnyObject) {
        if self.questionNumber < self.numberOfQuestions {
            self.questionNumber++
            showQuestion()
        }
    }
    
    @IBAction func goPreviousQuestion(sender: AnyObject) {
        if self.questionNumber > 1{
            self.questionNumber--
            showQuestion()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestionsCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        if ( self.myAnswerText == self.myArray[indexPath.item] ) {
            cell.backgroundColor = UIColor.redColor()
        }
        if (self.correctAnswerText == self.myArray[indexPath.item]) {
            cell.backgroundColor = UIColor.greenColor()
        }
        cell.textLabel?.text = myArray[indexPath.item]
        return cell
        
    }
    

}
