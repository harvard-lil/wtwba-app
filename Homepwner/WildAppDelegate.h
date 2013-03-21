//
//  WildAppDelegate.h
//  Wild Books
//
//  Created by Annie Jo Cain on 9/4/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h> 

@interface WildAppDelegate : UIResponder <UIApplicationDelegate, RKRequestDelegate>
{
    RKClient *_client;
}

@property (strong, nonatomic) UIWindow *window;

@end
