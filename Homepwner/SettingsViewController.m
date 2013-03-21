//
//  SettingsViewController.m
//  Wild Books Practice
//
//  Created by Annie Jo Cain on 10/2/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize dismissBlock;

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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"UserIDPrefKey"];
    [userIDField setText:myString];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[userIDField text]forKey:@"UserIDPrefKey"];
    // Clear first responder
    [[self view] endEditing:YES];

}

- (void)viewDidUnload {
    userIDField = nil;
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
    self = [super initWithNibName:@"SettingsViewController" bundle:nil];
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
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)])
    {   //yes->so do it!
        [[self presentingViewController] dismissViewControllerAnimated:YES
                                                            completion:dismissBlock];
    }
    else
    {   //nope->we seem to be running on something prior to iOS5, do it the old way!
        [self dismissModalViewControllerAnimated:YES];
    }
    
    //[[self presentingViewController] dismissViewControllerAnimated:YES
    //                                                    completion:dismissBlock];
}

- (void)cancel:(id)sender
{
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)])
    {   //yes->so do it!
        [[self presentingViewController] dismissViewControllerAnimated:YES
                                                            completion:dismissBlock];
    }
    else
    {   //nope->we seem to be running on something prior to iOS5, do it the old way!
        [self dismissModalViewControllerAnimated:YES];
    }
    //[[self presentingViewController] dismissViewControllerAnimated:YES
    //                                                    completion:dismissBlock];
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

- (IBAction)addTapped:(id)sender {
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)])
    {   //yes->so do it!
        [[self presentingViewController] dismissViewControllerAnimated:YES
                                                            completion:dismissBlock];
    }
    else
    {   //nope->we seem to be running on something prior to iOS5, do it the old way!
        [self dismissModalViewControllerAnimated:YES];
    }
    
    //[[self presentingViewController] dismissViewControllerAnimated:YES
    //                                                    completion:dismissBlock];
    //[self dismissModalViewControllerAnimated:YES];
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
