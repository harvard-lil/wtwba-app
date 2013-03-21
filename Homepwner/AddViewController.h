//
//  AddViewController.h
//  Wild Books Practice
//
//  Created by Annie Jo Cain on 9/7/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import <RestKit/RestKit.h> 

@class BNRItem;

@interface AddViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, ZBarReaderDelegate, RKRequestDelegate, RKObjectLoaderDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UILabel *dateTitleLabel;
    __weak IBOutlet UIButton *addButton;
    __weak IBOutlet UIButton *scanButton;
    
    UILabel *resultText;
    
    RKObjectManager *_objectManager;
}

- (IBAction)backgroundTapped:(id)sender;
- (IBAction)addTapped:(id)sender;
- (id)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UILabel *resultText;
- (IBAction) scanButtonTapped;

@end
