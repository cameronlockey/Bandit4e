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

@synthesize managedObjectContext, character, startReminders, endReminders, alertQueue, currentReminder, delegate;

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
		index = 0;
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
		currentReminder.alert = [[UIAlertView alloc] initWithTitle:currentReminder.text message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Remove", @"OK", nil];
		[currentReminder.alert show];
	}
	else
	{
		if ( alertQueue.count > 0 && index <= [alertQueue indexOfObject:alertQueue.lastObject] )
		{
			currentReminder = [alertQueue objectAtIndex:index];
			currentReminder.alert = [[UIAlertView alloc] initWithTitle:currentReminder.text message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Remove", @"OK", nil];
			[currentReminder.alert show];
			index++;
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

-(void) dismissReminder
{
	NSLog(@"index of currentReminder: %i", index);
	NSLog(@"alert queue: %@", alertQueue);
	[alertQueue removeObjectAtIndex:index];
	
	// Delete the item in core data
	[managedObjectContext deleteObject:currentReminder];
	
	// Commit the deletion in core data
	NSError *error;
	if (![managedObjectContext save:&error])
		NSLog(@"Failed to delete reminder with error: %@", error.domain);
}

/* !Class Methods
 * ---------------------------------------------*/
+(CLTurnQueue*)new
{
	return [[CLTurnQueue alloc] init];
}

+(CLTurnQueue*)queueWithManagedObjectContext:(NSManagedObjectContext *)context Character:(Character *)character Delegate:(id)delegate
{
	CLTurnQueue *queue = [CLTurnQueue new];
	queue.managedObjectContext = context;
	queue.character = character;
	queue.delegate = delegate;
	[queue collectQueues];
	return queue;
}

/* !UIAlertViewDelegate Methods
 * ---------------------------------------------*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		[self dismissReminder];
	}
	[self showNextAlert];
	
	if (alertQueue.count == 0 || index == [alertQueue indexOfObject:alertQueue.lastObject])
	{
		[delegate turnQueueDidFinish];
	}
}

@end
