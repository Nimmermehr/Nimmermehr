//
//  NSSingletonObject.m
//
//  Created by Michael Hörl on 01.02.12.
//  Copyright (c) 2012 Michael Hörl. All rights reserved.
//
//	Licenced under the MIT licence: http://www.opensource.org/licenses/MIT

#import "NSSingletonObject.h"
#import <Foundation/NSDictionary.h>


@interface NSSingletonObject (Private)
+ (void)destroyAllInstances;
@end


@implementation NSSingletonObject

static NSMutableDictionary *_sharedInstances = nil;
static __strong id _cachedInstance = nil;

#pragma mark Class methods (Private)

+ (void)destroyAllInstances {
	[_sharedInstances removeAllObjects];
	//[_sharedInstances release]; _sharedInstances = nil;	// <-- ARC
}

#pragma mark Class methods (Public)

+ (id)sharedInstance {
	if ([_cachedInstance class] == self)
		return _cachedInstance;
	
	if (!_sharedInstances) _sharedInstances = [[NSMutableDictionary alloc] init];
	
	id _sharedInstance = nil;
	
	if (!(_sharedInstance = [_sharedInstances objectForKey:self])) {
		_sharedInstance = [[self alloc] init];
		//_sharedInstance = [[[self alloc] init] autorelease];	// <-- ARC
		[_sharedInstances setObject:_sharedInstance forKey:self];
	}
	
	_cachedInstance = _sharedInstance;
	
	return _sharedInstance;
}

+ (void)destroy {
	_cachedInstance = nil;
	[_sharedInstances removeObjectForKey:self];
	if (_sharedInstances.count == 0) [self destroyAllInstances];
}

@end
