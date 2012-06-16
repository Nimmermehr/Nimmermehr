//
//  NSURL+Utils.h
//  iStream
//
//  Created by Thomas Kober on 4/25/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Utils)

+ (NSURL *)URLWithFormat:(NSString *)format, ...;

- (NSURL *)URLByAppendingFormat:(NSString *)format, ...;

@end
