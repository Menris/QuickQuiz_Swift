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
        // Do any additional setup after loading the view, typically from a nib.
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            
            if user != nil {
                
                print("User is signed IN")
            
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("StartingViewController") as! StartingViewController
            
                self.presentViewController(controller, animated: true, completion: nil)
                
            } else {
                print("user is now signed in")
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
            }
            else {
                print("Success Login")
            }
            })
    }

}

