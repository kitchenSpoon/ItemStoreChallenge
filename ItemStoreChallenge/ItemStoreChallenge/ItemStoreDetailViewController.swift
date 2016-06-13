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
    
    @IBOutlet weak var itemContentImageView: UIImageView!
    
    @IBOutlet weak var itemIdLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemOwnerLabel: UILabel!
    
    
    override func viewDidLoad() {
        configureUI(selectedItem)
    }
    
    
    func configureUI(item: Item?)
    {
        guard let item = item else { return }
        itemIdLabel.text = item.itemId
        itemNameLabel.text = item.name
        itemOwnerLabel.text = item.owner
    }
    
}