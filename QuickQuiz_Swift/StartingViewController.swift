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
    @IBOutlet weak var appTitle: UILabel!
    
    var backgroundColors = [UIColor()]
    var backgroundLoop = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundColors = [UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.greenColor()]
        backgroundLoop = 0
        self.animateBackground()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateBackground() {
        if backgroundLoop < backgroundColors.count - 1 {
            backgroundLoop++
        } else {
            backgroundLoop = 0
        }
        
        UIView.animateWithDuration(2.5, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.view.backgroundColor = self.backgroundColors[self.backgroundLoop]
            }) {(Bool) -> Void in
                self.animateBackground()
        }
        
    }

    @IBAction func signOut(sender: AnyObject) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
            
            self.presentViewController(controller, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print("Error Signing out : %@", signOutError)
        }
    }
    
    @IBAction func goQuiz(sender: AnyObject) {
        print("PIN is", PIN.text!)
        let pinController = storyboard?.instantiateViewControllerWithIdentifier("QuizViewController") as! QuizViewController
        pinController.passedPIN = String(self.PIN.text!)
        
        navigationController?.pushViewController(pinController, animated: true)
        presentViewController(pinController, animated: true, completion: nil)
    }
    
    
    @IBAction func goProfile(sender: AnyObject) {
        
        /*let tabController = self.storyboard?.instantiateViewControllerWithIdentifier("TabNavigationController") as! UINavigationController
        
        self.presentViewController(tabController, animated: true, completion: nil)*/
        
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
