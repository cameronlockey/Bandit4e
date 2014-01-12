//
//  Heal.m
//  Bandit4e
//
//  Created by Cameron Lockey on 2/11/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import "Character.h"
#import "Heal.h"
#import "UIHelpers.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>


@interface Heal ()

@end

@implementation Heal

@synthesize delegate, character, numSurgesSegmentControl, additionalHealingField, regainSurgesField, managedObjectContext, totalLabel, gainButton;

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
	self.navigationController.navigationBar.translucent = NO;
	
	additionalHealingField.font = LEAGUE(60.0f);
	additionalHealingField.textColor = GRAY;
	additionalHealingField.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	additionalHealingField.layer.shadowOffset = CGSizeMake(0,1);
	additionalHealingField.layer.shadowRadius = 0;
	additionalHealingField.layer.shadowOpacity = 1;
	
	regainSurgesField.font = LEAGUE(60.0f);
	regainSurgesField.textColor = GRAY;
	regainSurgesField.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	regainSurgesField.layer.shadowOffset = CGSizeMake(0,1);
	regainSurgesField.layer.shadowRadius = 0;
	regainSurgesField.layer.shadowOpacity = 1;
	
	[additionalHealingField becomeFirstResponder];
	
	if (character.currentSurges.intValue < 2)
	{
		[numSurgesSegmentControl setEnabled:NO forSegmentAtIndex:2];
	}
	
	if (character.currentSurges.intValue < 1)
	{
		[numSurgesSegmentControl setEnabled:NO forSegmentAtIndex:1];
	}
	
	numSurgesSegmentControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	
	// set up total and totalLabel
	total = 0;
	totalLabel.font = LEAGUE(44.0f);
	totalLabel.textColor = GRAY;
	totalLabel.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	totalLabel.layer.shadowOffset = CGSizeMake(0,1);
	totalLabel.layer.shadowRadius = 0;
	totalLabel.layer.shadowOpacity = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)heal:(id)sender {
	
	selectedSegment = numSurgesSegmentControl.selectedSegmentIndex;
	
	NSLog(@"Selected segment was %i", selectedSegment);
	
	if (character.currentHp.intValue < character.maxHp.intValue) {
		
		NSLog(@"Need some HPs!");
		
		surgesToUse = 0;
		// are we using surges?
		if (selectedSegment != 0)
		{
			NSLog(@"using surges");
			surgesToUse = selectedSegment;
			
			if (![Character useHealingSurges:surgesToUse forCharacter:character])
				[UIHelpers showAlertWithTitle:@"No Healing Surges" msg:@"You don't have any Healing Surges. That sucks!"];
		}
		
		// add additional healing to currentHP
		if (![additionalHealingField.text isEqualToString:@""]) {
			additional = additionalHealingField.text.intValue;
			NSLog(@"Getting some additional HPs! %i in fact!", additional);
			
			newHP = character.currentHp.intValue + additional;
			character.currentHp = (newHP > character.maxHp.intValue) ? character.maxHp : numInt(newHP);
			NSLog(@"Current HP: %i", character.currentHp.intValue);
		}
		
	}
	
	// regain surges
	if (![regainSurgesField.text isEqualToString:@""]) {
		NSLog(@"Regaining %i surges!", regainSurgesField.text.intValue);
		newCurrentSurges = character.currentSurges.intValue + regainSurgesField.text.intValue;
		character.currentSurges = (newCurrentSurges > character.maxSurges.intValue) ? character.maxSurges : numInt(newCurrentSurges);
	}	
	
	//  Commit item to core data
    [Constants save:managedObjectContext];
	
	[delegate didHealDamage];
}

- (IBAction)segmentChanged:(id)sender
{
	hpFromSurges = numSurgesSegmentControl.selectedSegmentIndex * character.surgeValue.intValue;
	[self updateTotal];
}

- (IBAction)additionalChanged:(id)sender
{
	additional = additionalHealingField.text.intValue;
	[self updateTotal];
}

- (IBAction)regainSurgesChanged:(id)sender
{
	[self updateGainButton];
}

- (void)updateTotal
{
	total = hpFromSurges + additional;
	totalLabel.text = strInt(total);
	[self updateGainButton];
}

- (void)updateGainButton
{
	if (regainSurgesField.text.length > 0 && total > 0)
		gainButton.title = @"Gain";
	else if (regainSurgesField.text.length > 0)
	{
		NSString *plural = (regainSurgesField.text.intValue > 1) ? @"Surges" : @"Surge";
		gainButton.title = [NSString stringWithFormat:@"Gain %i %@", regainSurgesField.text.intValue, plural];
	}
	else
	{
		gainButton.title = [NSString stringWithFormat:@"Gain %i HP", total];
	}
		
}

@end
