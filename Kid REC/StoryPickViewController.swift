//
//  StoryPickViewController.swift
//  Kid REC
//
//  Created by Hat Dao on 4/9/16.
//  Copyright © 2016 Bang Dao. All rights reserved.
//

import UIKit

class StoryPickViewController: UIViewController {

    @IBOutlet weak var happyStoryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "StoryMap")!)
        navigationController?.setNavigationBarHidden(true, animated: false)
        happyStoryButton.setTitle("", forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
