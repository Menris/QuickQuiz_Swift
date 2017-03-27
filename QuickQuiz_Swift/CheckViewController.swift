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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.btn_next.layer.cornerRadius = 10.0
        self.btn_next.clipsToBounds = true
        self.btn_next.layer.borderWidth = 2
        self.btn_next.layer.borderColor = UIColor.blackColor().CGColor
        
        self.btn_back.layer.cornerRadius = 10.0
        self.btn_back.clipsToBounds = true
        self.btn_back.layer.borderWidth = 2
        self.btn_back.layer.borderColor = UIColor.blackColor().CGColor
        
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
        
        self.questionProgress.text = String(questionNumber) + " / " + String(self.numberOfQuestions )
        
        ref.child("Tests").child(passedPIN).child("Questions").child("Question " + String(questionNumber)).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let CurrentQuestion = snapshot.value!["question"] as? String {
                print(CurrentQuestion)
                self.questionText.text = CurrentQuestion
                self.questionText.font = .systemFontOfSize(18)
                self.questionText.textAlignment = .Center
            }
            
            if let correctAns = snapshot.value!["correctAnswer"] as? String {
                print (correctAns)
                self.correctAnswer = correctAns
            }
            
            if let ansA = snapshot.value!["answerA"] as? String {
                print (ansA)
                if (self.correctAnswer == "A") {
                    self.correctAnswerText = ansA
                }
                self.ansArray.append("A")
                self.myArray.append(ansA)
            }
            if let ansB = snapshot.value!["answerB"] as? String {
                print (ansB)
                if (self.correctAnswer == "B") {
                    self.correctAnswerText = ansB
                }
                self.ansArray.append("B")
                self.myArray.append(ansB)
            }
            if let ansC = snapshot.value!["answerC"] as? String {
                print (ansC)
                if (self.correctAnswer == "C") {
                    self.correctAnswerText = ansC
                }
                self.ansArray.append("C")
                self.myArray.append(ansC)
            }
            if let ansD = snapshot.value!["answerD"] as? String {
                print (ansD)
                if (self.correctAnswer == "D") {
                    self.correctAnswerText = ansD
                }
                self.ansArray.append("D")
                self.myArray.append(ansD)
            }
            if let ansE = snapshot.value!["answerE"] as? String {
                self.ansArray.append("E")
                self.myArray.append(ansE)
            }
            if let ansF = snapshot.value!["answerF"] as? String {
                print (ansF)
                self.ansArray.append("F")
                self.myArray.append(ansF)
            }
            if let ansG = snapshot.value!["answerG"] as? String {
                self.ansArray.append("G")
                self.myArray.append(ansG)
            }
            if let ansH = snapshot.value!["answerH"] as? String {
                self.ansArray.append("H")
                self.myArray.append(ansH)
            }
            if let ansI = snapshot.value!["answerI"] as? String {
                self.ansArray.append("I")
                self.myArray.append(ansI)
            }
            if let ansJ = snapshot.value!["answerJ"] as? String {
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
        cell.backgroundColor = UIColor.whiteColor()
        if (self.correctAnswerText == self.myArray[indexPath.item]) {
            cell.backgroundColor = UIColor.greenColor()
        }
        cell.textLabel?.text = myArray[indexPath.item]
        return cell
        
    }
    

}
