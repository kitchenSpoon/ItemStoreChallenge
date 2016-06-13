//
//  UIImage+Resizing.swift
//  ItemStoreChallenge
//
//  Created by Jack Lian on 13/06/2016.
//  Copyright © 2016 KitchenSpoon. All rights reserved.
//

import Foundation

extension UIImage {
    
    func halfSizeImage() -> UIImage
    {
        let currentSize = self.size
        return resize(currentSize.width/2, newHeight: currentSize.height/2)
    }
    
    
    func resize(newWidth: CGFloat, newHeight: CGFloat) -> UIImage
    {
        let currentSize = self.size
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContext(newSize)
        self.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}