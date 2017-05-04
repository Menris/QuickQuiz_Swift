//
//  ProfileTabViewController.swift
//  QuickQuiz_Swift
//
//  Created by Admin on 01.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProfileTabViewController: UIViewController {
    
    let user = FIRAuth.auth()?.currentUser?.uid

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftLoading().showLoading()
        self.getUserInfo()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back_main.png")!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goQuiz(sender: AnyObject) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("StartingViewController") as! StartingViewController
        
        self.presentViewController(controller, animated: true, completion: nil)

    }
    func getUserInfo() {
        
        let userInfo = FIRDatabase.database().reference().child("userInformation").child(self.user!)
        userInfo .observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let fUserName = snapshot.value!["name"] as? String {
                print(fUserName)
                self.userName.text! = fUserName
            }
            
            if let fUserEmail = snapshot.value!["role"] as? String {
                print(fUserEmail)
                self.userEmail.text! = fUserEmail
            }
            
        })
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 3 )
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), {() -> Void in
            SwiftLoading().hideLoading()
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
