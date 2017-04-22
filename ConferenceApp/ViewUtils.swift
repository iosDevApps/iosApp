//
//  Background.swift
//  ConferenceApp
//
//  Created by matej on 4/21/17.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import UIKit


public enum AssetImage: String{
    case city = "city1"
}

class ViewUtils{
    
    public static func setBackground(view: UIView,image:AssetImage){
        
    UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: image.rawValue)?.draw(in: view.bounds)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
    view.backgroundColor = UIColor(patternImage: image)
        
        
        
    }
}
