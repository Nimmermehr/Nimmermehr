//
//  MTNewsItemsViewController.m
//  iStream
//
//  Created by Michael Hörl on 16.04.12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTNewsItemsViewController.h"

#import "ECSlidingViewController.h"


@interface MTNewsItemsViewController ()

@end

@implementation MTNewsItemsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.layer.shadowOpacity	= .75;
	self.view.layer.shadowRadius	= 5.;
	self.view.layer.shadowColor		= [UIColor blackColor].CGColor;
	self.view.layer.shadowPath		= [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;	// <-- massive performance increase!
	
	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
