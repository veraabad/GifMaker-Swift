//
//  UIViewController+Record.swift
//  GifMaker
//
//  Created by Abad Vera on 10/18/16.
//  Copyright © 2016 Abad Vera. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation

let frameCount = 16
let frameRate = 15
let delayTime:Float = 0.2
let loopCount = 0
let cornerRad = CGFloat(4.0)

extension UIViewController {
    
    @IBAction func presentVideoOptions(_ sender: AnyObject) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            launchPhotoLibrary()
        }
        else {
            let newGifActionSheet = UIAlertController(title: "Create New Gif", message: nil, preferredStyle: .actionSheet)
            
            let recordVideo = UIAlertAction(title: "Record a Video", style: .default, handler: {(UIAlertAction) in
                self.launchVideoCamera()
            })
            
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: .default, handler: {(UIAlertAction) in
                self.launchPhotoLibrary()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            newGifActionSheet.addAction(recordVideo)
            newGifActionSheet.addAction(chooseFromExisting)
            newGifActionSheet.addAction(cancel)
            
            present(newGifActionSheet, animated: true, completion: nil)
            let pinkColor = UIColor(red: 255/255, green: 65/255, blue: 112/255, alpha: 1.0)
            newGifActionSheet.view.tintColor = pinkColor
        }
    }
    
    func launchVideoCamera() {
        // create imagePicker
        let recordVideoController = imagePicker(source: .camera)
        
        present(recordVideoController, animated: true, completion: nil)
    }
    
    func launchPhotoLibrary() {
        let pickerController = imagePicker(source: .photoLibrary)
        
        self.present(pickerController, animated: true, completion: nil)
    }
}

// MARK: - UIViewController: UINavigationControllerDelegate

extension UIViewController: UINavigationControllerDelegate {
    
}

// MARK: - UIViewController: UIImagePickerControllerDelegate

extension UIViewController: UIImagePickerControllerDelegate {
    func imagePicker(source: UIImagePickerControllerSourceType) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = self
        picker.allowsEditing = true
        
        return picker
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeMovie as String {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            
            let start = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber
            let end = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber
            var duration: NSNumber?
            if let start = start {
                duration = NSNumber(value: end!.floatValue - start.floatValue)
            }
            else {
                duration = nil
            }
            
            cropVideoToSquare(rawVideoURL: videoURL, start: start, duration: duration)
        }
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func cropVideoToSquare(rawVideoURL: NSURL, start: NSNumber?, duration: NSNumber?) {
        // Create AVAsset and AVAssetTrack
        let videoAsset = AVAsset(url: rawVideoURL as URL)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0]
        
        // Crop to square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.height)
        videoComposition.frameDuration = CMTimeMake(60, 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: kCMTimeZero, duration: CMTimeMakeWithSeconds(60, 30))
        
        // rotate to portrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        let t1 = CGAffineTransform(translationX: videoTrack.naturalSize.height, y: -(videoTrack.naturalSize.width - videoTrack.naturalSize.height) / 2)
        let finalTransform = t1.rotated(by: CGFloat(M_PI_2))
        
        transformer.setTransform(finalTransform, at: kCMTimeZero)
        instruction.layerInstructions.append(transformer)
        videoComposition.instructions.append(instruction)
        
        // export
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.videoComposition = videoComposition
        let path = createPath()
        exporter?.outputURL = URL(fileURLWithPath: path)
        exporter?.outputFileType = AVFileTypeQuickTimeMovie
        
        var croppedURL:NSURL?
        exporter?.exportAsynchronously { () in
            croppedURL = exporter!.outputURL! as NSURL?
            self.convertVideoToGif(videoURL: croppedURL!, start: start, duration: duration)
        }
    }
    
    func createPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let manager = FileManager.default
        var outputURL = documentsDirectory.appendingPathComponent("output") as NSString
        do {
            try manager.createDirectory(atPath: outputURL as String, withIntermediateDirectories: true, attributes: nil)
        } catch  {
            print(error)
        }
        outputURL = outputURL.appendingPathComponent("output.mov") as NSString
        
        // Remove Existing file
        do {
            try manager.removeItem(atPath: outputURL as String)
        } catch  {
            print(error)
        }
        
        return String(outputURL)
    }
    
    func convertVideoToGif(videoURL: NSURL, start: NSNumber?, duration: NSNumber?) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
        
        let regift: Regift
        
        if let start = start {
            regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, startTime: start as Float, duration: duration as! Float, frameRate: frameRate, loopCount: loopCount)
        }
        else {
            regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        }
        
        
        let gifURL = regift.createGif()
        let gif = Gif(url: gifURL!, videoURL: videoURL, caption: nil)
        displayGif(gif: gif)
    }
    
    func displayGif(gif: Gif) {
        let gifEditorVC = self.storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gifEditorVC.gif = gif
        self.navigationController?.pushViewController(gifEditorVC, animated: true)
    }
}
