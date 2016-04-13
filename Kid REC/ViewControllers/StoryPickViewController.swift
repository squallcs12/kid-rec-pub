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
  @IBOutlet weak var happyStoryImageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.setNavigationBarHidden(true, animated: false)
    happyStoryButton.setTitle("", forState: .Normal)
  }
}

//MARK: User Interaction
extension StoryPickViewController {
  @IBAction func happyStoryPressed(sender: AnyObject) {
    happyStoryImageView.animationImages = [UIImage.init(named: "StoryMap1Effect2")!, UIImage.init(named: "StoryMap1Effect3")!, UIImage.init(named: "StoryMap1Effect1")!]
    happyStoryImageView.animationDuration = 1
    happyStoryImageView.animationRepeatCount = 1
    happyStoryImageView.startAnimating()
    NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(finishedAnimating), userInfo: nil, repeats: false)
  }

  func finishedAnimating(time: AnyObject) {
    performSegueWithIdentifier("StoryPickToFaceChooseSegue", sender: self)
  }
}
