//
//  FaceChooseViewController.swift
//  Kid REC
//
//  Created by Hat Dao on 4/9/16.
//  Copyright © 2016 Bang Dao. All rights reserved.
//

import UIKit


class FaceChooseViewController: UIViewController {

    @IBOutlet weak var face1: UIButton!
    @IBOutlet weak var face2: UIButton!
//    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var face1Result: UIImageView!
    @IBOutlet weak var face2Result: UIImageView!
    
    let rightImage = UIImage(named: "RightFace")
    let wrongImage = UIImage(named: "WrongFace")
    
    var correctImageView: UIImageView?
    var incorrectImageView: UIImageView?

    var stars = [UIImageView]()
    var correctAnswer = 0
    var correctTotal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        face1.setTitle("", forState: UIControlState.Normal)
        face2.setTitle("", forState: UIControlState.Normal)
        
//        wrongLabel.hidden = true
//        nextButton.hidden = true
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "FaceChooseBackground")!)
        
        displayFaces()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - event listener
    @IBAction func face1Select(sender: AnyObject) {
        chooseFace(0)
    }
    @IBAction func face2Select(sender: AnyObject) {
        chooseFace(1)
    }
    @IBAction func homeClick(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - choose face method
    func chooseFace(num: Int) {
        if (isCorrect(num)) {
            correctTotal += 1
            correctImageView?.hidden = false
        } else {
            incorrectImageView?.hidden = false
        }
        
        face1.enabled = false
        face2.enabled = false

        if correctTotal == 3 {
//            nextButton.hidden = false
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(jumpNextLevel), userInfo: nil, repeats: false)
        } else {
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(displayNextImages), userInfo: nil, repeats: false)
        }
    }
    
    func displayNextImages (time: AnyObject) {
        displayFaces()
    }
    
    func jumpNextLevel (time: AnyObject) {
        performSegueWithIdentifier("jumpToPuzzleFace", sender: self)
    }
    
    func generateNextFace() {
        correctAnswer = Int(arc4random_uniform(2))
    }
    
    func displayFaces() {
        generateNextFace()
        
        face1Result.hidden = true
        face2Result.hidden = true
        
        let happyFace = UIImage(named: "Happy\(correctTotal + 1)")
        let sadFace = UIImage(named: "Sad\(correctTotal + 1)")
        
        if correctAnswer == 0 {
            face1.setBackgroundImage(happyFace, forState: UIControlState.Normal)
            face2.setBackgroundImage(sadFace, forState: UIControlState.Normal)
            
            correctImageView = face1Result
            incorrectImageView = face2Result
        } else {
            face1.setBackgroundImage(sadFace, forState: UIControlState.Normal)
            face2.setBackgroundImage(happyFace, forState: UIControlState.Normal)
            
            correctImageView = face2Result
            incorrectImageView = face1Result
        }
        
        correctImageView?.image = rightImage
        incorrectImageView?.image = wrongImage
        
        face1.enabled = true
        face2.enabled = true
    }
    
    func isCorrect(num: Int) -> Bool {
        return num == correctAnswer
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
