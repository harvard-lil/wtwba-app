//
//  WildUsageItemStore.h
//  Wild Books Practice
//
//  Created by Annie Jo Cain on 10/5/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WildUsageItem;

@interface WildUsageItemStore : NSObject
{
        NSMutableArray *allItems;
}

+ (WildUsageItemStore *)sharedStore;
- (void)removeItem:(WildUsageItem *)p;
- (NSArray *)allItems;
- (WildUsageItem *)createItem;
- (NSString *)itemArchivePath;
- (BOOL)saveChanges;

@end
