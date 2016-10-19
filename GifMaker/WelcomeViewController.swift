//
//  WelcomeViewController.swift
//  GifMaker
//
//  Created by Abad Vera on 10/18/16.
//  Copyright © 2016 Abad Vera. All rights reserved.
//

import UIKit
import MobileCoreServices

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let proofOfConcept = UIImage.gif(name: "tinaFeyHiFive")
        gifImageView.image = proofOfConcept
        
        UserDefaults.standard.set(true, forKey: "WelcomeViewSeen")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
