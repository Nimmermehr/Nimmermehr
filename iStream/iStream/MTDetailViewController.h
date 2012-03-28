//
//  MTDetailViewController.h
//  iStream
//
//  Created by Thomas Kober on 3/28/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
