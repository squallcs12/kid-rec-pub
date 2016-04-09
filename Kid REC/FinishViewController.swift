//
//  FinishViewController.swift
//  Kid REC
//
//  Created by Hat Dao on 4/10/16.
//  Copyright © 2016 Bang Dao. All rights reserved.
//

import UIKit
import AVFoundation

class FinishViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!

    var videoFileURL: NSURL?
    
    var videoPlayer: AVPlayer!
    var playerLayer: AVPlayerLayer?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if videoFileURL != nil {
            let playerItem = AVPlayerItem(URL: videoFileURL!)
            
            self.videoPlayer = AVPlayer(playerItem: playerItem)
            self.playerLayer = AVPlayerLayer(player: self.videoPlayer)
    //        self.playerLayer!.frame = self.videoView.frame
    //        self.playerLayer?.bounds = self.videoView.
            self.playerLayer?.frame = CGRectMake(0, 0, self.videoView.bounds.width, self.videoView.bounds.height)
            self.videoPlayer!.play()
            
            self.videoView.layer.addSublayer(self.playerLayer!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setVideoURL(fileURL: NSURL) {
        videoFileURL = fileURL
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
