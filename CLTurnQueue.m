//
//  CLTurnQueue.m
//  Bandit4e
//
//  Created by Cameron Lockey on 12/24/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import "Character.h"
#import "CLTurnQueue.h"
#import "CoreDataHelper.h"
#import "Reminder.h"
#import "UIHelpers.h"

@implementation CLTurnQueue

@synthesize managedObjectContext, character, startReminders, endReminders, alertQueue, currentReminder;

/* !Instance Methods
 * ---------------------------------------------*/
-(CLTurnQueue*)init
{
	self = [super init];
	if (self)
	{
		self.managedObjectContext = [NSManagedObjectContext new];
		self.startReminders = [NSMutableArray new];
		self.endReminders = [NSMutableArray new];
		self.alertQueue = [NSMutableArray new];
		self.currentReminder = nil;
	}
	return self;
}

-(void) collectQueues
{
	[self collectQueue:1];
	[self collectQueue:0];
}

-(void) collectQueue:(int)start
{
	// try to get any start/end reminders from the managed object context
	
	NSMutableArray *reminders = [NSMutableArray arrayWithArray:[character.reminders allObjects]];
	[reminders filterUsingPredicate:[NSPredicate predicateWithFormat:@"showAtStart == %i", start]];
	
	// decide which queue we are collecting
	if (start)
		startReminders = reminders;
	else
		endReminders = reminders;
}

-(void) presentQueue:(int)start
{
	// reset currentReminder
	currentReminder = nil;
	
	// decide which queue to use
	alertQueue = (start) ? startReminders : endReminders;
	
	// show alerts sequentially
	[self showNextAlert];
	
}

-(BOOL)showNextAlert
{
	if (!currentReminder)
	{
		currentReminder = [alertQueue objectAtIndex:0];
		currentReminder.alert = [[UIAlertView alloc] initWithTitle:currentReminder.text message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Dismiss", @"OK", nil];
		[currentReminder.alert show];
	}
	else
	{
		NSInteger index = [alertQueue indexOfObject:currentReminder];
				
		if ( index < [alertQueue count]-1 )
		{
			index++;
			currentReminder = [alertQueue objectAtIndex:index];
			currentReminder.alert = [[UIAlertView alloc] initWithTitle:currentReminder.text message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Dismiss", @"OK", nil];
			[currentReminder.alert show];
		}
	}
	
	return NO;
}

-(BOOL)haveStartReminders
{
	if (startReminders.count > 0)
		return TRUE;
	
	return FALSE;
}

-(BOOL)haveEndReminders
{
	if (endReminders.count > 0)
		return TRUE;
	
	return FALSE;
}

-(void) dismissReminder:(Reminder *)reminder
{
	NSLog(@"removing reminder: %@", reminder);
	// Remove it from our collection of reminders
	if (currentReminder.showAtStart.intValue == 1)
		[startReminders removeObject:currentReminder];
	else if (currentReminder.showAtStart.intValue == 0)
		[endReminders removeObject:currentReminder];
	
	// Delete the item in core data
	[managedObjectContext deleteObject:currentReminder];
}

/* !Class Methods
 * ---------------------------------------------*/
+(CLTurnQueue*)new
{
	return [[CLTurnQueue alloc] init];
}

+(CLTurnQueue*)queueWithManagedObjectContext:(NSManagedObjectContext *)context andCharacter:(Character *)character
{
	CLTurnQueue *queue = [CLTurnQueue new];
	queue.managedObjectContext = context;
	queue.character = character;
	[queue collectQueues];
	return queue;
}

/* !UIAlertViewDelegate Methods
 * ---------------------------------------------*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		[self dismissReminder:currentReminder];
	}
	[self showNextAlert];
}

@end
