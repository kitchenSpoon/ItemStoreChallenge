/***********************************************************************
 * Copyright (C) 2016 Covata Limited
 *
 * Information contained within this file cannot be copied, distributed
 * and/or practised without the written consent of Covata Limited.
 ***********************************************************************/

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, strong) NSString *itemId;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *owner;

@end
