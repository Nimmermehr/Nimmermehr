//
//  TWRequest+Utils.m
//  TwitterConnect
//
//  Created by Thomas Kober on 3/31/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import "TWRequest+Utils.h"

@implementation TWRequest (Utils)

+ (id)requestWithURL:(NSURL *)theURL parameters:(NSDictionary *)parameters requestMethod:(TWRequestMethod)requestMethod
{
    return [[self alloc] initWithURL:theURL parameters:parameters requestMethod:requestMethod];
}

@end
