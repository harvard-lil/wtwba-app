//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Annie Jo Cain on 9/4/12.
//  Copyright (c) 2012 Annie Jo Cain. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "WildUsageItemStore.h"
#import "WildUsageItem.h"
#import <RestKit/RestKit.h>

WildUsageItem *w;

@implementation ItemsViewController

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Wild Books"];
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        // Set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO];
    [[self tableView] reloadData];
    [self logUsage];
}

- (void)logUsage {
    NSLog(@"Logging any stray usage");
    NSURL *posturl = [NSURL URLWithString:@"http://hlsl10.law.harvard.edu/dev/annie/wtwba/receive.php"];
    _client = [[RKClient alloc] initWithBaseURL:posturl];
	
    int usageItems = [[[WildUsageItemStore sharedStore] allItems] count];
    if(usageItems > 0)
    {
        for(int n = 0; n < usageItems; n = n + 1)
        {
            w = [[[WildUsageItemStore sharedStore] allItems]
                                objectAtIndex:n];

            NSDate* dateCreated = [w dateCreated];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* dateString = [dateFormatter stringFromDate:dateCreated];
    
            NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
            [params setObject:[w barcode] forKey:@"barcode"];
            [params setObject:dateString forKey:@"date"];
            [params setObject:[w location] forKey:@"location"];
            [params setObject:[w user] forKey:@"user"];
            NSLog(@"%@", params);
            [_client post:@"" params:params delegate:self];
        }
    }
}

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
	WildUsageItemStore *ws = [WildUsageItemStore sharedStore];
    [ws removeItem:w];
    NSLog(@"Posted and removed");
}

- (void)request:(RKRequest*)request didFailLoadWithError:(NSError *)error {
	NSLog(@"No data sent, oh noes!");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"WildItemCell" bundle:nil];
    // Register this NIB which contains the cell
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"WildItemCell"];
    [self.navigationController setToolbarHidden:NO];
    UIBarButtonItem *buttonItem = [[ UIBarButtonItem alloc ] initWithTitle: @"User Info"
                                                                     style: UIBarButtonItemStyleBordered
                                                                    target: self
                                                                    action: @selector(editUserInfo:)];
    self.toolbarItems = [ NSArray arrayWithObjects: buttonItem, nil ];
    
    UIColor *clr = nil;
    clr = [UIColor colorWithRed:0.705 green:0.914 blue:1 alpha:1];

    [[self view] setBackgroundColor:clr];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRItem *p = [[[BNRItemStore sharedStore] allItems]
                  objectAtIndex:[indexPath row]];
    // Get the new or recycled cell
    WildItemCell *cell = [tableView
                               dequeueReusableCellWithIdentifier:@"WildItemCell"];
    // Configure the cell with the BNRItem
    CGSize labelSize = CGSizeMake(250, 50);
    CGSize theStringSize = [[p itemName] sizeWithFont:cell.titleLabel.font constrainedToSize:labelSize lineBreakMode:cell.titleLabel.lineBreakMode];
    cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, theStringSize.width, theStringSize.height);
    cell.titleLabel.text = [p itemName];
    if([p dateCreated]) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    // Use filtered NSDate object to set dateLabel contents
    //resultText.text = [dateFormatter stringFromDate:dueDate];
    [[cell dueDateLabel] setText:[dateFormatter stringFromDate:[p dateCreated]]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [p dateCreated];
    
    // This performs the difference calculation
    unsigned flags = NSDayCalendarUnit;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
    NSString *daysLeft = [NSString stringWithFormat:@"%d", [difference day]];
    NSMutableString *dueDateString = [[NSMutableString alloc] initWithString:@"Due in "];
    [dueDateString appendString:daysLeft];
    [dueDateString appendString:@" days"];
    cell.daysUntilDueLabel.text = dueDateString;
    if([difference day] <= 5) {
        cell.daysUntilDueLabel.textColor = [UIColor redColor];
    }
    }
    else {
        cell.dueDateLabel.text = @"";
        cell.daysUntilDueLabel.text = @"Not checked out";
    }
    //NSLog(@"%@", dueDateString);
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat result = 90.0f;
    return result;
}

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController =
    [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = [items objectAtIndex:[indexPath row]];
    // Give detail view controller a pointer to the item object in row
    [detailViewController setItem:selectedItem];
    // Push it onto the top of the navigation controller's stack
    [[self navigationController] pushViewController:detailViewController
                                           animated:YES];
}

- (IBAction)addNewItem:(id)sender
{
    // Create a new BNRItem and add it to the store
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    AddViewController *addViewController =
    [[AddViewController alloc] initForNewItem:YES];
    [addViewController setItem:newItem];
    [addViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:addViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)editUserInfo:(id)sender
{
    //TODO add new view controller for editing user info
    //USE NSUserDefaults to save user ID
    SettingsViewController *settingsViewController =
    [[SettingsViewController alloc] initForNewItem:YES];
    [settingsViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:settingsViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row]
                                        toIndex:[destinationIndexPath row]];
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
