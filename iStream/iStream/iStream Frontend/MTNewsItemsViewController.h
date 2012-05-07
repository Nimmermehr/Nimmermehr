//
//  MTNewsItemsViewController.h
//  iStream
//
//  Created by Michael Hörl on 16.04.12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"


@interface MTNewsItemsViewController : PullRefreshTableViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong) NSMutableArray *newsItems;

@end
