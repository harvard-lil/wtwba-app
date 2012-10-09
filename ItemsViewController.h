//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Annie Jo Cain on 9/4/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"
#import "AddViewController.h"
#import "SettingsViewController.h"
#import "WildItemCell.h"
#import <RestKit/RestKit.h> 

@interface ItemsViewController : UITableViewController <RKRequestDelegate>
{
    RKClient *_client;
}

- (IBAction)addNewItem:(id)sender;
- (IBAction)editUserInfo:(id)sender;
- (void)logUsage;

@end
