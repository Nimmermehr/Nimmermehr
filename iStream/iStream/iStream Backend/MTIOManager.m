//
//  MTIOManager.m
//  iStream
//
//  Created by Thomas Kober on 4/19/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "MTIOManager.h"
#import "MTServiceConnectorManager.h"

#define iStreamDataStorageResourceName  @"iStreamBase"
#define iStreamDataStorageResourceType  @"sqlite"

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
    // Add items with respect to the cache size
}

- (void)handleFacebookNewsItemsReceived:(NSNotification *)notification
{
    
}

- (void)handleGooglePlusNewsItemsReceived:(NSNotification *)notification
{
    
}

- (void)handleDidReceiveMemoryWarning:(NSNotification *)notification
{
    [self flushCache];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleDidReceiveMemoryWarning:) 
                                                 name:UIApplicationDidReceiveMemoryWarningNotification 
                                               object:[UIApplication sharedApplication]
     ];
    
    // Connect DB & fill cache
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:iStreamDataStorageResourceName ofType:iStreamDataStorageResourceType];
    
    if ([fileMgr fileExistsAtPath:dbPath]) {
        if (sqlite3_open([dbPath UTF8String], &_db) == SQLITE_OK) {
            
            // TODO: define a prep const
            const char *query = "SELECT * FROM TBL_NEWSITEM";
            sqlite3_stmt *stmt = nil;
            
            if (sqlite3_prepare(_db, query, -1, &stmt, NULL) == SQLITE_OK) {
                
                _connected = YES;
                
                while (sqlite3_step(stmt) == SQLITE_ROW) {
                    // TODO: do all the stuff here
                }
                
            } else {
                 NSLog(@"%@.%@ - EPIC FAIL: STMT COULD NOT BE PREPARED!", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            }
            
        } else {
             NSLog(@"%@.%@ - EPIC FAIL: DB COULD NOT BE OPENED!", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        }
    } else {
        NSLog(@"%@.%@ - EPIC FAIL: DB NOT AVAILABLE AT PATH=[%@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd), dbPath);
    }
    
    // TODO: set up & connect db & fill cache
}

@end
