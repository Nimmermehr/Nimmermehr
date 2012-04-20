//
//  MTIOManager.h
//  iStream
//
//  Created by Thomas Kober on 4/19/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

// Another singleton???

@interface MTIOManager : NSObject {
@private
    BOOL                _connected;
    BOOL                _cached;
    NSUInteger          _chacheSize;
    NSMutableDictionary *_cache;
    sqlite3             *_db;
}

@property (nonatomic)   BOOL        connected;
@property (nonatomic)   BOOL        cached;
@property (nonatomic)   NSUInteger  cacheSize;

// Outcome depends whether or not the cache is on
- (NSArray *)getNewsItems;
- (NSArray *)getNewsItemsForServiceType:(NSString *)serviceType;
- (NSArray *)getNewsItemsUpToIndex:(NSUInteger)index;
- (NSArray *)getNewsItemsForServiceType:(NSString *)serviceType upToIndex:(NSUInteger)index;

- (void)flushCache;
- (void)reloadCache;

@end
