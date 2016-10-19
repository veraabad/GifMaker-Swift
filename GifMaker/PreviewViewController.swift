//
//  PreviewViewController.swift
//  GifMaker
//
//  Created by Abad Vera on 10/18/16.
//  Copyright © 2016 Abad Vera. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate {
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif)
}

class PreviewViewController: UIViewController {
    
    var gif:Gif?
    @IBOutlet weak var gifImagePreview: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate: PreviewViewControllerDelegate! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let img = gif?.gifImage {
            gifImagePreview.image = img
        }
        self.title = "Preview"
        self.applyTheme(theme: .Dark)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Modify buttons appearance
        shareButton.layer.cornerRadius = cornerRad
        shareButton.layer.borderColor = UIColor(red: 255/255, green: 65/255, blue: 112/255, alpha: 1.0).cgColor
        shareButton.layer.borderWidth = CGFloat(1.0)
        
        saveButton.layer.cornerRadius = cornerRad
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action methods
    
    @IBAction func shareAction(_ sender: AnyObject) {
        do {
            let memedImage = try Data(contentsOf: gif?.url as! URL)
            let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            
            activityVC.completionWithItemsHandler = {(activityItems, completed, returnItems, error) -> Void in
                if completed {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            navigationController?.present(activityVC, animated: true, completion: nil)
        } catch  {
            print(error)
        }
        
    }
    
    @IBAction func createAndSave(_ sender: AnyObject) {
        delegate.previewVC(preview: self, didSaveGif: gif!)
        navigationController?.popToRootViewController(animated: true)
    }
    
}
