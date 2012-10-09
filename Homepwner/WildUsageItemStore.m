//
//  WildUsageItemStore.m
//  Wild Books Practice
//
//  Created by Annie Jo Cain on 10/5/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import "WildUsageItemStore.h"
#import "WildUsageItem.h"

@implementation WildUsageItemStore


- (id)init
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        // If the array hadn't been saved previously, create a new empty one
        if (!allItems)
            allItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems
{
    return allItems;
}

- (WildUsageItem *)createItem
{
    WildUsageItem *p = [[WildUsageItem alloc] init];
    [allItems addObject:p];
    return p;
}

- (void)removeItem:(WildUsageItem *)p
{
    [allItems removeObjectIdenticalTo:p];
}

+ (WildUsageItemStore *)sharedStore
{
    static WildUsageItemStore *sharedStore = nil;
    if(!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    return sharedStore;
}

- (BOOL)saveChanges
{
    // returns success or failure
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:allItems
                                       toFile:path];
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"usage.archive"];
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}
@end

