//
//  CLTurnQueue.h
//  Bandit4e
//
//  Created by Cameron Lockey on 12/24/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Character;
@class Reminder;

@interface CLTurnQueue : NSObject <UIAlertViewDelegate>

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Character *character;
@property (strong,nonatomic) NSMutableArray *startReminders;
@property (strong,nonatomic) NSMutableArray *endReminders;
@property (strong,nonatomic) NSMutableArray *alertQueue;
@property (strong,nonatomic) Reminder *currentReminder;

+(CLTurnQueue*)new;
+(CLTurnQueue*)queueWithManagedObjectContext:(NSManagedObjectContext*)context andCharacter:(Character*)character;
-(void)collectQueues;
-(void)collectQueue:(int)start;
-(void)presentQueue:(int)start;
-(BOOL)showNextAlert;
-(BOOL)haveStartReminders;
-(BOOL)haveEndReminders;
-(void)dismissReminder:(Reminder*)reminder;

@end
