//
//  Reminders.h
//  Bandit4e
//
//  Created by Cameron Lockey on 12/22/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;
@class Reminder;

@interface Reminders : UITableViewController

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Character *character;
@property (strong,nonatomic) NSMutableArray *reminders;
@property (strong,nonatomic) Reminder *selectedReminder;

- (IBAction)done:(id)sender;
@end