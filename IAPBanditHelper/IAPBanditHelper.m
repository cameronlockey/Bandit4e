//
//  IAPBanditHelper.m
//  Bandit4e
//
//  Created by Cameron Lockey on 1/18/14.
//  Copyright (c) 2014 Fragment. All rights reserved.
//

#import "IAPBanditHelper.h"

@implementation IAPBanditHelper

+ (IAPBanditHelper*) sharedInstance
{
	static dispatch_once_t once;
    static IAPBanditHelper *sharedInstance;
    dispatch_once(&once, ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"product_ids"
											 withExtension:@"plist"];
		NSSet *productIdentifiers = [NSSet setWithArray:[NSArray arrayWithContentsOfURL:url]];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
