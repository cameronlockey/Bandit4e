//
//  Experience.m
//  Bandit4e
//
//  Created by Cameron Lockey on 2/18/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import "Experience.h"
#import "Character.h"
#import "UIHelpers.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@interface Experience ()

@end

@implementation Experience

@synthesize experienceField, experienceLabel, gainButton, currentExperienceLabel, delegate, character, managedObjectContext;

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
	
	currentExperienceLabel.font = LEAGUE(24.0f);
	currentExperienceLabel.textColor = [UIColor colorWithWhite:0.5f alpha:1.0];
	currentExperienceLabel.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	currentExperienceLabel.layer.shadowOffset = CGSizeMake(0,1);
	currentExperienceLabel.layer.shadowRadius = 0;
	currentExperienceLabel.layer.shadowOpacity = 1;
	
	experienceLabel.font = LEAGUE(44.0f);
	experienceLabel.textColor = GRAY;
	experienceLabel.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	experienceLabel.layer.shadowOffset = CGSizeMake(0,1);
	experienceLabel.layer.shadowRadius = 0;
	experienceLabel.layer.shadowOpacity = 1;
	
	experienceField.font = LEAGUE(90.0f);
	experienceField.textColor = GRAY;
	experienceField.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	experienceField.layer.shadowOffset = CGSizeMake(0,1);
	experienceField.layer.shadowRadius = 0;
	experienceField.layer.shadowOpacity = 1;
	
	experienceLabel.text = character.experience.stringValue;
	[experienceField becomeFirstResponder];
	
	amount = 0;
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

- (IBAction)gainExperience:(id)sender
{
	
	if (amount > 0)
		character.experience = numInt(character.experience.intValue + amount);
	
	//  Commit item to core data
    [Constants save:managedObjectContext];
	
	[delegate didGainExperience];	
}

- (IBAction)experienceChanged:(id)sender
{
	amount = experienceField.text.intValue;
	experienceLabel.text = [NSString stringWithFormat:@"%i", character.experience.intValue + amount];
	gainButton.title = [NSString stringWithFormat:@"Gain %i EXP", amount];
}

@end
