//
//  Character.h
//  Bandit4e
//
//  Created by Cameron Lockey on 12/8/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Condition, Note, Reminder;

@interface Character : NSManagedObject

@property (nonatomic, retain) NSNumber * actionPoints;
@property (nonatomic, retain) NSNumber * bloodiedValue;
@property (nonatomic, retain) NSString * classname;
@property (nonatomic, retain) NSNumber * currentHp;
@property (nonatomic, retain) NSNumber * currentPp;
@property (nonatomic, retain) NSNumber * currentSurges;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * maxHp;
@property (nonatomic, retain) NSNumber * maxPp;
@property (nonatomic, retain) NSNumber * maxSurges;
@property (nonatomic, retain) NSNumber * milestones;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * race;
@property (nonatomic, retain) NSNumber * saveAtStart;
@property (nonatomic, retain) NSNumber * saveModifier;
@property (nonatomic, retain) NSNumber * surgeValue;
@property (nonatomic, retain) NSNumber * tempHp;
@property (nonatomic, retain) NSNumber * usesPp;
@property (nonatomic, retain) NSNumber * gold;
@property (nonatomic, retain) NSNumber * failedSaves;
@property (nonatomic, retain) NSSet *conditions;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) NSSet *reminders;

+ (BOOL)useHealingSurges:(int)surges forCharacter:(Character*)character;

@end

@interface Character (CoreDataGeneratedAccessors)

- (void)setName:(NSString*)_name
		   Race:(NSString*)_race
		  Class:(NSString*)_classname
		  Level:(NSNumber*)_level
		  MaxHP:(NSNumber*)_maxHp
	  MaxSurges:(NSNumber*)_maxSurges
HealingSurgeValue:(NSNumber*)_surgeValue
SavingThrowModifier:(NSNumber*)_saveModifier
	 Experience:(NSNumber*)_experience
		   Gold:(NSNumber*)_gold
SaveAtStartOfTurn:(NSNumber*)_saveAtStart
 UsePowerPoints:(NSNumber*)_usesPp
 MaxPowerPoints:(NSNumber*)_maxPp;


- (void)addConditionsObject:(Condition *)value;
- (void)removeConditionsObject:(Condition *)value;
- (void)addConditions:(NSSet *)values;
- (void)removeConditions:(NSSet *)values;

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

- (void)addRemindersObject:(Reminder *)value;
- (void)removeRemindersObject:(Reminder *)value;
- (void)addReminders:(NSSet *)values;
- (void)removeReminders:(NSSet *)values;

@end
