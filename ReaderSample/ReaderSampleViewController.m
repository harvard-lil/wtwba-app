//
//  ReaderSampleViewController.m
//  ReaderSample
//
//  Created by spadix on 4/14/11.
//

#import "ReaderSampleViewController.h"

@implementation ReaderSampleViewController

@synthesize resultImage, resultText, statusText;

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
    /*NSString *var1 =@"barcode=";
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
	
    [[NSURLConnection alloc] initWithRequest:request delegate:self];*/
	
	//NSDictionary* params = [NSDictionary dictionaryWithObject:@"kitten" forKey:@"barcode"];
	NSDate *now = [NSDate date];
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString* dateString = [dateFormatter stringFromDate:now];
	[dateFormatter release];
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:symbol.data forKey:@"barcode"];
	[params setObject:dateString forKey:@"date"];
	[[RKClient sharedClient] post:@"" params:params delegate:self];  

    // EXAMPLE: do something useful with the barcode image
    resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];

    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}

- (void)request:(RKRequest*)request didLoadResponse: 
(RKResponse*)response { 
	NSLog(@"Retrieved response: %@", [response bodyAsString]); 
	statusText.text = [response bodyAsString];
}

- (void)request:(RKRequest*)request didFailLoadWithError:(NSError *)error {
	statusText.text = @"No data sent, oh noes!";
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Sent");
	statusText.text = @"Sent woo";
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    statusText.text = @"No data sent. ERROR.";
	NSLog(@"No data sent. ERROR.");
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return(YES);
}

- (void) dealloc {
    self.resultImage = nil;
    self.resultText = nil;
	self.statusText = nil;
    [super dealloc];
}

@end
