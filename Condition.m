//
//  Condition.m
//  Bandit4e
//
//  Created by Cameron Lockey on 12/8/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//

#import "Condition.h"
#import "Character.h"


@implementation Condition

@dynamic name;
@dynamic duration;
@dynamic damageAmount;
@dynamic damageType;
@dynamic turns;
@dynamic character;

+(NSMutableArray*)sortConditionsByDuration:(NSSet*)conditions
{
	NSMutableArray *conditionsToReturn = [[NSMutableArray alloc] init];
	
	return conditionsToReturn;
}

+(NSMutableArray*)getDurationsOfConditions:(NSSet *)conditions
{
	NSMutableArray *durationsToReturn = [[NSMutableArray alloc] init];
	
	return durationsToReturn;
}

@end
