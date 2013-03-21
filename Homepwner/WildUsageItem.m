//
//  WildUsageItem.m
//  Wild Books Practice
//
//  Created by Annie Jo Cain on 10/5/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import "WildUsageItem.h"

@implementation WildUsageItem
@synthesize barcode, location, user, dateCreated;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:barcode forKey:@"barcode"];
    [aCoder encodeObject:location forKey:@"location"];
    [aCoder encodeObject:user forKey:@"user"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setBarcode:[aDecoder decodeObjectForKey:@"barcode"]];
        [self setLocation:[aDecoder decodeObjectForKey:@"location"]];
        [self setUser:[aDecoder decodeObjectForKey:@"user"]];
        [self setDateCreated :[aDecoder decodeObjectForKey:@"dateCreated"]];
    }
    return self;
}

@end
