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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    var videoFileURL: NSURL?
    
    var videoPlayer: AVPlayer!
    var playerLayer: AVPlayerLayer?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        stopButton.setBackgroundImage(UIImage(named: "VideoStop"), forState: .Highlighted)
        
        if videoFileURL != nil {
            let playerItem = AVPlayerItem(URL: videoFileURL!)
            
            self.videoPlayer = AVPlayer(playerItem: playerItem)
            self.playerLayer = AVPlayerLayer(player: self.videoPlayer)
            self.playerLayer?.frame = CGRectMake(0, 0, self.videoView.bounds.width, self.videoView.bounds.height)
            self.videoPlayer!.play()
            
            self.videoView.layer.addSublayer(self.playerLayer!)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playerDidReachEnd), name: AVPlayerItemDidPlayToEndTimeNotification, object:nil)

        }
    }
    
    func playerDidReachEnd(notification: NSNotification) {
        stopPlayVideo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setVideoURL(fileURL: NSURL) {
        videoFileURL = fileURL
    }
    
    // MARK: - event listener
    
    var isPlaying = true
    @IBAction func pausePressed(sender: AnyObject) {
        if (isPlaying) {
            self.videoPlayer.pause()
            playButton.setBackgroundImage(UIImage(named: "VideoPlay"), forState: .Normal)
        } else {
            self.videoPlayer.play()
            playButton.setBackgroundImage(UIImage(named: "VideoPause"), forState: .Normal)
        }
        isPlaying = !isPlaying
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        stopPlayVideo()
    }
    @IBAction func homeClick(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func stopPlayVideo () {
        self.videoPlayer.pause()
        
        self.videoPlayer.seekToTime(kCMTimeZero)
        
        isPlaying = false
        playButton.setBackgroundImage(UIImage(named: "VideoPlay"), forState: .Normal)
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
