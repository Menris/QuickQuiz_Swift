//
//  ResultViewController.swift
//  QuickQuiz_Swift
//
//  Created by Admin on 01.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    var passedResult = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultLabel.text = self.passedResult
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func finishQuiz(sender: AnyObject) {
        
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("StartingViewController") as! StartingViewController
        
        self.presentViewController(controller, animated: true, completion: nil)

        
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
