//
//  WildAppDelegate.m
//  Wild Books
//
//  Created by Annie Jo Cain on 9/4/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import "WildAppDelegate.h"
#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import <RestKit/RestKit.h>
#import "WildUsageItem.h"
#import "WildUsageItemStore.h"

WildUsageItem *w;

@implementation WildAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    ItemsViewController *itemsViewController = [[ItemsViewController alloc] init];
    // Create an instance of a UINavigationController
    // its stack contains only itemsViewController
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:itemsViewController];
    [[self window] setRootViewController:itemsViewController];
    // Place navigation controller's view in the window hierarchy
    [[self window] setRootViewController:navController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL success = [[BNRItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the BNRItems");
    } else {
        NSLog(@"Could not save any of the BNRItems");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self logUsage];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)logUsage {
    NSLog(@"Logging any stray usage");
    NSURL *posturl = [NSURL URLWithString:@"http://hlsl10.law.harvard.edu/dev/annie/wtwba/receive.php"];
    _client = [[RKClient alloc] initWithBaseURL:posturl];
	
    int usageItems = [[[WildUsageItemStore sharedStore] allItems] count];
    if(usageItems > 0)
    {
        for(int n = 0; n < usageItems; n = n + 1)
        {
            w = [[[WildUsageItemStore sharedStore] allItems]
                 objectAtIndex:n];
            
            NSDate* dateCreated = [w dateCreated];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateString = [dateFormatter stringFromDate:dateCreated];
            
            NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
            [params setObject:[w barcode] forKey:@"barcode"];
            [params setObject:dateString forKey:@"date"];
            [params setObject:[w location] forKey:@"location"];
            [params setObject:[w user] forKey:@"user"];
            NSLog(@"%@", params);
            [_client post:@"" params:params delegate:self];
        }
    }
}

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
	WildUsageItemStore *ws = [WildUsageItemStore sharedStore];
    [ws removeItem:w];
    NSLog(@"Posted and removed");
}

- (void)request:(RKRequest*)request didFailLoadWithError:(NSError *)error {
	NSLog(@"No data sent, oh noes!");
}

@end
