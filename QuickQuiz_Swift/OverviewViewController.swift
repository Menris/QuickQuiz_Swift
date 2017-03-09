//
//  OverviewViewController.swift
//  QuickQuiz_Swift
//
//  Created by Admin on 03.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class OverviewViewController: UIViewController {

    @IBOutlet weak var overViewTable: UITableView!
    var firebaseArray: [String] = []
    let user = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.populateTableView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateTableView() {
        let userInfo  = FIRDatabase.database().reference().child("userInformation").child(self.user!).child("myPassedQuizes")
        userInfo.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            for child in snapshot.children {
                let title = child.value!!["quizTitle"] as! String
                self.firebaseArray.append(title)
            }
            self.overViewTable.reloadData()
            
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
