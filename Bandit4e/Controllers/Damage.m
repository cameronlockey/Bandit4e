//
//  Damage.m
//  Bandit4e
//
//  Created by Cameron Lockey on 2/10/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "Character.h"
#import "Constants.h"
#import "Damage.h"
#import "UIHelpers.h"


@interface Damage ()

@end

@implementation Damage

@synthesize delegate, character, amountField, loseSurgeSwitch, loseSurgeLabel, takeDamageButton, managedObjectContext;

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
	
	self.title = @"DAMAGE";
	
	amountField.font = LEAGUE(100.0f);
	amountField.textColor = GRAY;
	amountField.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	amountField.layer.shadowOffset = CGSizeMake(0,1);
	amountField.layer.shadowRadius = 0;
	amountField.layer.shadowOpacity = 1;
	
	loseSurgeLabel.font = LEAGUE(18.0f);
	loseSurgeLabel.textColor = GRAY;
	loseSurgeLabel.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	loseSurgeLabel.layer.shadowOffset = CGSizeMake(0,1);
	loseSurgeLabel.layer.shadowRadius = 0;
	loseSurgeLabel.layer.shadowOpacity = 1;
	
	[amountField becomeFirstResponder];
	loseSurgeSwitch.on = NO;
	loseSurgeSwitch.onTintColor = [UIColor colorWithRed:0.16 green:0.32 blue:0.46 alpha:1.0];
	
	if (character.currentSurges.intValue < 1)
	{
		loseSurgeSwitch.enabled = NO;
		loseSurgeLabel.layer.opacity = 0.5;
	}
	
	takeDamageButton.title = [NSString stringWithFormat:@"Take %i Damage", 0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takeDamage:(id)sender
{
	
	BOOL damage = false;
	BOOL surge = false;
	
	if (![amountField.text isEqualToString:@""])
	{
		int amount = amountField.text.intValue;
		int temp = character.tempHp.intValue;
		
		int netDamage = (temp > amount) ? 0 : amount - temp;
		
		character.currentHp = numInt(character.currentHp.intValue - netDamage);
		int tempUse = (temp > amount) ? temp - amount : 0;
		character.tempHp = numInt(tempUse);
		
		damage = true;
		NSLog(@"Current HP: %i", character.currentHp.intValue);
		NSLog(@"Temp HP: %i", character.tempHp.intValue);
	}
	
	if (loseSurgeSwitch.on)
	{
		character.currentSurges = [NSNumber numberWithInt:character.currentSurges.intValue - 1];
		surge = true;
	}
	
	//  Commit item to core data
	[Constants save:managedObjectContext];
	
	[delegate didTakeDamage:damage Surge:surge];	
}

- (IBAction)cancel:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)damageChanged:(id)sender
{
	takeDamageButton.title = [NSString stringWithFormat:@"Take %i Damage", amountField.text.intValue];
}
@end
