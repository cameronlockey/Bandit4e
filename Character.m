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

-(NSString*) description
{
	NSString *description = [NSString stringWithFormat:@"%@, L%i %@ %@ - %i/%i HP | %i/%i SUR | %i EXP | %i GP", self.name, self.level.intValue, self.race, self.classname, self.currentHp.intValue, self.maxHp.intValue, self.currentSurges.intValue, self.maxSurges.intValue, self.experience.intValue, self.gold.intValue];
	return description;
}

+ (BOOL)useHealingSurges:(int)surges forCharacter:(Character*)character
{
	// do we have any surges?
	// add them to currentHP
	if (character.currentSurges.intValue > 0 && surges > 0) {
		
		float deficit = character.maxHp.intValue - character.currentHp.intValue;
		
		// should we really use that many?
		if (surges > 1) {
			
			// if I need less than I'm about to use
			if ( deficit < character.surgeValue.intValue*surges)
			{
				// how many should I use without going over?
				int surgesToUse = surges;
				int surges = MIN(surgesToUse,floor(deficit / character.surgeValue.floatValue));
				NSLog(@"using %i surges", surges);
			}
				
		}
		
		// are we at max health already?
		// if not, give me some freakin' HP
		if (deficit > 0) {
			
			int amountFromSurges = character.surgeValue.intValue * surges;
			NSLog(@"amountFromSurges: %i", amountFromSurges);
			
			int newHP = amountFromSurges + character.currentHp.intValue;
			character.currentHp = (newHP > character.maxHp.intValue) ? character.maxHp : numInt(newHP);
			NSLog(@"currentHP: %@", character.currentHp);
			
			// update surges
			int remainingSurges = character.currentSurges.intValue - surges;
			character.currentSurges = (remainingSurges < 0) ? 0 : numInt(remainingSurges);
		}
		
		return TRUE;
		
	}
	else
		return FALSE;
		
}

@end
