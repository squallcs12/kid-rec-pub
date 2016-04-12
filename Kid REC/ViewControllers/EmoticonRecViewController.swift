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
import AssetsLibrary
import Photos


class EmoticonRecViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var isRecording = false
    var isHaveVideo = false
    
    var captureSession: AVCaptureSession?
    var stillMovieOutput: AVCaptureMovieFileOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var videoFileURL: NSURL!
    var videoFileInGalleryURL: NSURL!
    
    var choosenPhotos = [UIImage]()
    var outputSize = CGSizeMake(1280, 720)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareCamera()
        
        undoButton.hidden = true
        doneButton.hidden = true
        stopButton.hidden = true
        
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
    
    func prepareCamera() {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPreset1280x720
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
//            
            if captureSession!.canAddInput(input) {
                captureSession!.addInput(input)
                
                
                stillMovieOutput = AVCaptureMovieFileOutput()
                stillMovieOutput?.maxRecordedDuration = CMTimeMake(180, 24)
                
                captureSession!.beginConfiguration()
                captureSession!.addOutput(stillMovieOutput)
                
                
                let connection = stillMovieOutput?.connectionWithMediaType(AVMediaTypeVideo)
                if ( connection!.activeVideoStabilizationMode != AVCaptureVideoStabilizationMode.Auto ) {
                    connection!.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.Auto
                }
                connection!.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
                captureSession!.commitConfiguration()


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
    
    var image: UIImage!
    var assetCollection: PHAssetCollection!
    var albumFound : Bool = false
    var photosAsset: PHFetchResult!
    var assetThumbnailSize:CGSize!
    var collection: PHAssetCollection!
    var assetCollectionPlaceholder: PHObjectPlaceholder!

    func createAlbum() {
        //Get PHFetch Options
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", "Kid REC")
        let collection : PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        //Check return value - If found, then get the first album out
        if let _: AnyObject = collection.firstObject {
            self.albumFound = true
            assetCollection = collection.firstObject as! PHAssetCollection
        } else {
            //If not found - Then create a new album
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let createAlbumRequest : PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle("camcam")
                self.assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
                }, completionHandler: { success, error in
                    self.albumFound = (success ? true: false)
                    
                    if (success) {
                        let collectionFetchResult = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([self.assetCollectionPlaceholder.localIdentifier], options: nil)
                        print(collectionFetchResult)
                        self.assetCollection = collectionFetchResult.firstObject as! PHAssetCollection
                    }
            })
        }
    }
    
    func saveVideo(fileURL: NSURL) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(fileURL)
            let assetPlaceholder = assetRequest!.placeholderForCreatedAsset
            let photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
            
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: photosAsset)
            albumChangeRequest!.addAssets([assetPlaceholder!])
        }, completionHandler: {
            success, error in
            
            if (success) {
                print("success save video")
            } else {
                print("error save video")
            }
        })
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        createAlbum()
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        // code
        if error != nil {
            return
        }
        videoFileURL = outputFileURL
    }
    
    func startRecording () {
        isRecording = true

        let filename = NSProcessInfo.processInfo().globallyUniqueString
        let outputFilePath = NSTemporaryDirectory().stringByAppendingString("\(filename).mov")
        let url = NSURL(fileURLWithPath: outputFilePath)

        stillMovieOutput?.startRecordingToOutputFileURL(url, recordingDelegate: self)
    }
    
    func stopRecording () {
        isRecording = false

        stillMovieOutput?.stopRecording()
    }
    
    // MARK: - event listener
    @IBAction func homeClick(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func recordPressed(sender: AnyObject) {
        startRecording()
        
        undoButton.hidden = true
        doneButton.hidden = true
        recordButton.hidden = true
        stopButton.hidden = false
    }

    @IBAction func stopPressed(sender: AnyObject) {
        stopRecording()
        
        undoButton.hidden = false
        doneButton.hidden = false
        recordButton.hidden = true
        stopButton.hidden = true
    }
    
    @IBAction func undoPressed(sender: AnyObject) {
        recordButton.hidden = false
        doneButton.hidden = true
        undoButton.hidden = true
    }

    @IBAction func donePressed(sender: AnyObject) {
        saveVideo(videoFileURL)
        performSegueWithIdentifier("jumpToViewVideo", sender: self)
    }
    
    // MARK: - Segue setup
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "jumpToViewVideo" {
            let destination = segue.destinationViewController as! AcceptViewController
            destination.setVideoURL(videoFileURL)
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
