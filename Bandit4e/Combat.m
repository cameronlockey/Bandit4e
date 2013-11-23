//
//  Combat.m
//  Bandit4e
//
//  Created by Cameron Lockey on 12/23/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Character.h"
#import "Combat.h"
#import "Constants.h"
#import "UIHelpers.h"

@interface Combat ()<UIActionSheetDelegate>

@property(strong,nonatomic) NSMutableArray *restOptions;
- (IBAction)showRestOptions:(id)sender;

@end

@implementation Combat

@synthesize managedObjectContext, character, restOptions;
@synthesize characterInfoView, characterImageView, nameLabel, raceClassLevelLabel, hpLabel, surgesLabel, failedSavesValueLabel, failedSavesLabel, hitPoints, healingSurges;
@synthesize damageButton, healButton, goldButton, apButton, tempHpButton, expButton, restButton, ppButton, startEndTurnButton, combatNavigationBar;
@synthesize damageController, healController, experienceController, goldController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
	self.title = @"Combat";
	
	self.view.backgroundColor = VIEWBG;
		
	// set up characterInfo bg
	characterInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgLight.png"]];
	characterInfoView.layer.shadowColor = [[UIColor blackColor] CGColor];
	characterInfoView.layer.shadowOffset = CGSizeMake(0,1);
	characterInfoView.layer.shadowRadius = 2.0;
	characterInfoView.layer.shadowOpacity = 0.8f;
	characterInfoView.clipsToBounds = NO;
	
	// set up name label
	nameLabel.text = character.name;
	nameLabel.font = MISSION(29.0f);
	nameLabel.textColor = GRAY;
	nameLabel.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	nameLabel.layer.shadowOffset = CGSizeMake(0,1);
	nameLabel.layer.shadowRadius = 0;
	nameLabel.layer.shadowOpacity = 1;
	nameLabel.clipsToBounds = NO;
	
	// set up raceClassLevel label
	raceClassLevelLabel.text = [NSString stringWithFormat:@"LEVEL %@ %@ %@",character.level.stringValue, character.race, character.classname];
	raceClassLevelLabel.font = ARVIL(21.0f);
	raceClassLevelLabel.textColor = GRAY;
	[UIHelpers applyTextShadow:raceClassLevelLabel];
	
	// set up HPlabels
	hpLabel.text = [NSString stringWithFormat:@"%@/%@",character.currentHp, character.maxHp];
	hpLabel.font = LEAGUE(44.0f);
	hpLabel.textColor = GRAY;
	[UIHelpers applyTextShadow:hpLabel];
	
	hitPoints.font = LEAGUE(18.0f);
	hitPoints.textColor = GRAY;
	[UIHelpers applyTextShadow:hitPoints];
	
	// set up surges labels
	surgesLabel.text = [NSString stringWithFormat:@"%@/%@", character.currentSurges, character.maxSurges];
	surgesLabel.font = LEAGUE(44.0f);
	surgesLabel.textColor = GRAY;
	[UIHelpers applyTextShadow:surgesLabel];
	failedSavesValueLabel.text = character.failedSaves.stringValue;
	
	healingSurges.font = LEAGUE(18.0f);
	healingSurges.textColor = GRAY;
	[UIHelpers applyTextShadow:healingSurges];
	
	// check for bloodied value and set to red
	if (character.currentHp.intValue <= character.maxHp.intValue/2)
	{
		hpLabel.textColor = RED;
		hitPoints.textColor = RED;
	}
	
	// check for low surge value and set to yellow
	if (character.currentSurges.intValue <= 3)
	{
		surgesLabel.textColor = YELLOW;
		healingSurges.textColor = YELLOW;
	}
	
	// set up failed saves labels
	failedSavesValueLabel.text = character.failedSaves.stringValue;
	failedSavesValueLabel.font = LEAGUE(44.0f);
	failedSavesValueLabel.textColor = GRAY;
	[UIHelpers applyTextShadow:failedSavesValueLabel];
	
	failedSavesLabel.font = LEAGUE(18.0f);
	failedSavesLabel.textColor = GRAY;
	[UIHelpers applyTextShadow:failedSavesLabel];
	
	
	// Place the image
	UIImage *characterPhoto;
	if (character.photo != nil)
		characterPhoto = [[UIImage alloc] initWithData:character.photo];
	else
		characterPhoto = [UIImage imageNamed:@"noPhoto.png"];
	
	characterImageView.image = characterPhoto;
	characterImageView.contentMode = UIViewContentModeScaleAspectFill;
	characterImageView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
	characterImageView.layer.borderWidth = 1.0f;
	characterImageView.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	characterImageView.layer.shadowOffset = CGSizeMake(0,1);
	characterImageView.layer.shadowRadius = 0;
	characterImageView.layer.shadowOpacity = 1;
	
	if (!character.usesPp.intValue)
		ppButton.enabled = NO;
	
	if (character.currentHp == nil) {
		character.currentHp = character.maxHp;
		character.currentSurges = character.maxSurges;
		character.currentPp = character.maxPp;
	}
	
	// set up rest options
	restOptions = [[NSMutableArray alloc] initWithObjects:@"Short Rest", @"Short Rest + Milestone", @"Add Milestone", @"Extended Rest", nil];
	
	// set up start turn button
	startEndTurnButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	[startEndTurnButton setTitle:@"START TURN" forState:UIControlStateNormal];
	[startEndTurnButton setTitleColor:GRAY forState:UIControlStateNormal];
	startEndTurnButton.titleLabel.font = [UIFont fontWithName:@"League Gothic" size:40.0f];
	[startEndTurnButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[startEndTurnButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
	[startEndTurnButton setTitleEdgeInsets:UIEdgeInsetsMake(9, 10, 10, 10)];
	[UIHelpers applyTextShadow:startEndTurnButton.titleLabel];
	
	// fix combat buttons
	[self configureButton:damageButton LabelText:nil];
	[self configureButton:healButton LabelText:nil];
	[self configureButton:apButton LabelText:character.actionPoints.stringValue];
	[self configureButton:goldButton LabelText:character.gold.stringValue];
	[self configureButton:expButton LabelText:character.experience.stringValue];
	[self configureButton:tempHpButton LabelText:nil];
	[self configureButton:restButton LabelText:nil];
	[self configureButton:ppButton LabelText:character.currentPp.stringValue];
	
	// create TempHP Badge
	NSString *tempHpString = character.tempHp.stringValue;
	tempBadge = [CustomBadge customBadgeWithString:tempHpString
								   withStringColor:[UIColor whiteColor]
									withInsetColor:[UIColor colorWithRed:0.04 green:0.64 blue:0 alpha:1.0]
									withBadgeFrame:YES
							   withBadgeFrameColor:[UIColor whiteColor]
										 withScale:1.0
									   withShining:YES];
	tempBadge.frame = CGRectMake(tempHpButton.frame.size.width-tempBadge.frame.size.width*0.83, (-1*(tempBadge.frame.size.height*0.22)), tempBadge.frame.size.width, tempBadge.frame.size.height);
	[tempHpButton addSubview:tempBadge];
	tempHpButton.clipsToBounds = NO;
	
	// if no tempHP, set hidden
	if (character.tempHp.intValue < 1)
		tempBadge.hidden = YES;	
	
}

-(void)viewWillAppear:(BOOL)animated
{
	nameLabel.text = character.name;
	raceClassLevelLabel.text = [NSString stringWithFormat:@"LEVEL %@ %@ %@",character.level.stringValue, character.race, character.classname];
	
	[self updateStatLabels];
	
	characterImageView.image = [[UIImage alloc] initWithData:character.photo];
	
	if (!character.usesPp.intValue)
		ppButton.enabled = NO;
	
	if (character.currentHp == nil) {
		character.currentHp = character.maxHp;
		character.currentSurges = character.maxSurges;
		character.currentPp = character.maxPp;
	}
	
	[self updateCombatButton:apButton Label:actionPoints Value:character.actionPoints.stringValue];
	[self updateCombatButton:goldButton Label:gold Value:character.gold.stringValue];
	[self updateCombatButton:expButton Label:experiencePoints Value:character.experience.stringValue];
	[self updateCombatButton:ppButton Label:powerPoints Value:character.currentPp.stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureButton:(UIButton *)button LabelText:(NSString *)text
{
	UIEdgeInsets insets = UIEdgeInsetsMake(50, 4, 4, 4);
	
	[button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
	[button setTitleEdgeInsets:insets];
	[button setTitleColor:GRAY forState:UIControlStateNormal];
	button.titleLabel.font = LEAGUE(16.0f);
	
	// create value label0
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 69, 30)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = GRAY;
	label.font = LEAGUE(32.0f);
	label.textAlignment = NSTextAlignmentCenter;
	[UIHelpers applyTextShadow:label];
	if (button.enabled == NO) {
		label.layer.opacity = 0.5;
		button.titleLabel.layer.opacity = 0.5;
		label.text = 0;
	}
	[button addSubview:label];
	
	if (text != nil)
		label.text = text;
	else
		label.text = 0;
}

- (IBAction)returnToCharacterList:(id)sender
{
	
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)startTurn:(id)sender
{
	// handle dying or dead
	if (IS_DYING || IS_DEAD)
		[self handleDying];
	
	
}

-(void)updateCombatButton:(UIButton *)button Label:(UILabel *)label Value:(NSString *)value
{
	if ([button.subviews.lastObject isKindOfClass:[UILabel class]]) {
		label = button.subviews.lastObject;
		label.text = value;
	}
}

-(void)addFailedDeathSave
{
	character.failedSaves = numInt(character.failedSaves.intValue+1);
	[Constants save:managedObjectContext];
	[self updateStatLabels];
}

- (IBAction)confirmGainTempHp:(id)sender
{
	UIAlertView *gainTempHp = [[UIAlertView alloc] initWithTitle:@"Gain Temp HP" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Gain", nil];
	
	gainTempHp.alertViewStyle = UIAlertViewStylePlainTextInput;
	gainTempHp.tag = 3;
	
	UITextField *field = [gainTempHp textFieldAtIndex:0];
	field.placeholder = @"Temporary HP to Gain";
	field.keyboardType = UIKeyboardTypeNumberPad;
	
	[gainTempHp show];
}

-(IBAction)confirmUseActionPoint:(id)sender
{
	if (character.actionPoints.intValue > 0) {
		[UIHelpers showConfirmWithTitle:@"Use Action Point?" msg:nil delegate:self tag:1];
	}
	else
		[UIHelpers showAlertWithTitle:@"No Action Points" msg:@"Sorry, no Action Points. Do something awesome, then try again."];
	
}

- (IBAction)confirmUsePowerPoint:(id)sender {
	if (character.currentPp.intValue > 0) {
		UIAlertView *confirmPowerPoints = [[UIAlertView alloc] initWithTitle:@"Use Power Points?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Use", nil];
		
		confirmPowerPoints.alertViewStyle = UIAlertViewStylePlainTextInput;
		confirmPowerPoints.tag = 2;
		
		UITextField *field = [confirmPowerPoints textFieldAtIndex:0];
		field.placeholder = @"Power Points to Use";
		field.keyboardType = UIKeyboardTypeNumberPad;
		
		[confirmPowerPoints show];
		
	}
	else
		[UIHelpers showAlertWithTitle:@"No Power Points" msg:@"Sorry, no Power Points. You need to extended rest first."];
}

- (void)extendedRest
{
	// update hp and surge values
	character.currentHp = character.maxHp;
	character.currentSurges = character.maxSurges;
	
	// update failed saves
	character.failedSaves = numInt(0);
	
	[self updateStatLabels];
	
	// reset Action Points to 1
	character.actionPoints = numInt(1);
	[self updateCombatButton:apButton Label:actionPoints Value:character.actionPoints.stringValue];
	
	// reset Power Points to Max
	if (character.usesPp) {
		character.currentPp = character.maxPp;
		[self updateCombatButton:ppButton Label:powerPoints Value:character.maxPp.stringValue];
	}
	
	// reset Milestones to 0
	character.milestones = numInt(0);
	
	// update failed saves
	if (character.failedSaves.intValue > 0)
		character.failedSaves = numInt(0);
	
	//  Commit item to core data
	[Constants save:managedObjectContext];
}

- (void)gainMilestone
{
	// gain a milestone
	character.milestones = numInt(character.milestones.intValue + 1);
	
	// gain an action point
	character.actionPoints = numInt(character.actionPoints.intValue + 1);
	[self updateCombatButton:apButton Label:actionPoints Value:character.actionPoints.stringValue];
	
	// save
	[Constants save:managedObjectContext];
}

- (void)gainTempHp:(int)tempHp
{
	character.tempHp = numInt(tempHp);
	[Constants save:managedObjectContext];
	[self updateStatLabels];
	
	NSLog(@"Temp HP: %i", character.tempHp.intValue);
}

-(void)handleDying
{
	if (character.failedSaves.intValue < 3 && !(IS_DEAD)) {
		// Alert: Title: You are dying. Make a saving throw. Message: Did you save?
		UIAlertView *handleDying = [[UIAlertView alloc] initWithTitle:@"You are dying. Make a saving throw." message:@"Did you save?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
		handleDying.tag = 4;
		[handleDying show];
	}
	else
	{
		[UIHelpers showAlertWithTitle:@"You have died."];
	}
		
}

- (void)shortRest:(BOOL)milestone
{
	// how many surges can we use without going over?
	float deficit = character.maxHp.intValue - character.currentHp.intValue;
	int surges = floor(deficit / character.surgeValue.floatValue);
	
	// use that many surges
	[Character useHealingSurges:surges forCharacter:character];
	
	[self updateStatLabels];
	
	// add a milestone?
	if (milestone)
		[self gainMilestone];
	
	// update failed saves
	character.failedSaves = numInt(0);
		
	
	//  Commit item to core data
    [Constants save:managedObjectContext];
}

- (void)updateStatLabels
{
	
	// reset hp and surges
	hpLabel.text = [NSString stringWithFormat:@"%@/%@",character.currentHp, character.maxHp];
	surgesLabel.text = [NSString stringWithFormat:@"%@/%@", character.currentSurges, character.maxSurges];
	
	// reset color of hp and surges labels
	UIColor *red = [UIColor colorWithRed:0.55 green:0.05 blue:0.05 alpha:1];
	UIColor *gray = [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1];
	UIColor *yellow = [UIColor colorWithRed:0.63 green:0.58 blue:0.13 alpha:1];
	if (character.currentHp.intValue <= character.maxHp.intValue/2)
	{
		hpLabel.textColor = red;
		hitPoints.textColor = red;
	}
	else
	{
		hpLabel.textColor = gray;
		hitPoints.textColor = gray;
	}
	
	if (character.currentSurges.intValue <= 3)
	{
		surgesLabel.textColor = yellow;
		healingSurges.textColor = yellow;
	}
	else
	{
		surgesLabel.textColor = gray;
		healingSurges.textColor = gray;
	}
	
	// update failed saves value
	failedSavesValueLabel.text = character.failedSaves.stringValue;
	
	// update tempHp Badge and reposition according to size
	[self updateTempHpBadge];
	
}

-(void)updateTempHpBadge
{
	if (character.tempHp.intValue > 0)
	{
		[tempBadge autoBadgeSizeWithString:character.tempHp.stringValue];
		tempBadge.frame = CGRectMake(tempHpButton.frame.size.width-tempBadge.frame.size.width*0.81, (-1*(tempBadge.frame.size.height*0.22)), tempBadge.frame.size.width, tempBadge.frame.size.height);
		tempBadge.hidden = NO;
	}
	else
		tempBadge.hidden = YES;
	
}

-(void)useActionPoint
{
	// subtract one AP
	int newAP = character.actionPoints.intValue - 1;
	character.actionPoints = numInt(newAP);
	
	//  Commit item to core data
    [Constants save:managedObjectContext];
	
	// update button label
	[self updateCombatButton:apButton Label:actionPoints Value:character.actionPoints.stringValue];
}

-(void)usePowerPoints:(int)points
{
	if (points <= character.currentPp.intValue) {
		character.currentPp = numInt(character.currentPp.intValue - points);
		[self updateCombatButton:ppButton Label:powerPoints Value:character.currentPp.stringValue];
	}
	else
	{
		[self confirmUsePowerPoint:self];
		[UIHelpers showAlertWithTitle:@"Not Enough Power Points"];
		
	}
	
	//  Commit item to core data
    [Constants save:managedObjectContext];
	
}

- (IBAction)showRestOptions:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];
	
	for (NSString *option in self.restOptions)
	{
		[actionSheet addButtonWithTitle:option];
	}
	actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}


/* !UIAlertView Delegate Methods
 * ---------------------------------------------*/
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (alertView.tag) {
		case 1:
			[self useActionPoint];
			break;
		case 2:
			[self usePowerPoints:[alertView textFieldAtIndex:0].text.intValue];
			break;
		case 3:
			[self gainTempHp:[alertView textFieldAtIndex:0].text.intValue];
			break;
		case 4:
			if (buttonIndex == 1)
				[self addFailedDeathSave];			
			break;
		default:
			break;
	}
}

/* !ActionSheet Delegate Methods
 * ---------------------------------------------*/
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != actionSheet.cancelButtonIndex) {
		switch (buttonIndex) {
			case 0:
				[self shortRest:FALSE];
				break;
			case 1:
				[self shortRest:TRUE];
				break;
			case 2:
				[self gainMilestone];
				break;
			case 3:
				[self extendedRest];
				break;
			default:
				break;
		}
			
	}
}

/* !Damage Delegate Protocol Methods
 * ---------------------------------------------*/
-(void)didTakeDamage:(BOOL)amount Surge:(BOOL)surge
{
	if (amount || surge)
		[self updateStatLabels];
	
	[self dismissViewControllerAnimated:YES completion:NULL];
	
	if (IS_DEAD) {
		[UIHelpers showAlertWithTitle:@"You are dead."];
	}
}

/* !Heal Delegate Protocol Methods
 * ---------------------------------------------*/
-(void)didHealDamage
{
	[self updateStatLabels];
	[self dismissViewControllerAnimated:YES completion:NULL];
}

/* !Experience Delegate Protocol Methods
 * ---------------------------------------------*/
-(void)didGainExperience
{
	if ([expButton.subviews.lastObject isKindOfClass:[UILabel class]]) {
		experiencePoints = expButton.subviews.lastObject;
		experiencePoints.text = character.experience.stringValue;
	}
	[self dismissViewControllerAnimated:YES completion:NULL];
}

/* !Gold Delegate Protocol Methods
 * ---------------------------------------------*/
-(void)didAddGold
{
	if ([goldButton.subviews.lastObject isKindOfClass:[UILabel class]]) {
		gold = goldButton.subviews.lastObject;
		gold.text = character.gold.stringValue;
	}
	[self dismissViewControllerAnimated:YES completion:NULL];
}

/* !Segue Methods
 * ---------------------------------------------*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Damage"]) {
		damageController = segue.destinationViewController;
		damageController.managedObjectContext = managedObjectContext;
		damageController.character = character;
		damageController.delegate = self;
	}
	else if ([segue.identifier isEqualToString:@"Heal"])
	{
		healController = segue.destinationViewController;
		healController.managedObjectContext = managedObjectContext;
		healController.character = character;
		healController.delegate = self;
	}
	else if ([segue.identifier isEqualToString:@"Experience"])
	{
		experienceController = segue.destinationViewController;
		experienceController.managedObjectContext = managedObjectContext;
		experienceController.character = character;
		experienceController.delegate = self;
	}
	else if ([segue.identifier isEqualToString:@"Gold"])
	{
		goldController = segue.destinationViewController;
		goldController.managedObjectContext = managedObjectContext;
		goldController.character = character;
		goldController.delegate = self;
	}
}

@end
