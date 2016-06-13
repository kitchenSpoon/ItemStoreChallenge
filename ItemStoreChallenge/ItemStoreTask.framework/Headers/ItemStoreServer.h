/***********************************************************************
 * Copyright (C) 2016 Covata Limited
 *
 * Information contained within this file cannot be copied, distributed
 * and/or practised without the written consent of Covata Limited.
 ***********************************************************************/

#import <UIKit/UIKit.h>

@class Item;


#pragma mark - Types

typedef void (^_Nonnull ItemStoreSuccess)();

typedef void (^_Nonnull ItemListSuccess)(NSArray<Item*> * _Nonnull items, NSString * _Nullable nextCursor);

typedef void (^_Nonnull ItemContentSuccess)(UIImage * _Nonnull image);

typedef void (^_Nonnull ItemCreateSuccess)(Item * _Nonnull item);

typedef void (^_Nonnull ItemStoreFailure)(NSError * _Nonnull error);


#pragma mark - Errors

/**
 * The domain used for errors returned by `ItemStoreServer` requests.
 **/
extern NSString * const _Nonnull ItemStoreErrorDomain;

/**
 * The error codes used for `ItemStoreErrorDomain` errors.
 **/
typedef NS_ENUM(NSUInteger, ItemStoreErrorCode)
{
    // The request timed out, probably network connectivity
    Timeout = 1,
    
    // Unknown item supplied
    UnknownItem = 2
};


#pragma mark - Item Store Server

@interface ItemStoreServer : NSObject

/**
 * Retrieve a paged list of items from the server. Use nil as the nextCursor for the first page.
 **/
- (void) getItemsWithNextCursor:(NSString * _Nullable)nextCursor success:(ItemListSuccess)success failure:(ItemStoreFailure)failure;

- (void) getContentForItem:(Item * _Nonnull)item success:(ItemContentSuccess)success failure:(ItemStoreFailure)failure;

- (void) deleteItem:(Item * _Nonnull)itemId success:(ItemStoreSuccess)success failure:(ItemStoreFailure)failure;

- (void) createItemWithName:(NSString * _Nonnull)name image:(UIImage * _Nonnull)image success:(ItemCreateSuccess)success failure:(ItemStoreFailure)failure;

- (void) replaceContentForItem:(Item * _Nonnull)item withImage:(UIImage * _Nonnull)image success:(ItemStoreSuccess)success failure:(ItemStoreFailure)failure;

@end
