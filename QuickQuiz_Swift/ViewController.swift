//
//  ViewController.swift
//  QuickQuiz_Swift
//
//  Created by Admin on 22.02.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back_main.png")!)
        // Do any additional setup after loading the view, typically from a nib.
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            
            if user != nil {
                
                print("User is signed IN")
            
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("StartingViewController") as! StartingViewController
            
                self.presentViewController(controller, animated: true, completion: nil)
                
            } else {
                print("user is NOT signed in")
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginUser(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(Email.text!, password: Password.text!, completion: {
            user, error in
            if error != nil{
                print("Incorrect Email or Password")
                ///show alert dialog for finishing quiz
                let submitAlert = UIAlertController(title:"Incorrect email or password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(submitAlert, animated: true, completion: nil)
                
                submitAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
                }))
            }
            else {
                print("Success Login")
            }
            })
    }

}

