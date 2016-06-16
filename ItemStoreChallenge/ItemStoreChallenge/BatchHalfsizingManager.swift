//
//  BatchHalfsizingManager.swift
//  ItemStoreChallenge
//
//  Created by Jack Lian on 16/06/2016.
//  Copyright © 2016 KitchenSpoon. All rights reserved.
//

import Foundation

class BatchHalfsizingManager
{
    var server: ItemStoreServer!
    
    init(server: ItemStoreServer)
    {
        self.server = server
    }
    
    
    func halfsizeAllItemsPhoto(items: [Item])
    {
        for item in items {
            server.getContentForItem(item, success: { (image: UIImage) in
                let newImage = image.halfSizeImage()
                self.replaceItemImage(item, image: newImage)
                }, failure: { (error: NSError) in
                    print("getContentForItem error = \(error) ")
            })
        }
    }
    
    
    //Make api call with server to replace the image of the item
    func replaceItemImage(item: Item, image: UIImage)
    {
        server.replaceContentForItem(item, withImage: image, success: {
            print("replaceItemImage success ")
            }, failure: { (error: NSError) in
                print("replaceItemImage error = \(error) ")
        })
    }

}