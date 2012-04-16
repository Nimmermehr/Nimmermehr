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
	UIViewController *greenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsItemsVC"];
	self.topViewController = greenVC;
	
	UIViewController *redVC		= [self.storyboard instantiateViewControllerWithIdentifier:@"ServicesVC"];
	self.underLeftViewController = redVC;
	
	NSLog(@"%@.%@ topViewController       = %@",NSStringFromClass(self.class),NSStringFromSelector(_cmd),self.topViewController);
	NSLog(@"%@.%@ underLeftViewController = %@",NSStringFromClass(self.class),NSStringFromSelector(_cmd),self.underLeftViewController);
	
	[self setAnchorRightRevealAmount:50.];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
