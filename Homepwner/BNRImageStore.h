//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Annie Jo Cain on 9/4/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}
+ (BNRImageStore *)sharedStore;
- (void)setImage:(UIImage *)i forKey:(NSString *)s;
- (UIImage *)imageForKey:(NSString *)s;
- (void)deleteImageForKey:(NSString *)s;
- (NSString *)imagePathForKey:(NSString *)key;

@end
