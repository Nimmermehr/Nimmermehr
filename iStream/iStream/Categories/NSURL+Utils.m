//
//  NSURL+Utils.m
//  iStream
//
//  Created by Thomas Kober on 4/25/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "NSURL+Utils.h"

@implementation NSURL (Utils)

+ (NSURL *)URLWithFormat:(NSString *)format, ...
{
    va_list arguments;
    va_start(arguments, format);
    
    NSString *stringURL = [[NSString alloc] initWithFormat:format arguments:arguments];
    
    va_end(arguments);
    
    return [NSURL URLWithString:stringURL];
}

- (NSURL *)URLByAppendingFormat:(NSString *)format, ...
{
    NSString *URLString = [self absoluteString];
    
    va_list arguments;
    va_start(arguments, format);
    
    NSString *appendix = [[NSString alloc] initWithFormat:format arguments:arguments];
    
    va_end(arguments);
    
    URLString = [URLString stringByAppendingString:appendix];
    
    return [NSURL URLWithString:URLString];
}

@end
