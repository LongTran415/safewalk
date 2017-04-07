//
//  UIImage+imageScaledToSize.swift
//  Safe Walk
//
//  Created by Long Work on 4/6/17.
//  Copyright © 2017 safewalk. All rights reserved.
//

import UIKit

extension UIImage {
  
  func imageScaledToSize(_ newSize:CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    self.draw(in: rect)
    
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return newImage
  }
  
}
