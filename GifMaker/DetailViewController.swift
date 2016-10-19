//
//  DetailViewController.swift
//  GifMaker
//
//  Created by Abad Vera on 10/18/16.
//  Copyright © 2016 Abad Vera. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var gif: Gif?
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load gif into gifImageView
        if let img = gif?.gifImage {
            gifImageView.image = img
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismissViewController(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareGif(_ sender: AnyObject) {
        var itemsToShare = [NSData]()
        itemsToShare.append((self.gif?.gifData)!)
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(activity, completed, returnedItems, error) -> Void in
            if completed {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityVC, animated: true, completion: nil)
    }
}
