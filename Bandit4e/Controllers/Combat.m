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
#import "Note.h"
#import "Reminder.h"
#import "UIHelpers.h"

#define START 1;
#define END 0;

@interface Combat ()<UIActionSheetDelegate>

@property(strong,nonatomic) NSMutableArray *restOptions;
- (IBAction)showRestOptions:(id)sender;

@end

@implementation Combat

@synthesize managedObjectContext, character, restOptions, turnQueue;
@synthesize characterInfoView, characterImageView, nameLabel, raceClassLevelLabel, hpLabel, surgesLabel, failedSavesValueLabel, failedSavesLabel, hitPoints, healingSurges;
@synthesize damageButton, healButton, goldButton, apButton, tempHpButton, expButton, restButton, ppButton, startTurnButton, remindersButton, notesButton;
@synthesize damageController, healController, experienceController, goldController, notesController, remindersController;

/* !Default ViewController Methods
 * ---------------------------------------------*/
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
	
	start = YES;
	self.view.backgroundColor = VIEWBG;
	self.navigationController.navigationBar.translucent = NO;
	
	
	self.title = @"";
	UIImage *characterListIcon = [UIImage imageNamed:@"icon-characters.png"];
	UIBarButtonItem *characterListButton = [[UIBarButtonItem alloc] initWithImage:[characterListIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(returnToCharacterList)];
	self.navigationItem.leftBarButtonItem = characterListButton;
	self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
	
	UIImage *titleImage = [UIImage imageNamed:@"bandit4e_title.png"];
	float x = (self.view.frame.size.width / 2) - (titleImage.size.width/2);
	UIImageView *banditTitle = [[UIImageView alloc] initWithFrame:CGRectMake(x, 2, titleImage.size.width, titleImage.size.height)];
	banditTitle.image = titleImage;
	[self.navigationController.navigationBar addSubview:banditTitle];
		
	// set up characterInfo bg
	characterInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgLight.png"]];
	characterInfoView.layer.shadowColor = [[UIColor blackColor] CGColor];
	characterInfoView.layer.shadowOffset = CGSizeMake(0,1);
	characterInfoView.layer.shadowRadius = 2.0;
	characterInfoView.layer.shadowOpacity = 0.8f;
	characterInfoView.clipsToBounds = NO;
	
	// set up name label
	nameLabel.font = MISSION(29.0f);
	nameLabel.textColor = GRAY;
	[UIHelpers applyTextShadow:nameLabel];
	nameLabel.clipsToBounds = NO;
	
	// set up raceClassLevel label
	raceClassLevelLabel.font = ARVIL(21.0f);
	raceClassLevelLabel.textColor = GRAY;
	[UIHelpers applyTextShadow:raceClassLevelLabel];
	
	// set up HPlabels
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
	
	// set up failed saves labels
	failedSavesValueLabel.text = character.failedSaves.stringValue;
	failedSavesValueLabel.font = LEAGUE(44.0f);
	failedSavesValueLabel.textColor = GRAY;
	[UIHelpers applyTextShadow:failedSavesValueLabel];
	
	failedSavesLabel.font = LEAGUE(18.0f);
	failedSavesLabel.textColor = GRAY;
	[UIHelpers applyTextShadow:failedSavesLabel];
	
	// setup PP
	if (!character.usesPp.intValue)
		ppButton.enabled = NO;
	
	// initialize current HP and Surges
	if (character.currentHp == nil) {
		character.currentHp = character.maxHp;
		character.currentSurges = character.maxSurges;
		character.currentPp = character.maxPp;
	}
	
	// set up rest options
	restOptions = [[NSMutableArray alloc] initWithObjects:@"Short Rest", @"Short Rest + Milestone", @"Add Milestone", @"Extended Rest", nil];
	
	// set up start turn button
	startTurnButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	[startTurnButton setTitleColor:GRAY forState:UIControlStateNormal];
	startTurnButton.titleLabel.font = [UIFont fontWithName:@"League Gothic" size:35.0f];
	[startTurnButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[startTurnButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[startTurnButton setTitleEdgeInsets:UIEdgeInsetsMake(9, 10, 10, 10)];
	[UIHelpers applyTextShadow:startTurnButton.titleLabel];
	
	// fix unlabeled combat buttons
	[self configureButton:damageButton LabelText:nil Icon:[UIImage imageNamed:@"swords.png"]];
	[self configureButton:healButton LabelText:nil Icon:[UIImage imageNamed:@"bandaid.png"]];
	[self configureButton:tempHpButton LabelText:nil Icon:[UIImage imageNamed:@"shield.png"]];
	[self configureButton:restButton LabelText:nil Icon:[UIImage imageNamed:@"hourglass.png"]];
	[self configureButton:remindersButton LabelText:nil Icon:[UIImage imageNamed:@"bell.png"]];
	[self configureButton:notesButton LabelText:nil Icon:[UIImage imageNamed:@"scroll.png"]];
	
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

	// set character data in views
	[self refreshCharacter];
	
	// queue up reminders
	turnQueue = [CLTurnQueue queueWithManagedObjectContext:managedObjectContext andCharacter:character];
}

-(void)viewWillAppear:(BOOL)animated
{
	nameLabel.text = character.name;
	raceClassLevelLabel.text = [NSString stringWithFormat:@"LEVEL %@ %@ %@",character.level.stringValue, character.race, character.classname];
	
	[self updateStatLabels];
	
	characterImageView.image = [[UIImage alloc] initWithData:character.photo];
	
	ppButton.enabled = (character.usesPp.intValue) ? YES : NO;
	
	if (character.currentHp == nil)
		character.currentHp = character.maxHp;

	if (character.currentSurges == nil)
		character.currentSurges = character.maxSurges;
	
	if (character.currentPp == nil)
		character.currentPp = character.maxPp;
	
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

/* !Navigation Methods
 * ---------------------------------------------*/
- (void)returnToCharacterList
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

/* !UI Setup/Update Methods
 * ---------------------------------------------*/
-(void)configureButton:(UIButton *)button LabelText:(NSString *)labelText Icon:(UIImage *)icon
{
	
	int y = 10;
	int topInset = 50;
	if (IS_IPHONE_5)
	{
		y = 20;
		topInset = 65;
	}
	
	UIEdgeInsets insets = UIEdgeInsetsMake(topInset, 4, 4, 4);
	
	[button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
	[button setTitleEdgeInsets:insets];
	[button setTitleColor:GRAY forState:UIControlStateNormal];
	button.titleLabel.font = LEAGUE(16.0f);
	
	// drop in icon, if set
	if (icon != nil)
	{
		float x = button.frame.size.width*0.5 - icon.size.width*0.5;
		
		UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, icon.size.width, icon.size.height)];
		iconView.image = icon;
		[button addSubview:iconView];
	}
	
	// create value label
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y+5, 75, 30)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = GRAY;
	label.font = LEAGUE(32.0f);
	label.textAlignment = NSTextAlignmentCenter;
	[UIHelpers applyTextShadow:label];
	if (button.enabled == NO) {
		label.layer.opacity = 0.5;
		button.titleLabel.layer.opacity = 0.5;
		if (icon ==  nil) {
			labelText = @"0";
		}
	}
	if (labelText != nil)
		label.text = labelText;
	[button addSubview:label];
	
	
}

-(void)updateCombatButton:(UIButton *)button Label:(UILabel *)label Value:(NSString *)value
{
	if ([button.subviews.lastObject isKindOfClass:[UILabel class]]) {
		label = button.subviews.lastObject;
		label.text = value;
	}
}

-(void)updateTurnButton
{
	NSString *text = [NSString new];
	if (start)
	{
		text = @"START TURN";
	}
	else
	{
		text = @"END TURN";
	}
	[startTurnButton setTitle:text forState:UIControlStateNormal];
}

- (void)refreshCharacter
{
	// update character info view with data
	nameLabel.text = character.name;
	raceClassLevelLabel.text = [NSString stringWithFormat:@"LEVEL %@ %@ %@",character.level.stringValue, character.race, character.classname];
	
	// update the character image if we have one
	UIImage *characterPhoto;
	if (character.photo != nil)
		characterPhoto = [[UIImage alloc] initWithData:character.photo];
	else
		characterPhoto = [UIImage imageNamed:@"noPhoto.png"];
	
	characterImageView.contentMode = UIViewContentModeScaleAspectFill;
	characterImageView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
	characterImageView.layer.borderWidth = 1.0f;
	characterImageView.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	characterImageView.layer.shadowOffset = CGSizeMake(0,1);
	characterImageView.layer.shadowRadius = 0;
	characterImageView.layer.shadowOpacity = 1;
	characterImageView.image = characterPhoto;
	
	// stat labels
	[self updateStatLabels];
	
	// update start turn button
	[self updateTurnButton];
	
	// update labeled buttons
	[self configureButton:apButton LabelText:character.actionPoints.stringValue Icon:nil];
	[self configureButton:goldButton LabelText:character.gold.stringValue Icon:nil];
	[self configureButton:expButton LabelText:character.experience.stringValue Icon:nil];
	[self configureButton:ppButton LabelText:character.currentPp.stringValue Icon:nil];
	
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

- (void)updateStatLabels
{
	// reset hp and surges
	hpLabel.text = [NSString stringWithFormat:@"%@/%@",character.currentHp, character.maxHp];
	surgesLabel.text = [NSString stringWithFormat:@"%@/%@", character.currentSurges, character.maxSurges];
	
	// reset color of hp and surges labels
	if (character.currentHp.intValue <= character.maxHp.intValue/2)
	{
		hpLabel.textColor = RED;
		hitPoints.textColor = RED;
	}
	else
	{
		hpLabel.textColor = GRAY;
		hitPoints.textColor = GRAY;
	}
	
	if (character.currentSurges.intValue <= character.maxSurges.intValue/2)
	{
		surgesLabel.textColor = YELLOW;
		healingSurges.textColor = YELLOW;
	}
	else
	{
		surgesLabel.textColor = GRAY;
		healingSurges.textColor = GRAY;
	}
	
	// update failed saves value
	failedSavesValueLabel.text = character.failedSaves.stringValue;
	
	// update tempHp Badge and reposition according to size
	[self updateTempHpBadge];
	
}

/* !Interaction Handler Methods
 * ---------------------------------------------*/
- (IBAction)toggleTurn:(id)sender
{
	if (start && IS_DEAD)
	{
		[UIHelpers showDeadAlert];
	}
	else
	{
		// decide which way we're toggling
		if (start)
			[self startTurn];
		else
			[self endTurn];
		
		// toggle button text
		if (start)
			start = NO;
		else
			start = YES;
		[self updateTurnButton];
	}
}

- (IBAction)confirmGainTempHp:(id)sender
{
	if (!(IS_DEAD))
	{
		UIAlertView *gainTempHp = [[UIAlertView alloc] initWithTitle:@"Gain Temp HP" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Gain", nil];
		
		gainTempHp.alertViewStyle = UIAlertViewStylePlainTextInput;
		gainTempHp.tag = 3;
		
		UITextField *field = [gainTempHp textFieldAtIndex:0];
		field.placeholder = @"Temporary HP to Gain";
		field.keyboardType = UIKeyboardTypeNumberPad;
		
		[gainTempHp show];
	}
	else
		[UIHelpers showDeadAlert];
}

-(IBAction)confirmUseActionPoint:(id)sender
{
	if (!(IS_DEAD))
	{
		if (character.actionPoints.intValue > 0) {
			[UIHelpers showConfirmWithTitle:@"Use Action Point?" msg:nil delegate:self tag:1];
		}
		else
			[UIHelpers showAlertWithTitle:@"No Action Points" msg:@"Sorry, no Action Points. Do something awesome, then try again."];
	}
	else
		[UIHelpers showDeadAlert];
}

- (IBAction)confirmUsePowerPoint:(id)sender
{
	if (!(IS_DEAD))
	{
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
}

-(void)startTurn
{
	// handle dying or dead
	if (IS_DYING || IS_DEAD)
	{
		[self handleDying];
	}
	else
	{
		// show startTurn alerts
		if (turnQueue.haveStartReminders)
			[turnQueue presentQueue:1];
	}
}

-(void)endTurn
{
	if (IS_DEAD)
		[self handleDying];
	
	// show endTurn alerts
	if (turnQueue.haveEndReminders)
		[turnQueue presentQueue:0];
}

/* !Data Management Methods
 * ---------------------------------------------*/
-(void)addFailedDeathSave
{
	character.failedSaves = numInt(character.failedSaves.intValue+1);
	[Constants save:managedObjectContext];
	[self updateStatLabels];
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
	if (character.usesPp)
	{
		character.currentPp = character.maxPp;
		[self updateCombatButton:ppButton Label:powerPoints Value:character.maxPp.stringValue];
	}
	
	// reset Milestones to 0
	character.milestones = numInt(0);
	
	// update failed saves
	if (character.failedSaves.intValue > 0)
		character.failedSaves = numInt(0);
	
	
	// update start turn
	start = YES;
	[self updateTurnButton];
	
	//  Commit item to core data
	[Constants save:managedObjectContext];
}

- (void)gainMilestone
{
	if (!(IS_DEAD))
	{
		// gain an action point
		character.actionPoints = numInt(character.actionPoints.intValue + 1);
		[self updateCombatButton:apButton Label:actionPoints Value:character.actionPoints.stringValue];
		
		// save
		[Constants save:managedObjectContext];
	}
	else
	{
		[UIHelpers showDeadAlert];
	}
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
	if (IS_DYING && !(IS_DEAD))
	{
		// Alert: Title: You are dying. Make a saving throw. Message: Did you save?
		UIAlertView *handleDying = [[UIAlertView alloc] initWithTitle:@"You are dying. Make a saving throw." message:@"Did you save?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
		handleDying.tag = 4;
		[handleDying show];
	}
	else if (IS_DEAD)
	{
		[UIHelpers showAlertWithTitle:@"You have died."];
	}
}

- (void)shortRest:(BOOL)milestone
{
	if (!(IS_DEAD))
	{
		// how many surges can we use without going over?
		float deficit = character.maxHp.intValue - character.currentHp.intValue;
		int surges = floor(deficit / character.surgeValue.floatValue);
		
		// use that many surges
		NSDictionary *successfulRest = [Character useHealingSurges:surges forCharacter:character];
		
		if (successfulRest != nil)
		{
			NSLog(@"successful rest: %@", successfulRest);
			NSNumber *surgesUsed = [successfulRest objectForKey:@"surges"];
			NSNumber *amountFromSurges = [successfulRest objectForKey:@"amount"];
			NSString *plural = (surgesUsed.intValue == 1) ? @"surge" : @"surges";
			NSString *message = [NSString stringWithFormat:@"Used %i healing %@ \rand recovered %i HP!", surgesUsed.intValue,plural, amountFromSurges.intValue];
			[UIHelpers showAlertWithTitle:@"You Took A Short Rest" msg:message];
		}
		
		// add a milestone?
		if (milestone)
			[self gainMilestone];
		
		// update failed saves
		if (character.failedSaves.intValue > 0)
			character.failedSaves = numInt(0);
		
		//  Commit item to core data
		[Constants save:managedObjectContext];
		
		[self updateStatLabels];
	}
	else
	{
		[UIHelpers showDeadAlert];
	}
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

/* !UIAlertView Delegate Methods
 * ---------------------------------------------*/
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (alertView.tag) {
		case 1:
			if (buttonIndex == 1) {
				[self useActionPoint];
			}			
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
	[actionSheet showInView:self.view];
}

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

/* !Reminder Delegate Protocol Methods
 * ---------------------------------------------*/
-(void)remindersDidFinish
{
	[self dismissViewControllerAnimated:YES completion:NULL];
	[turnQueue collectQueues];
}

/* !CharacterAddEditDelegate Methods
 * ---------------------------------------------*/
- (void) characterAddEditDidFinish
{
	[self refreshCharacter];
}

/* !Segue Methods
 * ---------------------------------------------*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Damage"])
	{
		UINavigationController *damageNav = segue.destinationViewController;
		damageController = damageNav.viewControllers.firstObject;
		damageController.managedObjectContext = managedObjectContext;
		damageController.character = character;
		damageController.delegate = self;
	}
	else if ([segue.identifier isEqualToString:@"Heal"])
	{
		UINavigationController *healNav = segue.destinationViewController;
		healController = healNav.viewControllers.firstObject;
		healController.managedObjectContext = managedObjectContext;
		healController.character = character;
		healController.delegate = self;
	}
	else if ([segue.identifier isEqualToString:@"Experience"])
	{
		UINavigationController *experienceNav = segue.destinationViewController;
		experienceController = experienceNav.viewControllers.firstObject;
		experienceController.managedObjectContext = managedObjectContext;
		experienceController.character = character;
		experienceController.delegate = self;
	}
	else if ([segue.identifier isEqualToString:@"Gold"])
	{
		UINavigationController *goldNav = segue.destinationViewController;
		goldController = goldNav.viewControllers.firstObject;
		goldController.managedObjectContext = managedObjectContext;
		goldController.character = character;
		goldController.delegate = self;
	}
	else if ([segue.identifier isEqualToString:@"EditCharacter"])
	{
		CharacterAddEdit *characterEdit = segue.destinationViewController;
		characterEdit.managedObjectContext = managedObjectContext;
		characterEdit.character = character;
		characterEdit.delegate = self;
		characterEdit.editing = YES;
		characterEdit.title = @"EDIT CHARACTER";
		characterEdit.navigationItem.hidesBackButton = YES;
		characterEdit.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStylePlain target:characterEdit action:@selector(cancel)];
		[characterEdit.navigationItem setBackBarButtonItem:nil];
	}
	else if ([segue.identifier isEqualToString:@"Notes"])
	{
		UINavigationController *notesNav = segue.destinationViewController;
		notesController = notesNav.viewControllers.firstObject;
		notesController.managedObjectContext = managedObjectContext;
		notesController.character = character;
	}
	else if ([segue.identifier isEqualToString:@"Reminders"])
	{
		UINavigationController *remindersNav = segue.destinationViewController;
		remindersController = remindersNav.viewControllers.firstObject;
		remindersController.managedObjectContext = managedObjectContext;
		remindersController.character = character;
		remindersController.delegate = self;
	}
}



@end
