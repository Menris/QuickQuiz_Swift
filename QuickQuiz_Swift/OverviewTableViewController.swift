//
//  OverviewTableViewController.swift
//  QuickQuiz_Swift
//
//  Created by Admin on 03.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct quizStruct {
    let title : String!
    let ID : String!
}

class OverviewTableViewController: UITableViewController {
    
    @IBOutlet var ResultTableView: UITableView!
    
    var quizes = [quizStruct]()
    var firebaseArray: [String] = []
    let user = FIRAuth.auth()?.currentUser?.uid
    
    var valueToPass:String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateTableView()
        self.title = "Quizes overview"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back_main.png")!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell!.backgroundColor = UIColor.clearColor()
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = quizes[indexPath.row].title
        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = quizes[indexPath.row].ID
        return cell!
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /*let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        self.valueToPass = currentCell.textLabel!.text
        performSegueWithIdentifier("myQuizSegue", sender: self)*/
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        print("Row: \(row)")
        
        let checkViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CheckViewController") as! CheckViewController
        checkViewController.passedPIN = quizes[indexPath.row].ID
        self.navigationController?.pushViewController(checkViewController, animated: true)
    
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "myQuizSegue") {
            let controller = segue.destinationViewController as! CheckViewController
            
            controller.passedValue = self.valueToPass
        }
    }*/

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quizes.count
    }
    
    func populateTableView() {
        
        
        let userInfo  = FIRDatabase.database().reference().child("userInformation").child(self.user!).child("myPassedQuizes")
        userInfo.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            let quizTitle = snapshot.value!["quizTitle"] as! String
            let quizID = snapshot.value!["quizID"] as! String
            
            self.quizes.insert(quizStruct(title: quizTitle, ID: quizID), atIndex: 0)
            self.tableView.reloadData()
        })
    }

    
}
