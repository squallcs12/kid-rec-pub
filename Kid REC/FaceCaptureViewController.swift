//
//  FaceCaptureViewController.swift
//  Kid REC
//
//  Created by Hat Dao on 4/9/16.
//  Copyright © 2016 Bang Dao. All rights reserved.
//

import UIKit
import AVFoundation

class FaceCaptureViewController: UIViewController {
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        nextButton.hidden = true
        prepareCamera()
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
                
                previewLayer!.frame = previewView.bounds
                previewView.layer.addSublayer(previewLayer!)
                
            }
        }
        catch _ {
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession!.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Event listener
    @IBAction func takePhotoPressed(sender: AnyObject) {
        if captureSession!.running {
            if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo) {
                stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                    sampleBuffer, error in
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent(rawValue: 0)!)
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: .Down)
                    self.capturedImage.image = image
                    
                })
            }
            
            self.previewView.hidden = true
            self.capturedImage.hidden = false
            self.nextButton.hidden = false
            self.captureSession?.stopRunning()
            
            takePhotoButton.setBackgroundImage(UIImage(named: "Redo"), forState: .Normal)
        } else {
            self.previewView.hidden = false
            self.capturedImage.hidden = true
            self.nextButton.hidden = true
            self.captureSession?.startRunning()
            
            takePhotoButton.setBackgroundImage(UIImage(named: "PhotoIcon"), forState: .Normal)
        }
    }
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