//
//  ReminderAdd.m
//  Bandit4e
//
//  Created by Cameron Lockey on 12/22/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import "Character.h"
#import "Constants.h"
#import "ReminderAdd.h"
#import "Reminder.h"
#import "UIHelpers.h"

@interface ReminderAdd ()

@end

@implementation ReminderAdd

@synthesize character, managedObjectContext, reminder, reminderField, turnSwitch, startLabel, endLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.backgroundColor = VIEWBG;
	
	reminderField.font = LEAGUE(35.0f);
	reminderField.textColor = GRAY;
	reminderField.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	reminderField.layer.shadowOffset = CGSizeMake(0,1);
	reminderField.layer.shadowRadius = 0;
	reminderField.layer.shadowOpacity = 1;
	
	// set text to reminder field if editing
	if (reminder)
	{
		reminderField.text = reminder.text;
	}
	
	[reminderField becomeFirstResponder];
	
	UIColor *switchBlue = [UIColor colorWithRed:0.16 green:0.32 blue:0.46 alpha:1.0];
	turnSwitch.onTintColor = switchBlue;
	
	// customize switch labels
	startLabel.font = ARVIL(22);
	startLabel.textColor = [UIColor darkGrayColor];
	[UIHelpers applyTextShadow:startLabel];
	
	endLabel.font = ARVIL(22);
	endLabel.textColor = [UIColor darkGrayColor];
	[UIHelpers applyTextShadow:endLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender
{
	if (![reminderField.text isEqualToString:@""])
	{
		if (!reminder)
		{
			reminder = (Reminder*)[NSEntityDescription insertNewObjectForEntityForName:@"Reminder"
														 inManagedObjectContext:managedObjectContext];
		}
		
		reminder.text = reminderField.text;
		reminder.showAtStart = (turnSwitch.on) ? numInt(1) : numInt(0);
		[character addRemindersObject:reminder];
		[Constants save:managedObjectContext];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else
	{
		[self cancel];
	}
}

- (void)cancel
{
	[self.navigationController popViewControllerAnimated:YES];
}
@end
