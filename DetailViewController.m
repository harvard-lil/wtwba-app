//
//  DetailViewController.m
//  Homepwner
//
//  Created by Annie Jo Cain on 9/4/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import <RestKit/RestKit.h>
#import "WildUsageItem.h"
#import "WildUsageItemStore.h"

NSString* buttonString = @"";
NSString *userID = @"";
NSDate *now;

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize item, dismissBlock;

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*UIColor *clr = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    } else {
        clr = [UIColor groupTableViewBackgroundColor];
    }
    [[self view] setBackgroundColor:clr];*/
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    //[nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    // Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    // Use filtered NSDate object to set dateLabel contents
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
}

- (void)setItem:(BNRItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item itemName]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    nameField = nil;
    nameField = nil;
    serialNumberField = nil;
    valueField = nil;
    dateLabel = nil;
    resultField = nil;
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    return nil;
}

- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self
                                           action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:RKReachabilityDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:dismissBlock];
}

- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the BNRItem from the store
    [[BNRItemStore sharedStore] removeItem:item];
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:dismissBlock];
}

- (IBAction)logUsage:(id)sender {
    NSURL *posturl = [NSURL URLWithString:@"http://hlsl10.law.harvard.edu/dev/annie/wtwba/receive.php"];
    _client = [[RKClient alloc] initWithBaseURL:posturl];
	
	UIButton *resultButton = (UIButton *)sender;
    buttonString = resultButton.currentTitle;
    
    now = [NSDate date];
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString* dateString = [dateFormatter stringFromDate:now];
    
    NSString* barcodeString = [item serialNumber];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    userID = [prefs stringForKey:@"UserIDPrefKey"];
    
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:barcodeString forKey:@"barcode"];
	[params setObject:dateString forKey:@"date"];
    [params setObject:buttonString forKey:@"location"];
    [params setObject:userID forKey:@"user"];
	[_client post:@"" params:params delegate:self];
    [resultField setText:@"Sending..."];
}

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
	NSLog(@"Retrieved response: %@", [response bodyAsString]);
    resultField.text = @"Thank you!";
    [self performSelector:@selector(dismissController) withObject:nil afterDelay:0.4];
}

- (void)request:(RKRequest*)request didFailLoadWithError:(NSError *)error {
    WildUsageItem *usageItem = [[WildUsageItemStore sharedStore] createItem];
    [usageItem setBarcode:[item serialNumber]];
    [usageItem setLocation:buttonString];
    [usageItem setUser:userID];
    [usageItem setDateCreated:now];
	resultField.text = @"No data sent, oh noes!";
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    RKReachabilityObserver *observer = (RKReachabilityObserver *)[notification object];
    if ([observer isNetworkReachable]) {
        NSLog(@"We're online!");
    } else {
        NSLog(@"We've gone offline!");
    }
}

- (void) dismissController {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)backgroundTapped:(id)sender {
     [[self view] endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (io == UIInterfaceOrientationPortrait);
    }
}
@end
