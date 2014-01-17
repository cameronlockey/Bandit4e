//
//  Combat.h
//  Bandit4e
//
//  Created by Cameron Lockey on 12/23/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharacterAddEdit.h"
#import "CLTurnQueue.h"
#import "CustomBadge.h"
#import "Damage.h"
#import "Experience.h"
#import "Gold.h"
#import "Heal.h"
#import "Notes.h"
#import "Reminders.h"


@class Character;

@interface Combat : UIViewController <CharacterAddEditDelegate, DamageDelegate, HealDelegate, ExperienceDelegate, GoldDelegate, NotesDelegate, ReminderDelegate, UIAlertViewDelegate>
{
	UILabel *actionPoints;
	UILabel *experiencePoints;
	UILabel *gold;
	UILabel *powerPoints;
	CustomBadge *tempBadge;
	CustomBadge *startEndTurnBadge;
	//CustomBadge *endTurnBadge;
	BOOL start;
	UIImageView *banditTitle;
}

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) CLTurnQueue *turnQueue;
@property (strong,nonatomic) Character *character;

@property (strong,nonatomic) Damage *damageController;
@property (strong,nonatomic) Heal *healController;
@property (strong,nonatomic) Experience *experienceController;
@property (strong,nonatomic) Gold *goldController;
@property (strong,nonatomic) Notes *notesController;
@property (strong,nonatomic) Reminders *remindersController;

@property (weak, nonatomic) IBOutlet UIView *characterInfoView;

@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *raceClassLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *hpLabel;
@property (weak, nonatomic) IBOutlet UILabel *surgesLabel;
@property (weak, nonatomic) IBOutlet UILabel *failedSavesValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *failedSavesLabel;
@property (weak, nonatomic) IBOutlet UILabel *hitPoints;
@property (weak, nonatomic) IBOutlet UILabel *healingSurges;

@property (weak, nonatomic) IBOutlet UIButton *damageButton;
@property (weak, nonatomic) IBOutlet UIButton *healButton;
@property (weak, nonatomic) IBOutlet UIButton *apButton;
@property (weak, nonatomic) IBOutlet UIButton *tempHpButton;
@property (weak, nonatomic) IBOutlet UIButton *expButton;
@property (weak, nonatomic) IBOutlet UIButton *restButton;
@property (weak, nonatomic) IBOutlet UIButton *ppButton;
@property (weak, nonatomic) IBOutlet UIButton *goldButton;
@property (weak, nonatomic) IBOutlet UIButton *startTurnButton;
@property (weak, nonatomic) IBOutlet UIButton *remindersButton;
@property (weak, nonatomic) IBOutlet UIButton *notesButton;

/* !Navigation Methods
 * ---------------------------------------------*/
-(void)returnToCharacterList;

/* !UI Setup/Update Methods
 * ---------------------------------------------*/
-(void)configureButton:(UIButton*)button LabelText:(NSString*)labelText Icon:(UIImage*)icon;
-(void)updateCombatButton:(UIButton*)button Label:(UILabel*)label Value:(NSString*)value;
-(void)updateTurnButton;
-(void)refreshCharacter;
-(void)updateTempHpBadge;
-(void)updateStatLabels;

/* !Interaction Handler Methods
 * ---------------------------------------------*/
-(IBAction)toggleTurn:(id)sender;
-(IBAction)confirmGainTempHp:(id)sender;
-(IBAction)confirmUseActionPoint:(id)sender;
-(IBAction)confirmUsePowerPoint:(id)sender;

-(void)startTurn;
-(void)endTurn;

/* !Data Management Methods
 * ---------------------------------------------*/
-(void)addFailedDeathSave;
-(void)extendedRest;
-(void)gainMilestone;
-(void)gainTempHp:(int)tempHp;
-(void)handleDying;
-(void)shortRest:(BOOL)milestone;
-(void)useActionPoint;
-(void)usePowerPoints:(int)points;

@end
