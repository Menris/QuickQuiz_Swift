//
//  RegistrationViewController.swift
//  QuickQuiz_Swift
//
//  Created by Admin on 23.02.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegistrationViewController: UIViewController {
    

    var ref: FIRDatabaseReference!
    
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var GroupName: UITextField!
    var Role = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func studentSelect(sender: AnyObject) {
        Role = "students"
        print ("Student")
    }
    @IBAction func teacherSelect(sender: AnyObject) {
        Role = "teachers"
        print ("Teacher")
    }
    @IBAction func createUser(sender: AnyObject) {
        
        FIRAuth.auth()?.createUserWithEmail(Email.text!, password: Password.text!, completion: {
            user, error in
            if error != nil{
                print("Failed")
            }
            else {
                self.ref = FIRDatabase.database().reference()
                let user = FIRAuth.auth()?.currentUser?.uid
                self.ref.child("userInformation").child(user!).setValue([   "name": self.Username.text!,
                                                                            "group": self.GroupName.text!,
                                                                            "role": self.Role,
                                                                            "email": self.Email.text!])
                print("User Created")
            }
        })
        
    }

    @IBAction func registerUser(sender: AnyObject) {
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
