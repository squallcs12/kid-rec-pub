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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var wrongLabel: UILabel!
    
    var stars = [UIImageView]()
    var correctAnswer = 0
    var correctTotal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stars.append(star1)
        stars.append(star2)
        stars.append(star3)
        
        face1.setTitle("", forState: UIControlState.Normal)
        face2.setTitle("", forState: UIControlState.Normal)
        
        wrongLabel.hidden = true
        nextButton.hidden = true
        
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
    
    // MARK: - choose face method
    func chooseFace(num: Int) {
        if (isCorrect(num)) {
            correctTotal += 1
            wrongLabel.hidden = true
        } else {
            wrongLabel.hidden = false
        }
        
        updateStar()
        
        if correctTotal == 3 {
            face1.hidden = true
            face2.hidden = true
            nextButton.hidden = false
        } else {
            displayFaces()
        }
    }
    
    func generateNextFace() {
        correctAnswer = Int(arc4random_uniform(2))
    }
    
    func displayFaces() {
        generateNextFace()
        if correctAnswer == 0 {
            face1.setBackgroundImage(UIImage(named: "Happy1"), forState: UIControlState.Normal)
            face2.setBackgroundImage(UIImage(named: "Sad1"), forState: UIControlState.Normal)
        } else {
            face1.setBackgroundImage(UIImage(named: "Sad1"), forState: UIControlState.Normal)
            face2.setBackgroundImage(UIImage(named: "Happy1"), forState: UIControlState.Normal)
        }
    }
    
    func isCorrect(num: Int) -> Bool {
        return num == correctAnswer
    }
    
    func updateStar() {
        for i in 0 ..< correctTotal {
            let star = stars[i] as UIImageView
            star.highlighted = true
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
