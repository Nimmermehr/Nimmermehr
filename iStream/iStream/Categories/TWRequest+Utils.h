//
//  TWRequest+Utils.h
//  TwitterConnect
//
//  Created by Thomas Kober on 3/31/12.
//  Copyright (c) 2012 Nimmermehr. All rights reserved.
//

#import <Twitter/Twitter.h>

@interface TWRequest (Utils)

+ (id)requestWithURL:(NSURL *)theURL parameters:(NSDictionary *)parameters requestMethod:(TWRequestMethod)requestMethod;

@end
