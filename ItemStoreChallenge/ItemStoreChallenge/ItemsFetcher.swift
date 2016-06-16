//
//  ItemsFetcher.swift
//  ItemStoreChallenge
//
//  Created by Jack Lian on 16/06/2016.
//  Copyright © 2016 KitchenSpoon. All rights reserved.
//

import Foundation

typealias completionBlock = (success: Bool, allItems: [Item], error: NSError?) -> Void

class ItemsFetcher
{
    private var server: ItemStoreServer
    private var existingItems: [Item] = [Item]()
    private var nextCursor: String? = nil           //NextCursor is used for pagination and specifies the offset to fetch the next batch
    private var reachedEnd = false
    private var completion: completionBlock? = nil
    
    init(server: ItemStoreServer, existingItems: [Item] = [Item](), nextCursor: String? = nil, completion: completionBlock)
    {
        self.server = server
        self.existingItems = existingItems
        self.nextCursor = nextCursor
        self.completion = completion
    }
    
    
    func startFetching()
    {
        fetchAllItems(nextCursor, completion: completion)
    }
    
    
    private func fetchAllItems(nextCursor: String?, completion: completionBlock?)
    {
        if !reachedEnd {
            server.getItemsWithNextCursor(nextCursor, success: { (items:[Item], newNextCursor: String?) in
                if items.count == 0 {
                    self.reachedEnd = true
                }
                
                self.existingItems += items
                self.nextCursor = newNextCursor
                
                if !self.reachedEnd {
                    //Fetch the next batch of items if there are still more
                    self.fetchAllItems(newNextCursor, completion: completion)
                }
            }) { ( error: NSError ) in
                print("getItemsWithNextCursor error = \(error)")
                completion?(success: false, allItems: self.existingItems, error: error)
            }
        } else {
            completion?(success: true, allItems: existingItems, error: nil)
        }
    }
}