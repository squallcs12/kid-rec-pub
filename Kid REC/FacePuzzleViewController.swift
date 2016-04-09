//
//  FacePuzzleViewController.swift
//  Kid REC
//
//  Created by Hat Dao on 4/9/16.
//  Copyright © 2016 Bang Dao. All rights reserved.
//

import UIKit

class FacePuzzleViewController: UIViewController {

    @IBOutlet weak var eyeBrown: UIImageView!
    @IBOutlet weak var eyes: UIImageView!
    @IBOutlet weak var mouth: UIImageView!
    
    @IBOutlet weak var eyeBrownButton1: UIButton!
    @IBOutlet weak var eyeButton1: UIButton!
    @IBOutlet weak var mouthButton1: UIButton!
    @IBOutlet weak var eyeBrownButton2: UIButton!
    @IBOutlet weak var eyeButton2: UIButton!
    @IBOutlet weak var mouthButton2: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var isEyeBrownCorrect = false
    var isEyeCorrect = false
    var isMouthCorrect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eyeBrown.hidden = true
        eyes.hidden = true
        mouth.hidden = true
        nextButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - event listener
    @IBAction func eyeBrownButton1Click(sender: UIButton) {
        eyeBrown.image = sender.currentBackgroundImage
        eyeBrown.hidden = false
        isEyeBrownCorrect = false
        showResult()
    }
    @IBAction func eyeBrownButton2Click(sender: UIButton) {
        eyeBrown.image = sender.currentBackgroundImage
        eyeBrown.hidden = false
        isEyeBrownCorrect = true
        showResult()
    }
    
    @IBAction func eyeButton1Click(sender: UIButton) {
        eyes.image = sender.currentBackgroundImage
        eyes.hidden = false
        isEyeCorrect = true
        showResult()
    }
    @IBAction func eyeButton2Click(sender: UIButton) {
        eyes.image = sender.currentBackgroundImage
        eyes.hidden = false
        isEyeCorrect = false
        showResult()
    }
    
    @IBAction func mouthButton1Click(sender: UIButton) {
        mouth.image = sender.currentBackgroundImage
        mouth.hidden = false
        isMouthCorrect = false
        showResult()
    }
    @IBAction func mouthButton2Click(sender: UIButton) {
        mouth.image = sender.currentBackgroundImage
        mouth.hidden = false
        isMouthCorrect = true
        showResult()
    }
    
    func showResult() {
        if isMouthCorrect && isEyeBrownCorrect && isEyeCorrect {
            nextButton.hidden = false
        }
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
