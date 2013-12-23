//
//  ReminderAdd.h
//  Bandit4e
//
//  Created by Cameron Lockey on 12/22/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Character;
@class Reminder;

@interface ReminderAdd : UIViewController

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Character *character;
@property (strong,nonatomic) Reminder *reminder;

@property (weak, nonatomic) IBOutlet UITextField *reminderField;
@property (weak, nonatomic) IBOutlet UISwitch *turnSwitch;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

- (IBAction)save:(id)sender;
- (void)cancel;
@end
