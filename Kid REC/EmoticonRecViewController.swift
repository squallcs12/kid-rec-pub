//
//  EmotionRecViewController.swift
//  Kid REC
//
//  Created by Hat Dao on 4/9/16.
//  Copyright © 2016 Bang Dao. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO
import CoreVideo
import CoreMedia


class EmoticonRecViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var isRecording = false
    var isHaveVideo = false
    
    var captureSession: AVCaptureSession?
    var stillMovieOutput: AVCaptureVideoDataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    
    var choosenPhotos = [UIImage]()
    var outputSize = CGSizeMake(1280, 720)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareCamera()
        
        undoButton.hidden = true
        doneButton.hidden = true
        
        undoButton.setBackgroundImage(UIImage(named: "UndoPressed"), forState: .Highlighted)
        doneButton.setBackgroundImage(UIImage(named: "DonePressed"), forState: .Highlighted)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.captureSession?.startRunning()
    }
    
    func build(outputSize outputSize: CGSize) {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        guard let documentDirectory: NSURL = urls.first else {
            fatalError("documentDir Error")
        }
        
        let videoOutputURL = documentDirectory.URLByAppendingPathComponent("OutputVideo.mp4")
        
        if NSFileManager.defaultManager().fileExistsAtPath(videoOutputURL.path!) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(videoOutputURL.path!)
            } catch {
                fatalError("Unable to delete file: \(error) : \(#function).")
            }
        }
        
        guard let videoWriter = try? AVAssetWriter(URL: videoOutputURL, fileType: AVFileTypeMPEG4) else {
            fatalError("AVAssetWriter error")
        }
        
        let outputSettings = [AVVideoCodecKey : AVVideoCodecH264, AVVideoWidthKey : NSNumber(float: Float(outputSize.width)), AVVideoHeightKey : NSNumber(float: Float(outputSize.height))]
        
        guard videoWriter.canApplyOutputSettings(outputSettings, forMediaType: AVMediaTypeVideo) else {
            fatalError("Negative : Can't apply the Output settings...")
        }
        
        let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: outputSettings)
        let sourcePixelBufferAttributesDictionary = [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(unsignedInt: kCVPixelFormatType_32ARGB), kCVPixelBufferWidthKey as String: NSNumber(float: Float(outputSize.width)), kCVPixelBufferHeightKey as String: NSNumber(float: Float(outputSize.height))]
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
        
        if videoWriter.canAddInput(videoWriterInput) {
            videoWriter.addInput(videoWriterInput)
        }
        
        if videoWriter.startWriting() {
            videoWriter.startSessionAtSourceTime(kCMTimeZero)
            assert(pixelBufferAdaptor.pixelBufferPool != nil)
            
            let media_queue = dispatch_queue_create("mediaInputQueue", nil)
            
            videoWriterInput.requestMediaDataWhenReadyOnQueue(media_queue, usingBlock: { () -> Void in
                let fps: Int32 = 1
                let frameDuration = CMTimeMake(1, fps)
                
                var frameCount: Int64 = 0
                var appendSucceeded = true
                
                while (!self.choosenPhotos.isEmpty) {
                    if (videoWriterInput.readyForMoreMediaData) {
                        let nextPhoto = self.choosenPhotos.removeAtIndex(0)
                        let lastFrameTime = CMTimeMake(frameCount, fps)
                        let presentationTime = frameCount == 0 ? lastFrameTime : CMTimeAdd(lastFrameTime, frameDuration)
                        
                        var pixelBuffer: CVPixelBuffer? = nil
                        let status: CVReturn = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferAdaptor.pixelBufferPool!, &pixelBuffer)
                        
                        if let pixelBuffer = pixelBuffer where status == 0 {
                            let managedPixelBuffer = pixelBuffer
                            
                            CVPixelBufferLockBaseAddress(managedPixelBuffer, 0)
                            
                            let data = CVPixelBufferGetBaseAddress(managedPixelBuffer)
                            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
                            let context = CGBitmapContextCreate(data, Int(self.outputSize.width), Int(self.outputSize.height), 8, CVPixelBufferGetBytesPerRow(managedPixelBuffer), rgbColorSpace, CGImageAlphaInfo.PremultipliedFirst.rawValue)
                            
                            CGContextClearRect(context, CGRectMake(0, 0, CGFloat(self.outputSize.width), CGFloat(self.outputSize.height)))
                            
                            let horizontalRatio = CGFloat(self.outputSize.width) / nextPhoto.size.width
                            let verticalRatio = CGFloat(self.outputSize.height) / nextPhoto.size.height
                            //aspectRatio = max(horizontalRatio, verticalRatio) // ScaleAspectFill
                            let aspectRatio = min(horizontalRatio, verticalRatio) // ScaleAspectFit
                            
                            let newSize:CGSize = CGSizeMake(nextPhoto.size.width * aspectRatio, nextPhoto.size.height * aspectRatio)
                            
                            let x = newSize.width < self.outputSize.width ? (self.outputSize.width - newSize.width) / 2 : 0
                            let y = newSize.height < self.outputSize.height ? (self.outputSize.height - newSize.height) / 2 : 0
                            
                            CGContextDrawImage(context, CGRectMake(x, y, newSize.width, newSize.height), nextPhoto.CGImage)
                            
                            CVPixelBufferUnlockBaseAddress(managedPixelBuffer, 0)
                            
                            appendSucceeded = pixelBufferAdaptor.appendPixelBuffer(pixelBuffer, withPresentationTime: presentationTime)
                        } else {
                            print("Failed to allocate pixel buffer")
                            appendSucceeded = false
                        }
                    }
                    if !appendSucceeded {
                        break
                    }
                    frameCount += 1
                }
                videoWriterInput.markAsFinished()
                videoWriter.finishWritingWithCompletionHandler { () -> Void in
                    print("FINISHED!!!!!")
                }
            })
        }
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
                
                stillMovieOutput = AVCaptureVideoDataOutput()
                captureSession!.addOutput(stillMovieOutput)
                
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
    
    func imageFromSampleBuffer(sampleBuffer :CMSampleBufferRef) -> UIImage {
        let imageBuffer: CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        let baseAddress: UnsafeMutablePointer<Void> = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, Int(0))
        
        let bytesPerRow: Int = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width: Int = CVPixelBufferGetWidth(imageBuffer)
        let height: Int = CVPixelBufferGetHeight(imageBuffer)
        
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        
        let bitsPerCompornent: Int = 8
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue) as UInt32) as! UInt32
        let newContext: CGContextRef = CGBitmapContextCreate(baseAddress, width, height, bitsPerCompornent, bytesPerRow, colorSpace, bitmapInfo)! as CGContextRef
        
        let imageRef: CGImageRef = CGBitmapContextCreateImage(newContext)!
        let resultImage = UIImage(CGImage: imageRef)
        return resultImage
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didDropSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        let image = imageFromSampleBuffer(sampleBuffer) as! UIImage
        
        choosenPhotos.append(image)
    }
    
    // MARK: - event listener
    @IBAction func homeClick(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func recordPressed(sender: AnyObject) {
        isRecording = true
        undoButton.hidden = true
        doneButton.hidden = true
        
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: {
            granted in
            if granted {
                self.captureSession?.startRunning()
                print("start running")
            }
        })
//        
//        let queue = dispatch_queue_create("VideoRecord", nil)
//        stillMovieOutput?.setSampleBufferDelegate(self, queue: queue)
    }

    @IBAction func undoPressed(sender: AnyObject) {
        recordButton.hidden = false
        doneButton.hidden = true
        undoButton.hidden = true
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
