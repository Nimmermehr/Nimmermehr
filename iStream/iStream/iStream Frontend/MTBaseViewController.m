//
//  MTBaseViewController.m
//  iStream
//
//  Created by Michael Hörl on 16.04.12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTBaseViewController.h"

@interface MTBaseViewController ()

@end

@implementation MTBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Setup basic VC structure
	UIViewController *newsItemsVC	= [self.storyboard instantiateViewControllerWithIdentifier:@"NewsItemsVC"];
	self.topViewController = newsItemsVC;
	
	UIViewController *servicesVC	= [self.storyboard instantiateViewControllerWithIdentifier:@"ServicesVC"];
	self.underLeftViewController = servicesVC;
	
	[self setAnchorRightRevealAmount:50.];
	
	// !!!: Test [show all (most) notifications]!!!
	[[NSNotificationCenter defaultCenter] addObserverForName:nil object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification *notif){
		if (![notif.name hasPrefix:@"UIViewAnimation"])	// ..too much information
			if (NO) DLog(@"%@.%@ - received '%@'", NSStringFromClass(self.class),NSStringFromSelector(_cmd),notif.name);
	}];
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
