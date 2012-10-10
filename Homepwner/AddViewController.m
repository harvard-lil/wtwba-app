//
//  AddViewController.m
//  Wild Books Practice
//
//  Created by Annie Jo Cain on 9/7/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import "AddViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import <RestKit/RestKit.h>
#import "WildNewItem.h"

NSString *barcode;

@interface AddViewController ()

@end

@implementation AddViewController
@synthesize item, dismissBlock, resultText;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setItem:(BNRItem *)i
{
    item = i;
    [[self navigationItem] setTitle:@"Add item"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Clear first responder
    [[self view] endEditing:YES];
    // "Save" changes to item
    [item setItemName:[nameField text]];
    [item setSerialNumber:barcode];
    [item setValueInDollars:[[valueField text] intValue]];
    NSDate *dueDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    dueDate = [formatter dateFromString:[dateLabel text]];
    [item setDateCreated:dueDate];
}

- (void)viewDidUnload {
    nameField = nil;
    valueField = nil;
    dateLabel = nil;
    imageView = nil;
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
    self = [super initWithNibName:@"AddViewController" bundle:nil];
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

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

- (IBAction)addTapped:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:dismissBlock];
}

- (IBAction) scanButtonTapped
{
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    resultText.text = @"Retrieving info...";
    barcode = symbol.data;
    
    /*NSURL *posturl = [NSURL URLWithString:@"http://hlsl10.law.harvard.edu/dev/annie/wtwba/add.php"];
    _client = [[RKClient alloc] initWithBaseURL:posturl];
	
	NSDate *now = [NSDate date];
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString* dateString = [dateFormatter stringFromDate:now];

	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:symbol.data forKey:@"barcode"];
	[params setObject:dateString forKey:@"date"];
	[_client post:@"" params:params delegate:self];*/
    
    RKURL *baseURL = [RKURL URLWithBaseURLString:@"http://librarylab.law.harvard.edu/dev/annie/wtwba/add.php"];
    _objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    _objectManager.client.baseURL = baseURL;
    
    RKObjectMapping *libraryBookMapping = [RKObjectMapping mappingForClass:[WildNewItem class]];
    [libraryBookMapping mapKeyPathsToAttributes:@"title", @"title", nil];
    [libraryBookMapping mapKeyPathsToAttributes:@"due", @"due", nil];
    [libraryBookMapping mapKeyPathsToAttributes:@"isbn", @"isbn", nil];
    [_objectManager.mappingProvider setMapping:libraryBookMapping forKeyPath:@""];
    
    //[self sendRequest];
    NSString *userID = symbol.data;
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"barcode", nil];
    //RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKURL *URL = [RKURL URLWithBaseURL:[_objectManager baseURL] resourcePath:@"" queryParameters:queryParams];
    [_objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@", [URL resourcePath], [URL query]] delegate:self];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    WildNewItem *myItem = (WildNewItem*)[objects objectAtIndex:0];
    nameField.text = myItem.title;
    dateLabel.text = @"Not checked out";
    resultText.text = @"Got it!";
    NSLog(@"objects %@", myItem.title);
    NSDate *dueDate = nil;
    
    if([myItem.isbn length] > 0){
        NSMutableString *imageURLString = [[NSMutableString alloc] initWithString:@"http://covers.openlibrary.org/b/isbn/"];
        [imageURLString appendString:myItem.isbn];
        [imageURLString appendString:@"-M.jpg"];

        NSURL * imageURL = [NSURL URLWithString:imageURLString];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        NSLog(@"MyImage size in bytes:%i",[UIImagePNGRepresentation(image) length]);
        
        imageView.image = image;
        // Create a CFUUID object - it knows how to create unique identifier strings
        CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
        // Create a string from unique identifier
        CFStringRef newUniqueIDString =
        CFUUIDCreateString (kCFAllocatorDefault, newUniqueID);
        // Use that unique ID to set our item's imageKey
        NSString *key = (__bridge NSString *)newUniqueIDString;
        [item setImageKey:key];
        // Store image in the BNRImageStore with this key
        [[BNRImageStore sharedStore] setImage:image
                                       forKey:[item imageKey]];
        CFRelease(newUniqueIDString);
        CFRelease(newUniqueID);
    }
    
    if([myItem.due length] > 0){
        dateLabel.text = myItem.due;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        dueDate = [formatter dateFromString:myItem.due];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        // Use filtered NSDate object to set dateLabel contents
        //resultText.text = [dateFormatter stringFromDate:dueDate];
    }
    
}

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
	NSLog(@"Retrieved response: %@", [response bodyAsString]);
	//nameField.text = [response bodyAsString];
    //resultText.text = @"Got it!";
}


- (void)request:(RKRequest*)request didFailLoadWithError:(NSError *)error {
	resultText.text = @"No data sent, oh noes!";
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
