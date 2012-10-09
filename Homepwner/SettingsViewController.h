//
//  SettingsViewController.h
//  Wild Books Practice
//
//  Created by Annie Jo Cain on 10/2/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *userIDField;
}

- (id)initForNewItem:(BOOL)isNew;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)addTapped:(id)sender;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
