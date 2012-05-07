//
//  MTNewsItemsViewController.m
//  iStream
//
//  Created by Michael Hörl on 16.04.12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTNewsItemsViewController.h"
#import "ECSlidingViewController.h"

#import "MTServiceConnectorManager.h"
#import "MTNewsItem.h"


NSString * const UITableViewDidScrollToTopNotification	= @"UITableViewDidScrollToTopNotification";


@interface MTNewsItemsViewController ()

@end


@implementation MTNewsItemsViewController
@synthesize newsItems;

#pragma mark Initialization / Deallocation

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Appearances
	self.view.layer.shadowOpacity	= .75;
	self.view.layer.shadowRadius	= 5.;
	self.view.layer.shadowColor		= [UIColor blackColor].CGColor;
	self.view.layer.shadowPath		= [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;	// <-- massive performance increase!
	
	// Interactions
	UIPanGestureRecognizer *slideGesture = self.slidingViewController.panGesture;
	[slideGesture setMinimumNumberOfTouches:2];
	[self.view addGestureRecognizer:slideGesture];	// <-- shit, this interferes with table scrolling

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTableViewDidScrollToTop:) name:UITableViewDidScrollToTopNotification object:self];
	
	DLog(@"%@.%@ - observing Twitter", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	MTServiceConnectorManager *mgr = [MTServiceConnectorManager sharedServiceConnectorManager];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTwitterDidStartLoading:) name:MTTwitterDidStartLoading object:mgr];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTwitterContentReceived:) name:MTTwitterNewsItemsReceived object:mgr];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTwitterContentFailed:) name:MTTwitterNewsItemsRequestFailed object:mgr];
}

- (void)viewDidUnload {
	MTServiceConnectorManager *mgr = [MTServiceConnectorManager sharedServiceConnectorManager];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MTTwitterNewsItemsRequestFailed object:mgr];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MTTwitterNewsItemsReceived object:mgr];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITableViewDidScrollToTopNotification object:self];
	
	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Notification handlers

- (void)handleTableViewDidScrollToTop:(NSNotification *)notification {
	DLog(@"%@.%@ - dude, you're like totally up to date now!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	// TODO: clear some kind of new-items-indicator here!
}

- (void)handleTwitterDidStartLoading:(NSNotification *)notification {
	DLog(@"%@.%@ - I starteded it!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self stopLoading];
}

- (void)handleTwitterContentReceived:(NSNotification *)notification {
	NSArray *newItems = [[notification userInfo] objectForKey:MTServiceContentKey];
	DLog(@"%@.%@ - received %u messages from Twitter!", NSStringFromClass(self.class),NSStringFromSelector(_cmd),[newItems count]);
	
	if (!self.newsItems)
		self.newsItems = [NSMutableArray array];
	
	if (newItems.count > 0)	// TODO: that's nice and all, but we'll have to filter out dupes soon!
		[self.newsItems insertObjects:newItems atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newItems.count)]];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[self.tableView reloadData];
		if (self.newsItems.count > newItems.count)
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newItems.count inSection:0]
								  atScrollPosition:UITableViewScrollPositionTop
										  animated:NO ];
		// TODO: set some kind of new-items-indicator here!
	});
}

- (void)handleTwitterContentFailed:(NSNotification *)notification {
	NSDictionary *urlFailHeader = [[[notification userInfo] objectForKey:MTServiceContentRequestFailedResponseKey] allHeaderFields];
	DLog(@"%@.%@ - received FAIL from Twitter: %@", NSStringFromClass(self.class),NSStringFromSelector(_cmd),[urlFailHeader objectForKey:@"Status"]);
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Fail!"
														message:[NSString stringWithFormat:@"Status: %@",[urlFailHeader objectForKey:@"Status"]]
													   delegate:nil 
											  cancelButtonTitle:@"Dammit"
											  otherButtonTitles:nil ];
		[alert show];
	});
}

#pragma mark PullToRefresh methods

- (void)refresh {
	[[MTServiceConnectorManager sharedServiceConnectorManager] requestTwitterPublicTimeline];
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // !!!: Test!!!
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *sectionTitle = nil;
	
	switch (section) {
		case 0:
			sectionTitle = @"Twitter";
			break;
		default:
			break;
	}
	
	return sectionTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0)
		[[NSNotificationCenter defaultCenter] postNotificationName:UITableViewDidScrollToTopNotification object:self];
	
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
	MTNewsItem *item = (MTNewsItem *)[self.newsItems objectAtIndex:indexPath.row];
	
	cell.textLabel.text			= item.author;
	cell.detailTextLabel.text	= item.content;
	cell.imageView.image		= item.authorProfileImage;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
