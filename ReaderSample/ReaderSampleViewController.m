//
//  ReaderSampleViewController.m
//  ReaderSample
//
//  Created by spadix on 4/14/11.
//

#import "ReaderSampleViewController.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@implementation ReaderSampleViewController

@synthesize resultImage, resultText;

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
    [reader release];
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
    resultText.text = symbol.data;
	
	//Create String
    NSString *var1 =@"barcode=";
	NSString *barcode = [var1 stringByAppendingString:resultText.text];
	
    NSMutableURLRequest *request = 
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:@"http://hlsl10.law.harvard.edu/dev/annie/wtwba/receive.php"]];
	
    [request setHTTPMethod:@"POST"];
	
    NSString *postString = barcode;
	
    [request setValue:[NSString 
                       stringWithFormat:@"%d", [postString length]] 
   forHTTPHeaderField:@"Content-length"];
	
    [request setHTTPBody:[postString 
                          dataUsingEncoding:NSUTF8StringEncoding]];
	
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

    // EXAMPLE: do something useful with the barcode image
    resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];

    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return(YES);
}

- (void) dealloc {
    self.resultImage = nil;
    self.resultText = nil;
    [super dealloc];
}

@end
