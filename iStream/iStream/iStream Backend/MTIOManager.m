//
//  MTIOManager.m
//  iStream
//
//  Created by Thomas Kober on 4/19/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTIOManager.h"
#import "MTServiceConnectorManager.h"

@interface MTIOManager (Private)
- (void)initSharedInstance;
@end

@implementation MTIOManager

@synthesize connected   = _connected;
@synthesize cached      = _cached; // NSUserDefaults
@synthesize cacheSize   = _cacheSize; // NSUserDefaults

__strong static MTIOManager *_sharedInstance = nil;

+ (MTIOManager *)sharedIOManager
{
    if (_sharedInstance == nil) {
        _sharedInstance = [[super allocWithZone:NULL] init];
        
        [_sharedInstance initSharedInstance];
    }
    
    return _sharedInstance;
}

- (NSArray *)getNewsItems
{
    NSArray *allItems = [NSArray array];
    
    if (_cached) {
        for (NSArray *item in [_cache allValues]) {
            allItems = [allItems arrayByAddingObjectsFromArray:item];
        }
    } else {
        // TODO: Load from DB
    }
    
    return allItems;
}

- (NSArray *)getNewsItemsForServiceType:(NSString *)serviceType
{
    NSArray *items = [NSArray array];
    
    if (_cached) {
        items = [_cache objectForKey:serviceType];
    } else {
        // TODO: Load From DB
    }
    
    return items;
}

- (NSArray *)getNewsItemsUpToIndex:(NSUInteger)index
{
    return nil; // TODO:
}

- (NSArray *)getNewsItemsForServiceType:(NSString *)serviceType upToIndex:(NSUInteger)index
{
    return nil; // TODO:
}

- (void)flushCache
{
    [_cache removeAllObjects];
}

- (void)reloadCache
{
    
}

// TODO: needs some reworking
- (void)setCacheSize:(NSUInteger)cacheSize
{
    // Kick out some items (only if actual cache is really larger) if cache is made smaller
    if (cacheSize < [_cache count]) {
        // TODO: shrink cache in that case (per item)
    }
    
    _cacheSize = cacheSize;
}

#pragma Notification Handler

- (void)handleTwitterNewsItemsReceived:(NSNotification *)notification
{
    
}

- (void)handleFacebookNewsItemsReceived:(NSNotification *)notification
{
    
}

- (void)handleGooglePlusNewsItemsReceived:(NSNotification *)notification
{
    
}

@end

@implementation MTIOManager (Private)

- (void)initSharedInstance
{
    _cache = [[NSMutableDictionary alloc] init];
 
    // Register for all Notifications
    MTServiceConnectorManager *mgr = [MTServiceConnectorManager sharedServiceConnectorManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTwitterNewsItemsReceived:) 
                                                 name:MTTwitterNewsItemsReceived 
                                               object:mgr
     ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleFacebookNewsItemsReceived:) 
                                                 name:MTFacebookNewsItemsReceived 
                                               object:mgr
     ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleGooglePlusNewsItemsReceived:) 
                                                 name:MTGooglePlusNewsItemsReceived 
                                               object:mgr
     ];
    
    // TODO: set up & connect db & fill cache
}

@end
