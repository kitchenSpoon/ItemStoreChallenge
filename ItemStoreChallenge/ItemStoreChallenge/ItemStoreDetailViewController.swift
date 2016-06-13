//
//  ItemStoreDetailViewController.swift
//  ItemStoreChallenge
//
//  Created by Jack Lian on 13/06/2016.
//  Copyright © 2016 KitchenSpoon. All rights reserved.
//

import Foundation


class ItemStoreDetailViewController: UIViewController
{
    var selectedItem: Item?
    var server: ItemStoreServer?
    
    @IBOutlet weak var itemContentImageView: UIImageView!
    
    @IBOutlet weak var itemIdLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemOwnerLabel: UILabel!
    @IBOutlet weak var waterMarkLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        configureUI(selectedItem)
    }
    
    
    func configureUI(item: Item?)
    {
        guard let item = item else { return }
        itemIdLabel.text = item.itemId
        itemNameLabel.text = item.name
        itemOwnerLabel.text = item.owner
        waterMarkLabel.text = NSDate().description
        
        fetchAndSetContentForItem(item)
    }
    
    
    func fetchAndSetContentForItem(item: Item)
    {
        server?.getContentForItem(item, success: { (image: UIImage) in
            dispatch_async(dispatch_get_main_queue(), {
                self.itemContentImageView.image = image
            })
            }, failure: { (error: NSError) in
                print("getContentForItem error = \(error) ")
        })
    }
}