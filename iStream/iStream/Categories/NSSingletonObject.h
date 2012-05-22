//
//  NSSingletonObject.h
//
//  Created by Michael Hörl on 01.02.12.
//  Copyright (c) 2012 Michael Hörl. All rights reserved.
//
//	Licenced under the MIT licence: http://www.opensource.org/licenses/MIT

#import <Foundation/NSObject.h>


@interface NSSingletonObject: NSObject
+ (id)sharedInstance;
+ (void)destroy;
@end
