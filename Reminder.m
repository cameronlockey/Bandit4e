//
//  Reminder.m
//  Bandit4e
//
//  Created by Cameron Lockey on 12/8/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//

#import "Reminder.h"
#import "Character.h"


@implementation Reminder

@dynamic text;
@dynamic showAtStart;
@dynamic character;

@synthesize alert;

-(NSString*)description
{
	NSString *start = (self.showAtStart.intValue) ? @"START" : @"END";
	NSString *description = [NSString stringWithFormat:@"(%@) - %@", start, self.text];
	return description;
}

@end
