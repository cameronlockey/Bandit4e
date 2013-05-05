//
//  ConditionAdd.m
//  Bandit4e
//
//  Created by Cameron Lockey on 3/19/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "ConditionAdd.h"
#import "Constants.h"
#import "UIHelpers.h"

@interface ConditionAdd ()

@end

@implementation ConditionAdd

@synthesize character, managedObjectContext, delegate;
@synthesize names, durations;
@synthesize namePicker, durationPicker, damageLabel, damageTypeField, damageAmountField, turnsField, turnsLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.backgroundColor = VIEWBG;
	
	// set up conditions types
	names = [NSArray arrayWithObjects:@"Ongoing Damage", @"Asleep", @"Blinded", @"Dazed", @"Deafened", @"Dominated", @"Helpless", @"Immobilized", @"Petrified", @"Prone", @"Restrained", @"Slowed", @"Stunned", @"Unconscious", @"Weakened", nil];
	
	// set up conditions durations
	durations = [NSArray arrayWithObjects:@"Start of Turn (SOT)", @"End of Turn (EOT)", @"Save Ends", @"End of Encounter (EOE)", @"# of Turns", nil];
	
	NSInteger selected = [namePicker selectedRowInComponent:0];
	
	// show/hide damage interface
	if (selected == 0)
		[self showDamageInterface:YES]; 
	else
		[self showDamageInterface:NO];
	
	// show/hide turns interface
	if (durationPicker.selectedSegmentIndex == 4)
	{
		[self showTurnsInterface:YES];
	}
	else
	{
		[self showTurnsInterface:NO];
	}
	
	// customize labels and fields
	[self customizeLabel:damageLabel];
	[self customizeField:damageAmountField];
	[self customizeField:damageTypeField];
	[self customizeLabel:turnsLabel];
	[self customizeField:turnsField];
		
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
	[delegate conditionAddDidCancel];
}

- (IBAction)saveCondition:(id)sender
{
	[delegate conditionAddDidFinish];
}

- (IBAction)durationChanged:(id)sender
{
	if (durationPicker.selectedSegmentIndex == 4)
		[self showTurnsInterface:YES];
	else
		[self showTurnsInterface:NO];
}

-(void)showDamageInterface:(BOOL)show
{
	if (show)
	{
		if (turnsShowing)
			[self moveTurnsToSecondRow:YES];
		
		damageLabel.hidden = NO;
		damageTypeField.hidden = NO;
		damageAmountField.hidden = NO;
		damageShowing = YES;
	}
	else
	{
		if (turnsShowing)
			[self moveTurnsToSecondRow:NO];
		
		damageLabel.hidden = YES;
		damageTypeField.hidden = YES;
		damageAmountField.hidden = YES;
		damageShowing = NO;
	}
}

-(void)showTurnsInterface:(BOOL)show
{
	if (show)
	{
		if (damageShowing)
		{
			[self moveTurnsToSecondRow:YES];
		}
		
		turnsLabel.hidden = NO;
		turnsField.hidden = NO;
		turnsShowing = YES;
	}
	else
	{
		turnsLabel.hidden = YES;
		turnsField.hidden = YES;
		turnsShowing = NO;
		
		[self moveTurnsToSecondRow:NO];
	}
}

-(void)moveTurnsToSecondRow:(BOOL)move
{
	if (move)
	{
		turnsLabel.frame = CGRectMake(20, 361, 133, 21);
		turnsField.frame = CGRectMake(151, 357, 149, 30);
	}
	else
	{
		turnsLabel.frame = CGRectMake(20, 323, 133, 21);
		turnsField.frame = CGRectMake(151, 319, 149, 30);
	}
}

-(void)customizeLabel:(UILabel *)label
{
	label.font = LEAGUE(22.0f);
	label.textColor = GRAY;
	[UIHelpers applyTextShadow:label];
	[label.text uppercaseString];
}

-(void)customizeField:(UITextField *)field
{
	field.font = LEAGUE(25.0f);
	field.textColor = GRAY;
	field.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	field.layer.shadowOffset = CGSizeMake(0,1);
	field.layer.shadowRadius = 0;
	field.layer.shadowOpacity = 1;
	[field.text uppercaseString];
}

-(void)scrollToDamageFields:(BOOL)showKeyboard
{
	if (showKeyboard) {
		[UIView animateWithDuration:0.25 animations:^{
			self.view.frame = CGRectMake(self.view.frame.origin.x, -95, self.view.frame.size.width, self.view.frame.size.height);
		}];
	}
	else
	{
		[UIView animateWithDuration:0.25 animations:^{
			self.view.frame = CGRectMake(self.view.frame.origin.x, 20, self.view.frame.size.width, self.view.frame.size.height);
		}];
	}
}
-(void)scrollToTurnsField:(BOOL)showKeyboard
{
	if (showKeyboard) {
		[UIView animateWithDuration:0.25 animations:^{
			self.view.frame = CGRectMake(self.view.frame.origin.x, -128, self.view.frame.size.width, self.view.frame.size.height);
		}];
	}
	else
	{
		[UIView animateWithDuration:0.25 animations:^{
			self.view.frame = CGRectMake(self.view.frame.origin.x, 20, self.view.frame.size.width, self.view.frame.size.height);
		}];
	}
}


/* !UIPickerViewDelegate Methods
 * ---------------------------------------------*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [names count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [names objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (row == 0)
		[self showDamageInterface:YES];
	else
		[self showDamageInterface:NO];
}

/* !UITextFieldDelegate
 * ---------------------------------------------*/
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	if ([textField isEqual:damageAmountField] || [textField isEqual:damageTypeField])
	{
		if (self.view.frame.origin.y == 20)
			[self scrollToDamageFields:YES];
	}
	else if ([textField isEqual:turnsField])
	{
		if (self.view.frame.origin.y == 20)
			[self scrollToTurnsField:YES];
	}
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([textField isEqual:damageAmountField])
		[damageTypeField becomeFirstResponder];
	else if ([textField isEqual:damageTypeField])
	{
		[textField resignFirstResponder];
		[self scrollToDamageFields:NO];
	}	
	else if ([textField isEqual:turnsField])
	{
		[textField resignFirstResponder];
		[self scrollToTurnsField:NO];
	}
	
	return YES;
}


@end
