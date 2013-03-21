//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Annie Jo Cain on 9/4/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
}

+ (BNRItemStore *)sharedStore;
- (void)removeItem:(BNRItem *)p;
- (NSArray *)allItems;
- (BNRItem *)createItem;
- (void)moveItemAtIndex:(int)from
                toIndex:(int)to;
- (void)moveItemToTop:(BNRItem *)p;
- (NSString *)itemArchivePath;
- (BOOL)saveChanges;

@end
