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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
