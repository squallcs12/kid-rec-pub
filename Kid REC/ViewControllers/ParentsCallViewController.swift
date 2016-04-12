//
//  ParentsCallViewController.swift
//  Kid REC
//
//  Created by Hat Dao on 4/9/16.
//  Copyright © 2016 Bang Dao. All rights reserved.
//

import UIKit

class ParentsCallViewController: UIViewController {
    @IBOutlet weak var parentsCallButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "ParentsCallBackground")!)
        parentsCallButton.setBackgroundImage(UIImage(named: "ParentsCallButtonPressed"), forState: .Highlighted)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - event listener
    @IBAction func homeClick(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func parentsCallPressed(sender: AnyObject) {
        
    }

}
