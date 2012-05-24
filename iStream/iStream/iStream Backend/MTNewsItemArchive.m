//
//  MTNewsItemArchive.m
//  iStream
//
//  Created by Michael Hörl on 22.05.12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTNewsItemArchive.h"


@implementation MTNewsItemArchive
@synthesize  cachedItems;

#pragma mark Class methods

+ (NSSortDescriptor *)sortedByTimestampDescending {
	return [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
}

#pragma mark Public methods

- (void)addNewsItem:(MTNewsItem *)anItem {
	if (anItem) {
		//DLog(@"%@.%@ - called w/ item:\n%@", NSStringFromClass(self.class),NSStringFromSelector(_cmd),anItem);
		
		if (!self.cachedItems)
			self.cachedItems = [NSMutableArray array];
		
		if (![self.cachedItems containsObject:anItem]) {
			[self.cachedItems addObject:anItem];
			//DLog(@"%@.%@ -  ...added it!", NSStringFromClass(self.class),NSStringFromSelector(_cmd));
		}
	}
}

- (void)addNewsItems:(NSArray *)someItems {
	for (MTNewsItem *item in someItems)
		[self addNewsItem:item];
}

- (NSArray *)newsItemsFilteredByPredicate:(NSPredicate *)theFilter usingSort:(NSSortDescriptor *)theSortOrder {
	NSArray *items			= self.cachedItems;
	
	NSArray *filteredItems	= theFilter		? [items filteredArrayUsingPredicate:theFilter] : items;
	NSArray *sortedItems	= theSortOrder	? [filteredItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:theSortOrder]] : filteredItems;
											   
	return sortedItems;
}

@end
