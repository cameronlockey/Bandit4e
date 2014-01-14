//
//  Note.m
//  Bandit4e
//
//  Created by Cameron Lockey on 12/8/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//

#import "Note.h"
#import "Character.h"


@implementation Note

@dynamic text;
@dynamic character;

-(NSString*)description
{
	NSString *description = [NSString stringWithFormat:@"%@", self.text];
	return description;
}

@end
