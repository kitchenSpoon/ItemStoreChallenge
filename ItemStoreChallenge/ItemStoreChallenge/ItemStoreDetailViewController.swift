//
//  ItemStoreDetailViewController.swift
//  ItemStoreChallenge
//
//  Created by Jack Lian on 13/06/2016.
//  Copyright © 2016 KitchenSpoon. All rights reserved.
//

import Foundation

protocol ItemStoreDetailDelegate
{
    func didDeleteItem(deletedItem: Item)
}


class ItemStoreDetailViewController: UIViewController
{
    var selectedItem: Item?
    var server: ItemStoreServer?
    var delegate: ItemStoreDetailDelegate?
    
    @IBOutlet weak var itemContentImageView: UIImageView!
    @IBOutlet weak var itemIdLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemOwnerLabel: UILabel!
    @IBOutlet weak var waterMarkLabel: UILabel!
    
    
    @IBAction func didClickTrashButton(sender: UIBarButtonItem)
    {
        guard let item = selectedItem else { return }
        deleteItem(item)
    }
    
    
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
    
    
    //MARK: API
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
    
    
    func deleteItem(item: Item)
    {
        server?.deleteItem(item, success: { 
            print("deleteItem is successful")
            //Notify the ItemStoreListTableViewController that the item has been deleted so it can remove the deleted item from the datasource
            self.delegate?.didDeleteItem(item)
            self.navigationController?.popViewControllerAnimated(true)
        }, failure: { (error: NSError) in
            print("deleteItem error = \(error) ")
        })
    }
}