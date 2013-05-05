//
//  Condition.h
//  Bandit4e
//
//  Created by Cameron Lockey on 12/8/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character;

@interface Condition : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * damageAmount;
@property (nonatomic, retain) NSNumber * damageType;
@property (nonatomic, retain) NSNumber * turns;
@property (nonatomic, retain) Character *character;

+(NSMutableArray*)sortConditionsByDuration:(NSSet*)conditions;
+(NSMutableArray*)getDurationsOfConditions:(NSSet*)conditions;

@end
