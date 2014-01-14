//
//  Character.m
//  Bandit4e
//
//  Created by Cameron Lockey on 12/8/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//

#import "Character.h"
#import "Condition.h"
#import "Note.h"
#import "Reminder.h"
#import "UIHelpers.h"


@implementation Character

@dynamic actionPoints;
@dynamic bloodiedValue;
@dynamic classname;
@dynamic currentHp;
@dynamic currentPp;
@dynamic currentSurges;
@dynamic experience;
@dynamic level;
@dynamic maxHp;
@dynamic maxPp;
@dynamic maxSurges;
@dynamic milestones;
@dynamic name;
@dynamic photo;
@dynamic race;
@dynamic saveAtStart;
@dynamic saveModifier;
@dynamic surgeValue;
@dynamic tempHp;
@dynamic usesPp;
@dynamic gold;
@dynamic failedSaves;
@dynamic conditions;
@dynamic notes;
@dynamic reminders;

-(void)setName:(NSString *)_name
		  Race:(NSString *)_race
		 Class:(NSString *)_classname
		 Level:(NSNumber *)_level
		 MaxHP:(NSNumber *)_maxHp
	 MaxSurges:(NSNumber *)_maxSurges
HealingSurgeValue:(NSNumber *)_surgeValue
SavingThrowModifier:(NSNumber *)_saveModifier
	Experience:(NSNumber *)_experience
		  Gold:(NSNumber *)_gold
SaveAtStartOfTurn:(NSNumber *)_saveAtStart
UsePowerPoints:(NSNumber *)_usesPp
MaxPowerPoints:(NSNumber *)_maxPp
{
	self.name = _name;
	self.race = _race;
	self.classname = _classname;
	self.level = _level;
	self.maxHp = _maxHp;
	self.currentHp = self.maxHp;
	self.maxSurges = _maxSurges;
	self.currentSurges = self.maxSurges;
	self.surgeValue = _surgeValue;
	self.saveModifier = _saveModifier;
	self.actionPoints = numInt(1);
	self.experience = _experience;
	self.gold = _gold;
	self.saveAtStart = _saveAtStart;
	self.usesPp = _usesPp;
	self.maxPp = _maxPp;
	self.currentPp = self.maxPp;
	self.failedSaves = numInt(0);
	
	// Resize and save a smaller version for the table
	UIImage *image = [UIImage imageNamed:@"sampreston_quick.png"];
	
	// Save the small image version
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
	self.photo = imageData;
}

-(NSString*) description
{
	NSString *description = [NSString stringWithFormat:@"%@, L%i %@ %@ - %i/%i HP | %i/%i SUR | %i EXP | %i GP", self.name, self.level.intValue, self.race, self.classname, self.currentHp.intValue, self.maxHp.intValue, self.currentSurges.intValue, self.maxSurges.intValue, self.experience.intValue, self.gold.intValue];
	return description;
}

+ (NSDictionary*)useHealingSurges:(int)surges forCharacter:(Character*)character
{
	// do we have any surges?
	// add them to currentHP
	if (character.currentSurges.intValue > 0 && surges > 0)
	{
		
		// determine the deficit (HP needed)
		float deficit;
		if (character.currentHp.intValue <= 0)
			deficit = character.maxHp.intValue;
		else
			deficit = character.maxHp.intValue - character.currentHp.intValue;

		
		// should we really use that many?
		if (surges > 1)
		{
			
			// if I need less than I'm about to use
			if ( deficit < character.surgeValue.intValue*surges)
			{
				// how many should I use without going over?
				int surgesToUse = surges;
				surges = MIN(surgesToUse,floor(deficit / character.surgeValue.floatValue));
			}
			NSLog(@"using %i surges", surges);
		}
		
		// can I use this many?
		if (surges > character.currentSurges.intValue)
		{
			// you are trying to use more than you have left...calculating the most you can use, if any
			NSLog(@"you are trying to use more than you have left...calculating the most you can use, if any");
			if (character.currentSurges.intValue > 0)
			{
				surges = character.currentSurges.intValue;
				
			}
			NSLog(@"NOW using %i surges", surges);
		}
		
		// are we at max health already?
		// if not, heal up!
		if (deficit > 0)
		{
			int amountFromSurges = character.surgeValue.intValue * surges;
			NSLog(@"amountFromSurges: %i", amountFromSurges);
			
			// set current HP to 0 if dying (HP < 0)
			if (character.currentHp.intValue < 0)
				character.currentHp = numInt(0);
			
			int newHP = amountFromSurges + character.currentHp.intValue;
			character.currentHp = (newHP > character.maxHp.intValue) ? character.maxHp : numInt(newHP);
			NSLog(@"currentHP: %@", character.currentHp);
			
			// update surges
			int remainingSurges = character.currentSurges.intValue - surges;
			character.currentSurges = numInt(remainingSurges);
			
			NSDictionary *usedSurges = [NSDictionary dictionaryWithObjectsAndKeys:numInt(surges), @"surges", numInt(amountFromSurges), @"amount", nil];
			
			return usedSurges;
		}
		
		return FALSE;
		
	}
	else
	{
		return FALSE;
	}		
}

@end
