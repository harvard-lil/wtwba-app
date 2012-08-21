//
//  ReaderSampleViewController.h
//  ReaderSample
//
//  Created by spadix on 4/14/11.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h> 

@interface ReaderSampleViewController
    : UIViewController
    // ADD: delegate protocol
    < ZBarReaderDelegate, RKRequestDelegate>
{
    UIImageView *resultImage;
    UITextView *resultText;
	UITextView *statusText;
}
@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UITextView *resultText;
@property (nonatomic, retain) IBOutlet UITextView *statusText;
- (IBAction) scanButtonTapped;
@end
