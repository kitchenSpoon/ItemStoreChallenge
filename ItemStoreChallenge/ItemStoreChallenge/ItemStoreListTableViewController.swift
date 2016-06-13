//
//  ItemStoreListTableViewController.swift
//  ItemStoreChallenge
//
//  Created by Jack Lian on 13/06/2016.
//  Copyright © 2016 KitchenSpoon. All rights reserved.
//

import UIKit

class ItemStoreListTableViewController: UIViewController
{

    @IBOutlet weak var tableView: UITableView!
    var itemStoreItems = [Item]()
    var nextCursor: String? = nil
    var server = ItemStoreServer()
    var detailViewSegue = "showDetailView"
    var selectedItem: Item? = nil
    
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

    
    //NextCursor is used for pagination and specifies the offset to fetch the next batch
    func fetchItems(server: ItemStoreServer, nextCursor: String?)
    {
        server.getItemsWithNextCursor(nextCursor, success: { (items:[Item], newNextCursor: String?) in
            self.itemStoreItems += items
            self.tableView.reloadData()
            self.nextCursor = newNextCursor
        }) { ( error:NSError ) in
            print("getItemsWithNextCursor error = \(error)")
        }
    }
 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == detailViewSegue {
            guard let vc = segue.destinationViewController as? ItemStoreDetailViewController else { return }
            vc.selectedItem = selectedItem
            vc.server = server
        }
    }
}


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