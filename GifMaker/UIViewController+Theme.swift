//
//  UIViewController+Theme.swift
//  GifMaker
//
//  Created by Abad Vera on 10/19/16.
//  Copyright © 2016 Abad Vera. All rights reserved.
//

import Foundation
import UIKit

enum Theme {
    case Light, Dark, DarkTranslucent
}

let pinkRed = UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 102.0/255.0, alpha: 1.0)
let grayBlue = UIColor(red: 46.0/255.0, green: 61.0/255.0, blue: 73.0/255.0, alpha: 1.0)

extension UIViewController {
    func applyTheme(theme: Theme) {
        switch theme {
        case .Light:
            if let navController = self.navigationController {
                navController.navigationBar.setBackgroundImage(nil, for: .default)
                navController.navigationBar.barTintColor = UIColor.white
                navController.navigationBar.tintColor = pinkRed
                navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: grayBlue]
                
                self.view.backgroundColor = UIColor.white
            }
            
        case .Dark:
            if let navController = self.navigationController {
                self.view.backgroundColor = grayBlue
                navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navController.navigationBar.shadowImage = UIImage()
                navController.navigationBar.isTranslucent = true
                navController.view.backgroundColor = grayBlue
                navController.navigationBar.backgroundColor = grayBlue
                self.edgesForExtendedLayout = UIRectEdge()
                
                navController.navigationBar.tintColor = UIColor.white
                navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            }
            
        case .DarkTranslucent:
            self.view.backgroundColor = grayBlue.withAlphaComponent(0.9)
        }
    }
}
