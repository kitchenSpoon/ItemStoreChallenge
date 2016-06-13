//
//  ItemStoreListTableViewController.swift
//  ItemStoreChallenge
//
//  Created by Jack Lian on 13/06/2016.
//  Copyright © 2016 KitchenSpoon. All rights reserved.
//

import UIKit

typealias completionBlock = (success: Bool) -> Void

class ItemStoreListTableViewController: UIViewController
{

    @IBOutlet weak var tableView: UITableView!
    
    var itemStoreItems = [Item]()
    var nextCursor: String? = nil
    var server = ItemStoreServer()
    var detailViewSegue = "showDetailView"
    var createViewSegue = "showCreateView"
    var selectedItem: Item? = nil //Used to store the selected item before passing it to ItemStoreDetailViewController
    var reachedEnd = false        //Used to know whether we've reached the end of the item list
    
    
    @IBAction func didClickHalfsizeButton(sender: UIButton)
    {
        fetchAndHalfsizeAllItemsPhoto(server)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchItems(server, nextCursor: nextCursor)
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: API
    //NextCursor is used for pagination and specifies the offset to fetch the next batch
    func fetchItems(server: ItemStoreServer, nextCursor: String?)
    {
        server.getItemsWithNextCursor(nextCursor, success: { (items:[Item], newNextCursor: String?) in
            if items.count == 0 {
                self.reachedEnd = true
            }
            
            self.itemStoreItems += items
            self.tableView.reloadData()
            self.nextCursor = newNextCursor
        }) { ( error:NSError ) in
            print("getItemsWithNextCursor error = \(error)")
        }
    }
    
    
    //Fetch all items first then
    func fetchAndHalfsizeAllItemsPhoto(server: ItemStoreServer)
    {
        fetchAllItems(server, nextCursor: nextCursor) { (success) in
            if success {
                self.halfsizeAllItemsPhoto(server, items: self.itemStoreItems)
            } else {
                print("error half sizing")
            }
        }
    }
    
    
    func halfsizeAllItemsPhoto(server: ItemStoreServer, items: [Item])
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
    
    
    //Fetch all items until we reach the end, call the completion block when we reach the end or when it encounters an error
    func fetchAllItems(server: ItemStoreServer, nextCursor: String?, completion: completionBlock)
    {
        if !reachedEnd {
            server.getItemsWithNextCursor(nextCursor, success: { (items:[Item], newNextCursor: String?) in
                if items.count == 0 {
                    self.reachedEnd = true
                }
                
                self.itemStoreItems += items
                self.tableView.reloadData()
                self.nextCursor = newNextCursor
                
                if !self.reachedEnd {
                    //Fetch the next batch of items if there are still more
                    self.fetchAllItems(server, nextCursor: newNextCursor, completion: completion)
                }
            }) { ( error:NSError ) in
                print("getItemsWithNextCursor error = \(error)")
                completion(success: false)
            }
        } else {
            completion(success: true)
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
 
    
    //MARK: Navigation helpers
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if  segue.identifier == detailViewSegue {
            guard let vc = segue.destinationViewController as? ItemStoreDetailViewController else { return }
            vc.selectedItem = selectedItem
            vc.server = server
            vc.delegate = self
        } else if segue.identifier == createViewSegue {
            guard let vc = segue.destinationViewController as? ItemStoreCreateItemViewController else { return }
            vc.server = server
        }
    }
}


//MARK: UITableViewDelegate, UITableViewDataSource
extension ItemStoreListTableViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemStoreItems.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.text = itemStoreItems[indexPath.row].name
        return cell
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        //Fetch new items when we reach the end of the list
        if indexPath.row == itemStoreItems.count - 1 {
            fetchItems(server, nextCursor: nextCursor)
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectedItem = itemStoreItems[indexPath.row]
        performSegueWithIdentifier(detailViewSegue, sender: self)
    }
}


//MARK: ItemStoreDetailDelegate
extension ItemStoreListTableViewController: ItemStoreDetailDelegate {
    func didDeleteItem(deletedItem: Item) {
        //Remove deleted item
        itemStoreItems = itemStoreItems.filter { (item: Item) -> Bool in
            item.itemId != deletedItem.itemId
        }
        
        tableView.reloadData()
    }
}