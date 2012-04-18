//
//  MTMasterViewController.m
//  iStream
//
//  Created by Thomas Kober on 3/28/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTMasterViewController.h"
#import "MTServiceConnectorManager.h"

@implementation MTMasterViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSLog(@"SERVICE CONN MGR: %@", [MTServiceConnectorManager sharedServiceConnectorManager]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGooglePlusUserDialogNeedsDisplay:) name:MTGooglePlusOAuth2DialogNeedsDisplay object:[MTServiceConnectorManager sharedServiceConnectorManager]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGooglePlusUserDialogNeedsDismissal:) name:MTGooglePlusOAuth2DialogNeedsDismissal object:[MTServiceConnectorManager sharedServiceConnectorManager]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)handleGooglePlusUserDialogNeedsDisplay:(NSNotification *)notification
{
    UIViewController *theDialog = (UIViewController *)[[notification userInfo] objectForKey:MTServiceOAuth2UserDialog];
    [self presentViewController:theDialog animated:YES completion:NULL];
}

- (void)handleGooglePlusUserDialogNeedsDismissal:(NSNotification *)notification
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[MTServiceConnectorManager sharedServiceConnectorManager] authenticateServices];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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

@end
