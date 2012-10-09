//
//  WildUsageItem.h
//  Wild Books Practice
//
//  Created by Annie Jo Cain on 10/5/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WildUsageItem : NSObject <NSCoding>

@property (nonatomic, copy) NSString *barcode;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSDate *dateCreated;

@end
