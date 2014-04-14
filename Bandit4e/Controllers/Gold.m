//
//  Gold.m
//  Bandit4e
//
//  Created by Cameron Lockey on 2/23/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import "Gold.h"
#import "Constants.h"
#import "UIHelpers.h"
#import "Character.h"
#import <QuartzCore/QuartzCore.h>

@interface Gold ()

@end

@implementation Gold

@synthesize character, delegate, goldField, currentGoldLabel, goldLabel, spendLabel, spendSwitch, doneButton, managedObjectContext;

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
	
	currentGoldLabel.font = LEAGUE(24.0f);
	currentGoldLabel.textColor = [UIColor colorWithWhite:0.5f alpha:1.0];
	[UIHelpers applyTextShadow:currentGoldLabel];
	
	goldLabel.text = character.gold.stringValue;
	goldLabel.font = LEAGUE(44.0f);
	goldLabel.textColor = GRAY;
	[UIHelpers applyTextShadow:goldLabel];
	
	goldField.font = LEAGUE(90.0f);
	goldField.textColor = GRAY;
	goldField.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	goldField.layer.shadowOffset = CGSizeMake(0,1);
	goldField.layer.shadowRadius = 0;
	goldField.layer.shadowOpacity = 1;
	[goldField becomeFirstResponder];
	
	spendLabel.font = LEAGUE(24.0f);
	spendLabel.textColor = [UIColor colorWithWhite:0.5f alpha:1.0];
	[UIHelpers applyTextShadow:spendLabel];
	
	spendSwitch.on = NO;
	spendSwitch.onTintColor = [UIColor colorWithRed:0.16 green:0.32 blue:0.46 alpha:1.0];
	amount = 0;
	total = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)resolveGold:(id)sender
{
	
	if ( total > 0 )
	{
		if (spendSwitch.on)
		{
			// spend gold
			character.gold = numInt(character.gold.intValue - amount);
		}
		else
		{
			// add gold
			character.gold = numInt(character.gold.intValue + amount);
		}
		//  Commit item to core data
		[Constants save:managedObjectContext];
		
		[delegate didAddGold];
	}
	else
	{
		[UIHelpers showAlertWithTitle:@"Not Enough Gold!" msg:@"You don't have enough gold to spend it like that."];
	}	
}

- (IBAction)switchToSpend:(id)sender
{
	[self updateTotal];
}

- (IBAction)goldChanged:(id)sender
{
	amount = goldField.text.intValue;
	[self updateTotal];
}

-(void) updateCommitButton
{
	NSString *commitString = (spendSwitch.on) ? @"Spend" : @"Gain";
	doneButton.title = [NSString stringWithFormat:@"%@ %i", commitString, goldField.text.intValue];
}

-(void)updateTotal
{
	if (spendSwitch.on)
	{
		total = character.gold.intValue - amount;
	}
	else
	{
		total = character.gold.intValue + amount;
	}
	
	goldLabel.text = [NSString stringWithFormat:@"%i",total];
	[self updateGoldLabel];
	[self updateCommitButton];
	
}

-(void)updateGoldLabel
{
	if (total < 0)
		goldLabel.textColor = RED;
	else
		goldLabel.textColor = GRAY;
}

@end
