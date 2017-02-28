//
//  StartingViewController.swift
//  QuickQuiz_Swift
//
//  Created by Admin on 23.02.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class StartingViewController: UIViewController {
    

    @IBOutlet weak var PIN: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateBackground()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateBackground() {
        UIView.animateWithDuration(5.0, delay: 0.0, options: [UIViewAnimationOptions.Repeat, UIViewAnimationOptions.Autoreverse], animations: {
            self.view.backgroundColor = UIColor.blackColor()
            self.view.backgroundColor = UIColor.greenColor()
            self.view.backgroundColor = UIColor.yellowColor()
            self.view.backgroundColor = UIColor.redColor()
            }, completion: nil)
    }

    @IBAction func signOut(sender: AnyObject) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            
            self.presentViewController(controller, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print("Error Signing out : %@", signOutError)
        }
    }
    
    @IBAction func goQuiz(sender: AnyObject) {
        print("PIN is", PIN.text!)
        let pinController = storyboard?.instantiateViewControllerWithIdentifier("QuizViewController") as! QuizViewController
        pinController.passedPIN = PIN.text!
        
        navigationController?.pushViewController(pinController, animated: true)
        presentViewController(pinController, animated: true, completion: nil)
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
