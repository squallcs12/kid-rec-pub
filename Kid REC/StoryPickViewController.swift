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
    @IBOutlet weak var happyStoryImage: UIImageView!

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
    
    @IBAction func happyStoryPressed(sender: AnyObject) {
        NSTimer.scheduledTimerWithTimeInterval(0.33, target: self, selector: #selector(switchHappyFrame2), userInfo: nil, repeats: false)
    }
    
    func switchHappyFrame2(time: AnyObject) {
        happyStoryImage.image = UIImage(named: "StoryMap1Effect2")
        NSTimer.scheduledTimerWithTimeInterval(0.33, target: self, selector: #selector(switchHappyFrame3), userInfo: nil, repeats: false)
    }
    
    func switchHappyFrame3(time: AnyObject) {
        happyStoryImage.image = UIImage(named: "StoryMap1Effect3")
        NSTimer.scheduledTimerWithTimeInterval(0.33, target: self, selector: #selector(switchHappyFrame1), userInfo: nil, repeats: false)
    }
    
    func switchHappyFrame1(time: AnyObject) {
        happyStoryImage.image = UIImage(named: "StoryMap1Effect1")
        NSTimer.scheduledTimerWithTimeInterval(0.33, target: self, selector: #selector(jumpToFaceChoose), userInfo: nil, repeats: false)
    }
    
    func jumpToFaceChoose(time: AnyObject) {
        performSegueWithIdentifier("jumpToFaceChoose", sender: self)
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
