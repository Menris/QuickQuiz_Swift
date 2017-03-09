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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
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

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
