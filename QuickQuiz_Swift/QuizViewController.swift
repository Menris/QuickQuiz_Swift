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

    @IBOutlet weak var QuestionProgress: UILabel!
    @IBOutlet weak var Question: UILabel!
    var ref: FIRDatabaseReference!
    
    
    @IBOutlet weak var textQuestion: UITextView!
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        readQuestion()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readQuestion() {
        ref = FIRDatabase.database().reference().child("Tests").child("1203").child("Question 1")
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let CurrentQuestion = snapshot.value!["question"] as? String {
                print(CurrentQuestion)
                self.textQuestion.text = CurrentQuestion
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
