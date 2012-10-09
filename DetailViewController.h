//
//  DetailViewController.h
//  Homepwner
//
//  Created by Annie Jo Cain on 9/4/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h> 

@class BNRItem;

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, RKRequestDelegate>
{
    __weak IBOutlet UILabel *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *resultField;
    
    RKClient *_client;
    RKReachabilityObserver *_observer;
}

- (id)initForNewItem:(BOOL)isNew;

- (IBAction)logUsage:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, retain) RKReachabilityObserver *observer;

@end
