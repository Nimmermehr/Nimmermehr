//
//  MTNewsItemArchive.h
//  iStream
//
//  Created by Michael Hörl on 22.05.12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSSingletonObject.h"

#import "MTNewsItem.h"


@interface MTNewsItemArchive : NSSingletonObject
@property (strong) NSMutableArray	*cachedItems;

+ (NSSortDescriptor *)sortedByTimestampDescending;

- (void)addNewsItem:(MTNewsItem *)anItem;
- (void)addNewsItems:(NSArray *)someItems;

- (NSArray *)newsItemsFilteredByPredicate:(NSPredicate *)theFilter usingSort:(NSSortDescriptor *)theSortOrder;
@end
