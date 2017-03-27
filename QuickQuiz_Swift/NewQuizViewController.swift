//
//  NewQuizViewController.swift
//  QuickQuiz_Swift
//
//  Created by Admin on 14.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class NewQuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var passedPIN = ""
    var myArray = [""]
    
    @IBOutlet weak var quizTitle: UILabel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionProgress: UILabel!
    @IBOutlet weak var questionText: UILabel!
    
    var teacherID = ""
    var numberOfQuestions = 0
    var userName = ""
    var userGroup = ""
    var correctAnswer = ""
    var questionNumber = 1
    var myAnswer = ""
    var userResult = 0
    
    var answersArray = [String]()
    
    @IBOutlet weak var btn_next: UIButton!
    var ref: FIRDatabaseReference!
    
    var countQuestions: FIRDatabaseReference!
    let user = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.btn_next.layer.cornerRadius = 10.0
        self.btn_next.clipsToBounds = true
        self.btn_next.layer.borderWidth = 2
        self.btn_next.layer.borderColor = UIColor.blackColor().CGColor
        
        self.questionText.layer.cornerRadius = 10.0
        self.questionText.clipsToBounds = true
        self.questionText.layer.borderWidth = 2
        self.questionText.layer.borderColor = UIColor.blackColor().CGColor
        
        
        self.ref = FIRDatabase.database().reference()
        
        
        //counting questions
        countQuestions = FIRDatabase.database().reference().child("Tests").child(passedPIN)
        countQuestions.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let fQuizTitle = snapshot.value!["quizTitle"] as? String {
                print(fQuizTitle)
                self.quizTitle.text = fQuizTitle
            }
            
            if let fTeacherID = snapshot.value!["teacherID"] as? String {
                print(fTeacherID)
                self.teacherID = fTeacherID
            }
            
            ///get user information
                self.getUserInfo()
            
        })
        
        countQuestions.child("Questions").observeEventType(.Value, withBlock: { (snapshot: FIRDataSnapshot!) in
            self.questionProgress.text = String(Int(snapshot.childrenCount))
            self.numberOfQuestions = Int(snapshot.childrenCount)
            self.showQuestion()
        })
        

        // Do any additional setup after loading the view.
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
                self.myArray.append(ansA)
            }
            if let ansB = snapshot.value!["answerB"] as? String {
                print (ansB)
                self.myArray.append(ansB)
            }
            if let ansC = snapshot.value!["answerC"] as? String {
                print (ansC)
                self.myArray.append(ansC)
            }
            if let ansD = snapshot.value!["answerD"] as? String {
                print (ansD)
                self.myArray.append(ansD)
            }
            if let ansE = snapshot.value!["answerE"] as? String {
                self.myArray.append(ansE)
            }
            if let ansF = snapshot.value!["answerF"] as? String {
                print (ansF)
                self.myArray.append(ansF)
            }
            if let ansG = snapshot.value!["answerG"] as? String {
                self.myArray.append(ansG)
            }
            if let ansH = snapshot.value!["answerH"] as? String {
                self.myArray.append(ansH)
            }
            if let ansI = snapshot.value!["answerI"] as? String {
                self.myArray.append(ansI)
            }
            if let ansJ = snapshot.value!["answerJ"] as? String {
                self.myArray.append(ansJ)
            }
            self.tableView.reloadData()
            
        })
        
    }

    @IBAction func nextQuestion(sender: AnyObject) {
        
        
        if (!self.myAnswer.isEmpty) {
            
            print ("My answer = " + self.myAnswer + " Correct Answer = " + self.correctAnswer)
            
            if (self.myAnswer == self.correctAnswer) {
                self.userResult++
                print("result = " + String(self.userResult))
            }
            
            
            
            answersArray.append(self.myAnswer)
            
            if (self.questionNumber == self.numberOfQuestions) {
                
                
                
                var statRef: FIRDatabaseReference!
                
                for (var i, id) in answersArray.enumerate() {
                    
                    i++
                    
                    ref.child("userInformation").child(self.user!).child("myPassedQuizes").child(passedPIN).child("Question " + String(i)).setValue(["myAnswer": id])
                    
                    statRef = FIRDatabase.database().reference().child("userInformation").child(self.teacherID).child("teacherQuizes").child(passedPIN).child("groups").child(self.userGroup).child("userAnswers")
                   
                    
                        statRef.observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
                            print ("ID ", String(i))
                            
                            //if snapshot.hasChild("Question " + String(i)) {
                            if snapshot.hasChildren() {
                                
                            
                                if let userAnswerArray = snapshot.value!["myAnswer"] as? String {
                                    print ("only populate array" + String(i) + id)
                                    statRef.child("Question " + String(i)).setValue(["myAnswer": String(userAnswerArray) + id])
                                }
                                
                            } else {
                                
                                print ("only for empty array" + String(i) + id)
                                statRef.child("Question " + String(i)).setValue(["myAnswer": id])
                            }
                        })

                    
                
                }
                
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
                        "quizTitle": self.quizTitle.text!,
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

                
                
            } else {
                questionNumber++
                showQuestion()
                self.myAnswer = ""
            }
            
            
            
        } else {
        
            ///show alert dialog for finishing quiz
            let submitAlert = UIAlertController(title:"Please answer the question", message: "Choose one of the listed answers", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(submitAlert, animated: true, completion: nil)
            
            submitAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
            }))
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       // let selectedAnswer = tableView.cellForRowAtIndexPath(indexPath)
        
        print("My select " + String(indexPath.row))
        
        switch String(indexPath.row) {
        case "0" :
            self.myAnswer = "A"
        case "1" :
            self.myAnswer = "B"
        case "2" :
            self.myAnswer = "C"
        case "3" :
            self.myAnswer = "D"
            print(self.myAnswer)
        case "4" :
            self.myAnswer = "E"
        case "5" :
            self.myAnswer = "F"
        case "6" :
            self.myAnswer = "G"
        case "7" :
            self.myAnswer = "H"
        case "8" :
            self.myAnswer = "I"
        case "9" :
            self.myAnswer = "J"
        default:
            print("No answer")
        }
        //self.myAnswer = selectedAnswer!.textLabel!.text!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellAnswer", forIndexPath: indexPath)
        cell.textLabel?.text = myArray[indexPath.item]
        return cell
        
    }


}
