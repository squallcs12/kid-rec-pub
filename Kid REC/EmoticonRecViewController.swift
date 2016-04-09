//
//  EmotionRecViewController.swift
//  Kid REC
//
//  Created by Hat Dao on 4/9/16.
//  Copyright © 2016 Bang Dao. All rights reserved.
//

import UIKit
import AVFoundation

class EmoticonRecViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "EmoticonRecBackground")!)
        
        prepareCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.captureSession?.startRunning()
    }
    
    func prepareCamera() {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
            
            if captureSession!.canAddInput(input) {
                captureSession!.addInput(input)
                
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                if ((previewLayer!.connection?.supportsVideoOrientation) != nil) {
                    previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
                }
                
                previewLayer!.frame = self.view.bounds
                self.view.layer.addSublayer(previewLayer!)
                
            }
        }
        catch _ {
            
        }
    }
    
    // MARK: - event listener
    @IBAction func homeClick(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
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
