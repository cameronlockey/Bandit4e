//
//  Constants.m
//  Bandit4e
//
//  Created by Cameron Lockey on 2/23/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+(void)save:(NSManagedObjectContext *)managedObjectContext
{
	NSError *error;
    if (![managedObjectContext save:&error])
        NSLog(@"Failed to update character with error: %@", [error domain]);
}

@end
