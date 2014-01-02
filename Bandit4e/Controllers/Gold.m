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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)resolveGold:(id)sender {
	
	if (![goldField.text isEqualToString:@""])
	{
		int goldValue = goldField.text.intValue;
		
		if (spendSwitch.on) {
			// spend gold
			character.gold = numInt(character.gold.intValue - goldValue);
		}
		else
		{
			// add gold
			character.gold = numInt(character.gold.intValue + goldValue);
		}
	}		
	
	//  Commit item to core data
	[Constants save:managedObjectContext];
	
	[delegate didAddGold];
}

- (IBAction)switchToSpend:(id)sender {
	if (spendSwitch.on)
		doneButton.title = @"Spend";
	else
		doneButton.title = @"Add";
}
@end
